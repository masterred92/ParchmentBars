-- Parchment Bars: an "Old Parchment" bar style for BigWigs, built only from textures already in the client
-- (the Classic auction-house parchment and the tooltip border). Registered with BigWigsAPI:RegisterBarStyle; pick it
-- in BigWigs > Bars > Style. Your bar colours, fonts and sizes stay yours; the style only adds the parchment frame,
-- softens the fill so it reads like ink on paper, and switches the text to dark ink.
local _, ns = ...

local PARCHMENT = "Interface\\QuestFrame\\UI-TextBackground-BackdropBackground"
local BORDER = "Interface\\Tooltips\\UI-Tooltip-Border"
local INK = { 0.18, 0.11, 0.04 }
local FILL_ALPHA = 0.6

local backdrop = { bgFile = PARCHMENT, edgeFile = BORDER, tile = true, tileSize = 64, edgeSize = 10,
  insets = { left = 2, right = 2, top = 2, bottom = 2 } }

local function apply(bar)
  local bd = bar.candyBarBackdrop
  if bd and bd.SetBackdrop then
    bd:ClearAllPoints()
    bd:SetBackdrop(backdrop)
    bd:SetBackdropColor(1, 1, 1, 1)
    bd:SetBackdropBorderColor(0.45, 0.32, 0.16, 1)
    bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
    bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
    bd:Show()
  end
  local bg = bar.candyBarBackground
  if bg then
    bar:Set("parchmentbars:bg", { bg:GetVertexColor() })
    bg:SetVertexColor(1, 1, 1, 0) -- let the parchment show through the empty part of the bar
  end
  local sb = bar.candyBarBar
  if sb then
    local r, g, b, a = sb:GetStatusBarColor()
    bar:Set("parchmentbars:fill", { r, g, b, a })
    sb:SetStatusBarColor(r, g, b, FILL_ALPHA)
  end
  for _, fs in ipairs({ bar.candyBarLabel, bar.candyBarDuration }) do
    if fs then
      fs:SetTextColor(INK[1], INK[2], INK[3], 1)
      fs:SetShadowColor(1, 0.95, 0.8, 0.35)
    end
  end
end

local function stopped(bar)
  if bar.candyBarBackdrop then bar.candyBarBackdrop:Hide() end
  local bg = bar:Get("parchmentbars:bg")
  if bg and bar.candyBarBackground then bar.candyBarBackground:SetVertexColor(bg[1], bg[2], bg[3], bg[4]) end
  local fill = bar:Get("parchmentbars:fill")
  if fill and bar.candyBarBar then bar.candyBarBar:SetStatusBarColor(fill[1], fill[2], fill[3], fill[4]) end
  bar:Set("parchmentbars:bg", nil)
  bar:Set("parchmentbars:fill", nil)
end

ns.style = {
  apiVersion = 1,
  version = 1,
  barSpacing = 7,
  spellIndicatorsOffset = 4,
  ApplyStyle = apply,
  BarStopped = stopped,
  GetStyleName = function() return "Old Parchment" end,
}

function ns.Register()
  if ns.registered or type(BigWigsAPI) ~= "table" or type(BigWigsAPI.RegisterBarStyle) ~= "function" then return ns.registered end
  local ok, err = pcall(BigWigsAPI.RegisterBarStyle, BigWigsAPI, "ParchmentBars", ns.style)
  ns.registered = ok
  if not ok then print("|cffc8a165Parchment Bars|r: BigWigs refused the style (" .. tostring(err) .. ").") end
  return ok
end

ns.Register() -- BigWigs is an OptionalDep, so its API.lua has normally run already

SLASH_PARCHMENTBARS1 = "/parchment"
SlashCmdList.PARCHMENTBARS = function()
  if not ns.registered then print("|cffc8a165Parchment Bars|r: BigWigs isn't loaded.") return end
  print("|cffc8a165Parchment Bars|r: BigWigs > Bars > Style > Old Parchment. Try /localbar 20 Ink drying to see it.")
end
