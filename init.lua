-- Custom TADA Mode. TADA mode (◆２倍モード) doubles battle EXP, battle gold and
-- familiar growth with a hard-coded 2. This mod writes its own multiplier in place of
-- those three 2s, and its page in Config's Mods tab changes it with no restart.
-- API reference: https://rq-modding.github.io/rq-modding-docs/reference/

local DEFAULT = 2
local MIN, MAX = 1, 100
local KEY = "multiplier"
local OLD_CONFIG = "config.ini" -- 1.0.0's file, read once to carry a player's number over

-- The 2s that TADA mode multiplies by. Each is the first 2 right after a read of the
-- flag, so they are found by that read (0-based, per function), not by a count of
-- every 2 in the function, which differs between versions of the game's AIN.
local FLAG = "◆２倍モード"
local SPOTS = {
  { what = "battle gold", fn = "Ｔ戦闘後の取得経験値算出", ref = 0 },  -- ◆取得金額 * 2
  { what = "battle EXP", fn = "Ｔ戦闘後の取得経験値算出", ref = 1 },   -- bexp * 2
  { what = "familiar growth", fn = "Ｔ戦闘前初期化", ref = 0 },        -- ra *= 2
}

local function valid(n)
  return math.type(n) == "integer" and n >= MIN and n <= MAX
end

-- 1.0.0 kept the number in config.ini; the first start of 1.1.0 takes it from there.
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

local mult = rq.store.global.get(KEY)
if not valid(mult) then
  mult = from_old_file() or DEFAULT
  rq.store.global.set(KEY, mult)
end

-- The places are found once, from the game's 2: a later change writes there, so the
-- comparison's 1 in `if (◆２倍モード == 1)` is never taken for the multiplier.
local places, missing = {}, {}
for _, s in ipairs(SPOTS) do
  local hit, at = rq.ain.patch_int_after(s.fn, FLAG, DEFAULT, mult, s.ref)
  if hit == 1 and at and at[1] then
    places[#places + 1] = at[1]
  else
    missing[#missing + 1] = s.what
    rq.log("Custom TADA Mode: could not find " .. s.what .. " (the game's code is not as expected)")
  end
end

-- Writes the number where the game's 2s were. Called by the page's on_change: the page, Reset and
-- the Lab's set all go through it.
local function apply(n)
  mult = n
  for _, p in ipairs(places) do
    if not rq.ain.set_code_int(p, n) then rq.log("Custom TADA Mode: a place moved; restart the game") end
  end
  rq.log("Custom TADA Mode: TADA mode multiplier is " .. n .. "x")
end

rq.log("Custom TADA Mode: TADA mode multiplier is " .. mult .. "x")

-- The page is the loader's rq.config.settings (1.1.1), on the same key in rq.store.global. While the
-- game's code is not as expected the field is greyed and there is no Reset.
local settings = rq.config.settings{
  id = "custom-tada-mode",
  title = "Custom TADA Mode",
  reset = #missing == 0,
  rows = {
    { kind = "stepper", key = KEY, id = "multiplier", label = "TADA mode multiplier", min = MIN, max = MAX,
      default = DEFAULT, disabled = #missing > 0, tip = "What TADA mode multiplies by. The game's own is 2.",
      note = { "It multiplies battle EXP, battle gold and familiar growth.",
        "A change counts from the next fight; no restart." } },
  },
  draw = function(ui)
    ui.space(0, 8)
    if #missing > 0 then
      ui.label("Not found in the game's code: " .. table.concat(missing, ", ") .. ".", { color = { 255, 140, 120 } })
      ui.label("This version of the game is not the one the mod knows.", { dim = true, size = 15 })
      return
    end
    local on = rq.ain.global(FLAG)
    if on == nil then
      ui.label("Load a save to see whether TADA mode is on in it.", { dim = true, size = 15 })
    else
      ui.label("TADA mode in the loaded save: " .. (on == 1 and "on" or "off"), { size = 16 })
    end
  end,
}
settings.on_change(function(_, n) apply(n) end)

-- For the Lab: the multiplier and the places' values.
return {
  multiplier = function() return mult end,
  set = function(n)
    if not valid(n) then error("custom-tada-mode: the multiplier is a whole number from " .. MIN .. " to " .. MAX, 2) end
    settings.set(KEY, n)
  end,
  places = function()
    local out = {}
    for i, p in ipairs(places) do out[i] = rq.ain.code_int(p) end
    return out
  end,
}
