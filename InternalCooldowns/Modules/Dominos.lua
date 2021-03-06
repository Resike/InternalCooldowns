local mod = LibStub("AceAddon-3.0"):GetAddon("InternalCooldowns"):NewModule("Dominos", "AceEvent-3.0")
local lib = LibStub("LibInternalCooldowns-1.0")
if not _G.Dominos then return end

function mod:OnEnable()
	lib.RegisterCallback(self, "InternalCooldowns_Proc")
end

function mod:OnDisable()
	lib.UnregisterCallback(self, "InternalCooldowns_Proc")
end

function mod:InternalCooldowns_Proc()
	for i = 1, 120 do
		local f = _G["DominosActionButton"..i]
		if f and f:IsVisible() then
			ActionButton_UpdateCooldown(f)
		end
	end
end