local ICD = LibStub("AceAddon-3.0"):GetAddon("InternalCooldowns")
local mod = ICD:NewModule("Sink", "AceEvent-3.0", "LibSink-2.0", "AceTimer-3.0")
local lib = LibStub("LibInternalCooldowns-1.0")

local defaults = {profile = {sinkOptions = {}}}
local options = {type = "group", name = "Scrolling Combat Text", args = {}}
local times = {}
local frame = CreateFrame("Frame")

function mod:OnInitialize()
	self.db = ICD.db:RegisterNamespace("Sink", defaults)
	options.args.output = self:GetSinkAce3OptionsDataTable()
	ICD.options.args.SCT = options	
	self:SetSinkStorage(self.db.profile.sinkOptions)
end

function mod:OnEnable()
	lib.RegisterCallback(self, "InternalCooldowns_Proc")
	lib.RegisterCallback(self, "InternalCooldowns_TalentProc")
end

function mod:OnDisable()
	lib.UnregisterCallback(self, "InternalCooldowns_Proc")
	lib.UnregisterCallback(self, "InternalCooldowns_TalentProc")
end

function mod:InternalCooldowns_Proc(event, itemID, spellID, start, duration)
	frame:SetScript("OnUpdate", mod.ProcessTimers)
	times[itemID] = start + duration
end

function mod:InternalCooldowns_TalentProc(event, spellID, start, duration)
	frame:SetScript("OnUpdate", mod.ProcessTimers)
	times["spell:" .. spellID] = start + duration
end

function mod.ProcessTimers()
	local t = GetTime()
	local total = 0
	for itemID, upAt in pairs(times) do
		if upAt < t then
			local spellID, name, tex
			if type(itemID) == "string" then
				spellID = itemID:match("spell:(%d+)")
			end
			if spellID then
				name = select(1, GetSpellInfo(tonumber(spellID)))
				tex = select(3, GetSpellInfo(tonumber(spellID)))
			else
				name = select(1, GetItemInfo(itemID))
				tex = select(10, GetItemInfo(itemID))
			end
			mod:Pour(("%s: %s"):format(L["ICD Ready"], name), 1, 1, 0, nil, 24, "OUTLINE", true, nil, tex)
			times[itemID] = nil
		else
			total = total + 1
		end
	end
	if total == 0 then
		frame:SetScript("OnUpdate", nil)
	end
end