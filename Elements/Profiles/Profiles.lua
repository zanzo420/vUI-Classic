local vUI, GUI, Language, Media, Settings, Defaults, Profiles = select(2, ...):get()

local DefaultKey = "%s-%s"
local pairs = pairs
local date = date

Profiles.List = {}

local Filter = {
	["profile-created"] = true,
	["profile-last-modified"] = true,
}

local GetCurrentDate = function()
	--return date("%Y-%m-%d")
	return date("%Y-%m-%d %I:%M %p")
end

function Profiles:ImportProfiles()
	if vUIProfiles then
		for Name in pairs(vUIProfiles) do
			self.List[Name] = Name
		end
	end
end

function Profiles:GetNumProfiles()
	local Count = 0
	
	for Name in pairs(self.List) do
		Count = Count + 1
	end
	
	return Count
end

function Profiles:GetDefaultProfileKey()
	return format(DefaultKey, vUI.User, vUI.Realm)
end

function Profiles:SetLastModified(name)
	local Profile = self:GetProfile(name)
	
	Profile["profile-last-modified"] = GetCurrentDate()
end

function Profiles:GetActiveProfileName() -- Will this ever be called in a case where it needs a fallback?
	if (vUIProfileData and vUIProfileData[vUI.Realm]) then
		if vUIProfileData[vUI.Realm][vUI.User] then
			return vUIProfileData[vUI.Realm][vUI.User]
		end
	end
end

function Profiles:GetActiveProfile()
	if (vUIProfileData and vUIProfileData[vUI.Realm]) then
		if vUIProfileData[vUI.Realm][vUI.User] then
			return self:GetProfile(vUIProfileData[vUI.Realm][vUI.User])
		end
	end
end

function Profiles:SetActiveProfile(name)
	if (vUIProfileData and vUIProfileData[vUI.Realm]) then
		if vUIProfileData[vUI.Realm][vUI.User] then
			vUIProfileData[vUI.Realm][vUI.User] = name
		end
	end
end

function Profiles:CountChangedValues(name)
	local Profile = self:GetProfile(name)
	local Count = 0
	
	for ID, Value in pairs(Profile) do
		if (not Filter[ID]) then
			Count = Count + 1
		end
	end
	
	return Count
end

function Profiles:CreateProfile(name)
	if (not vUIProfiles) then
		vUIProfiles = {}
	end
	
	if (not vUIProfileData) then
		vUIProfileData = {}
		vUIProfileData[vUI.Realm] = {}
	end
	
	if (not name) then
		name = self:GetDefaultProfileKey()
	end
	
	if vUIProfiles[name] then
		self.List[name] = name
		
		vUIProfileData[vUI.Realm][vUI.User] = name
		
		return vUIProfiles[name]
	end
	
	vUIProfiles[name] = {}
	vUIProfiles[name]["profile-created"] = GetCurrentDate()
	vUIProfiles[name]["profile-last-modified"] = GetCurrentDate()
	vUIProfileData[vUI.Realm][vUI.User] = name
	
	self.List[name] = name
	
	return vUIProfiles[name]
end

function Profiles:GetProfile(name)
	if vUIProfiles[name] then
		return vUIProfiles[name]
	else
		return vUIProfiles["Default"]
	end
end

function Profiles:GetProfileList()
	return self.List
end

function Profiles:GetMostUsedProfile() -- Return most used profile as a fallback instead of "Default" which may not even exist if the user deletes it
	local Temp = {}
	
	for Realm, Value in pairs(vUIProfileData) do
		for Player, ProfileName in pairs(Value) do
			Temp[ProfileName] = (Temp[ProfileName] or 0) + 1
		end
	end
	
	local HighestValue = 0
	local HighestName
	
	for Name, Value in pairs(Temp) do
		if (Value > HighestValue) then
			HighestValue = Value
			HighestName = Name
		end
	end
	
	return HighestName
end

function Profiles:DeleteProfile(name)
	if vUIProfiles[name] then
		vUIProfiles[name] = nil
		self.List[name] = nil
		
		local Default = self:GetMostUsedProfile()
		
		-- If we just wiped out a profile that characters were using, reroute them to a different profile for the time being.
		for Realm, Value in pairs(vUIProfileData) do
			for Player, ProfileName in pairs(Values) do
				if (ProfileName == name) then
					vUIProfileData[Realm][Player] = Default
				end
			end
		end
		
		vUI:print(format('Deleted profile "%s".', name))
	else
		vUI:print(format('No profile exists with the name "%s".', name))
	end
end

function Profiles:MergeWithDefaults(name)
	local Values = {}
	
	-- Collect default values
	for ID, Value in pairs(Defaults) do
		Values[ID] = Value
	end
	
	-- And apply stored values
	for ID, Value in pairs(self:GetProfile(name)) do
		Values[ID] = Value
	end
	
	return Values
end

function Profiles:ApplyProfile(name)
	--[[if (not vUIProfiles[name]) then -- I think we're protected against this, and will manage default if needed?
		return
	end]]
	
	local Values = self:MergeWithDefaults(name)
	
	for ID, Value in pairs(Values) do
		Settings[ID] = Value
	end
	
	vUIProfileData[vUI.Realm][vUI.User] = name
end