-- Custom TADA Mode. TADA mode (◆２倍モード) doubles battle EXP, battle gold and
-- familiar growth with a hard-coded 2. This mod reads the multiplier from
-- config.ini in its folder at start and writes it in place of those three 2s.

local CONFIG = "config.ini"
local DEFAULT = 2
local MIN, MAX = 1, 100

-- The 2s that TADA mode multiplies by. Each is the first 2 right after a read of the
-- flag, so they are found by that read (0-based, per function), not by a count of
-- every 2 in the function, which differs between versions of the game's AIN.
local FLAG = "◆２倍モード"
local SPOTS = {
  { what = "battle gold", fn = "Ｔ戦闘後の取得経験値算出", ref = 0 },  -- ◆取得金額 * 2
  { what = "battle EXP", fn = "Ｔ戦闘後の取得経験値算出", ref = 1 },   -- bexp * 2
  { what = "familiar growth", fn = "Ｔ戦闘前初期化", ref = 0 },        -- ra *= 2
}

local NOTE_MS = 15000

local note

local function warn(text)
  rq.log("Custom TADA Mode: " .. text)
  note = "Custom TADA Mode: " .. text
end

-- Returns the multiplier, or nil and why it could not be read.
local function read_multiplier()
  local f = io.open(CONFIG, "rb")
  if not f then
    return nil, CONFIG .. " was not found"
  end
  local text = f:read("a")
  f:close()
  local raw
  for line in text:gmatch("[^\r\n]+") do
    local value = line:match("^%s*multiplier%s*=%s*(.-)%s*$")
    if value then raw = value end
  end
  if raw == nil then
    return nil, "no 'multiplier = ...' line in " .. CONFIG
  end
  local n = tonumber(raw)
  if not n or n ~= math.floor(n) or n < MIN or n > MAX then
    return nil, "multiplier '" .. raw .. "' is not a whole number from " .. MIN .. " to " .. MAX
  end
  return math.tointeger(n)
end

local mult, why = read_multiplier()
if not mult then
  warn(why .. ", using " .. DEFAULT .. "x")
  mult = DEFAULT
end

if mult ~= DEFAULT then
  for _, s in ipairs(SPOTS) do
    local hit = rq.ain.patch_int_after(s.fn, FLAG, DEFAULT, mult, s.ref)
    if hit ~= 1 then
      warn("could not change " .. s.what .. " (the game's code is not as expected)")
    end
  end
end

rq.log("Custom TADA Mode: TADA mode multiplier is " .. mult .. "x")

-- A warning stays on screen for a while after the game starts.
if note then
  local shown_at
  local stop
  stop = rq.on_frame(function()
    local now = rq.time_ms()
    shown_at = shown_at or now
    if now - shown_at > NOTE_MS then
      stop()
      return
    end
    local w = rq.hud.screen()
    local tw = rq.hud.text_width(note, 18)
    rq.hud.rect((w - tw) // 2 - 10, 8, tw + 20, 28, 0, 0, 0, 170)
    rq.hud.text((w - tw) // 2, 12, note, { size = 18, r = 255, g = 210, b = 90 })
  end)
end
