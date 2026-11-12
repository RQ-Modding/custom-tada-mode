-- Custom TADA Mode. TADA mode (◆２倍モード) doubles battle EXP, battle gold and
-- familiar growth with a hard-coded 2. This mod writes its own multipliers in place of
-- those three 2s, one for each (1.2.0), and its page in Config's Mods tab changes them with no
-- restart.
-- API reference: https://rq-modding.github.io/rq-modding-docs/reference/

local DEFAULT = 2
local MIN, MAX = 1, 100
local OLD_KEY = "multiplier"     -- 1.1's one number for all three, carried over once (1.2.0)
local OLD_CONFIG = "config.ini" -- 1.0.0's file, read once to carry a player's number over

-- The 2s that TADA mode multiplies by, each with its own multiplier (1.2.0) kept in
-- rq.store.global under `key`. Each is the first 2 right after a read of the flag, so they are
-- found by that read (0-based, per function), not by a count of every 2 in the function, which
-- differs between versions of the game's AIN.
local FLAG = "◆２倍モード"
local SPOTS = {
  { key = "gold", what = "battle gold", label = "Battle gold", fn = "Ｔ戦闘後の取得経験値算出", ref = 0,
    tip = "TADA mode's multiplier for the gold a fight gives. The game's own is 2." },  -- ◆取得金額 * 2
  { key = "exp", what = "battle EXP", label = "Battle EXP", fn = "Ｔ戦闘後の取得経験値算出", ref = 1,
    tip = "TADA mode's multiplier for a fight's EXP, before the party size and quest bonuses. The game's own is 2." }, -- bexp * 2
  { key = "familiar", what = "familiar growth", label = "Familiar growth", fn = "Ｔ戦闘前初期化", ref = 0,
    tip = "TADA mode's multiplier for a familiar's growth before each fight. The game's own is 2." }, -- ra *= 2
}
local BY_KEY = {}
for _, s in ipairs(SPOTS) do BY_KEY[s.key] = s end

local function valid(n)
  return math.type(n) == "integer" and n >= MIN and n <= MAX
end

-- 1.0.0 kept the number in config.ini; the first start of 1.1.0 took it from there.
local function from_old_file()
  local f = io.open(OLD_CONFIG, "rb")
  if not f then return nil end
  local text = f:read("a")
  f:close()
  local raw
  for line in text:gmatch("[^\r\n]+") do
    local value = line:match("^%s*multiplier%s*=%s*(.-)%s*$")
    if value then raw = value end
  end
  local n = raw and math.tointeger(tonumber(raw))
  return valid(n) and n or nil
end

-- A player of 1.1 had one number for the three: the first start of 1.2.0 gives it to each.
local store = rq.store.global
local any_new = false
for _, s in ipairs(SPOTS) do
  if valid(store.get(s.key)) then any_new = true end
end
if not any_new then
  local old = store.get(OLD_KEY)
  if not valid(old) then old = from_old_file() end
  if valid(old) then
    for _, s in ipairs(SPOTS) do store.set(s.key, old) end
  end
end
store.delete(OLD_KEY)

-- The places are found once, from the game's 2, then set to each multiplier: a later change writes
-- there, so the comparison's 1 in `if (◆２倍モード == 1)` is never taken for a multiplier.
local mult, places, missing = {}, {}, {}
for _, s in ipairs(SPOTS) do
  local n = store.get(s.key)
  if not valid(n) then n = DEFAULT end
  mult[s.key] = n
  local hit, at = rq.ain.patch_int_after(s.fn, FLAG, DEFAULT, n, s.ref)
  if hit == 1 and at and at[1] then
    places[s.key] = at[1]
  else
    missing[#missing + 1] = s.what
    rq.log("Custom TADA Mode: could not find " .. s.what .. " (the game's code is not as expected)")
  end
end

local function summary()
  local parts = {}
  for _, s in ipairs(SPOTS) do parts[#parts + 1] = s.what .. " " .. mult[s.key] .. "x" end
  return "Custom TADA Mode: TADA mode multiplies " .. table.concat(parts, ", ")
end

-- Writes a multiplier where the game's 2 was. Called by the page's on_change: the page, Reset and
-- the Lab's set all go through it.
local function apply(key, n)
  mult[key] = n
  local p = places[key]
  if p and not rq.ain.set_code_int(p, n) then rq.log("Custom TADA Mode: a place moved; restart the game") end
  rq.log(summary())
end

rq.log(summary())

-- The page is the loader's rq.config.settings, one row for each multiplier in rq.store.global. A
-- place the game's code does not have greys only its own row; Reset stays while one row works.
local rows = {}
for i, s in ipairs(SPOTS) do
  rows[#rows + 1] = { kind = "stepper", key = s.key, id = s.key, label = s.label, min = MIN, max = MAX,
    default = DEFAULT, disabled = places[s.key] == nil, tip = s.tip }
end
rows[#rows + 1] = { kind = "space", h = 4 }
rows[#rows + 1] = { kind = "label", dim = true, size = 15,
  text = "Each is what TADA mode multiplies by, from 1 to 100. The game's own is 2 for all three." }
rows[#rows + 1] = { kind = "label", dim = true, size = 15,
  text = "1 gives what Classic mode gives. A change counts from the next fight; no restart." }
local settings = rq.config.settings{
  id = "custom-tada-mode",
  title = "Custom TADA Mode",
  reset = #missing < #SPOTS,
  rows = rows,
  draw = function(ui)
    ui.space(0, 8)
    if #missing > 0 then
      ui.label("Not found in the game's code: " .. table.concat(missing, ", ") .. ".", { color = { 255, 140, 120 } })
      ui.label("This version of the game is not the one the mod knows.", { dim = true, size = 15 })
      if #missing == #SPOTS then return end
    end
    local mode = rq.game.mode()
    if mode == nil then
      ui.label("Load a save to see whether TADA mode is on in it.", { dim = true, size = 15 })
    else
      ui.label("TADA mode in the loaded save: " .. (mode == "tada" and "on" or "off"), { size = 16 })
    end
  end,
}
settings.on_change(function(key, n)
  if BY_KEY[key] then apply(key, n) end
end)

-- For the Lab: the multipliers and the places' values.
return {
  -- multiplier(what): "gold", "exp" or "familiar"; with none, the gold's (1.1 had one number).
  multiplier = function(what) return mult[what or "gold"] end,
  multipliers = function() return { gold = mult.gold, exp = mult.exp, familiar = mult.familiar } end,
  -- set(n) sets all three; set(what, n) one of them.
  set = function(what, n)
    if n == nil then what, n = nil, what end
    if what ~= nil and not BY_KEY[what] then
      error("custom-tada-mode: set's first value is \"gold\", \"exp\" or \"familiar\"", 2)
    end
    if not valid(n) then error("custom-tada-mode: a multiplier is a whole number from " .. MIN .. " to " .. MAX, 2) end
    for _, s in ipairs(SPOTS) do
      if what == nil or what == s.key then settings.set(s.key, n) end
    end
  end,
  -- The numbers now in the game's code: battle gold, battle EXP, familiar growth.
  places = function()
    local out = {}
    for i, s in ipairs(SPOTS) do out[i] = places[s.key] and rq.ain.code_int(places[s.key]) end
    return out
  end,
}
