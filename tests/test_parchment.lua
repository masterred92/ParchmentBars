package.path = "./tests/?.lua;" .. package.path
local M = require("mock_wow")
M.install()
-- BigWigsAPI:RegisterBarStyle with the same validation as BigWigs API.lua
local styles = {}
BigWigsAPI = {}
function BigWigsAPI:RegisterBarStyle(key, s)
  assert(type(key) == "string" and type(s) == "table" and type(s.version) == "number" and s.apiVersion == 1)
  assert(type(s.GetStyleName) == "function" and type(s:GetStyleName()) == "string")
  if styles[key] and styles[key].version == s.version then error("already exists") end
  styles[key] = s
end
local ns = M.loadAddon(".", "ParchmentBars")
M.check(styles.ParchmentBars and styles.ParchmentBars:GetStyleName() == "Old Parchment", "style registered")
M.check(ns.Register() == true, "second register is a no-op")

-- a LibCandyBar-like bar
local function region()
  local r = { color = { 0.25, 0.33, 0.68, 1 }, shown = false }
  function r:SetVertexColor(...) self.color = { ... } end
  function r:GetVertexColor() return unpack(self.color) end
  function r:SetStatusBarColor(...) self.color = { ... } end
  function r:GetStatusBarColor() return unpack(self.color) end
  function r:SetTextColor(...) self.text = { ... } end
  function r:SetShadowColor(...) self.shadow = { ... } end
  function r:SetBackdrop(b) self.backdrop = b end
  function r:SetBackdropColor() end
  function r:SetBackdropBorderColor() end
  function r:ClearAllPoints() end
  function r:SetPoint() end
  function r:Show() self.shown = true end
  function r:Hide() self.shown = false end
  return r
end
local bar = { data = {}, candyBarBackdrop = region(), candyBarBackground = region(), candyBarBar = region(),
  candyBarLabel = region(), candyBarDuration = region() }
function bar:Set(k, v) self.data[k] = v end
function bar:Get(k) return self.data[k] end
local st = styles.ParchmentBars
st.ApplyStyle(bar)
M.check(bar.candyBarBackdrop.shown and bar.candyBarBackdrop.backdrop.bgFile:find("UI%-TextBackground%-BackdropBackground"), "parchment backdrop shown")
M.check(bar.candyBarBackdrop.backdrop.edgeFile == "Interface\\Tooltips\\UI-Tooltip-Border", "tooltip border")
M.check(select(4, bar.candyBarBar:GetStatusBarColor()) == 0.6 and bar.candyBarBar.color[1] == 0.25, "keeps your bar colour, softened")
M.check(bar.candyBarLabel.text[1] < 0.3, "dark ink label")
st.BarStopped(bar)
M.check(not bar.candyBarBackdrop.shown, "backdrop hidden when the bar stops")
M.check(select(4, bar.candyBarBar:GetStatusBarColor()) == 1 and select(4, bar.candyBarBackground:GetVertexColor()) == 1, "colours restored")
M.check(bar:Get("parchmentbars:fill") == nil, "bar data cleaned")
M.done("ParchmentBars")
