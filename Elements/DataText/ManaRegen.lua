local vUI, GUI, Language, Media, Settings = select(2, ...):get()

local DT = vUI:GetModule("DataText")

local GetManaRegen = GetManaRegen
local InCombatLockdown = InCombatLockdown
local Label = Language["Regen"]

local Update = function(self, event, unit)
	if (unit and unit ~= "player") then
		return
	end
	
	local Base, Casting = GetManaRegen()
	local Regen
	
	if InCombatLockdown() then
		Regen = Casting * 5
	else
		Regen = Base * 5
	end
	
	self.Text:SetFormattedText("%s: %.2f", Label, Regen)
end

local OnEnable = function(self)
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:SetScript("OnEvent", Update)
	
	self:Update("player")
end

local OnDisable = function(self)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:SetScript("OnEvent", nil)
	
	self.Text:SetText("")
end

DT:SetType("Regen", OnEnable, OnDisable, Update)