local vUI, GUI, Language, Media, Settings = select(2, ...):get()

-- The most important file there is.

-- Cinematic Mode with black lines on the top and bottom of the screen. Reposition the UI parent
-- Notification system with a bell icon under the minimap or something. This is just a small log where it shows things like version handshakes, update news etc

local Debug = '"%s" set to %s.'
local floor = floor
local format = format
local tostring = tostring

local GetFramerate = GetFramerate

-- This is currently just a test page to text how GUI controls work, and debug them.
GUI:AddOptions(function(self)
	local Left, Right = self:NewWindow("Test")
	
	Left:CreateHeader(Language["Checkboxes"])
	Left:CreateCheckbox("test-checkbox-1", true, "Checkbox Demo", "Enable something", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Left:CreateCheckbox("test-checkbox-2", true, "Checkbox Demo", "Enable something", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Left:CreateCheckbox("test-checkbox-3", false, "Checkbox Demo", "Show the textuals", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	
	Right:CreateHeader(Language["Selections"])
	Right:CreateDropdown("test-dropdown-1", "Roboto", Media:GetFontList(), "Font Menu Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end, "Font")
	Right:CreateDropdown("test-dropdown-2", "Blank", Media:GetTextureList(), "Texture Menu Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end, "Texture")
	Right:CreateDropdown("test-dropdown-3", "RenHorizonUp", Media:GetHighlightList(), "Highlight Menu Demo", "", function(v, id)vUI:print(format(Debug, id, tostring(v))) end, "Texture")
	
	Right:CreateHeader(Language["Sliders"])
	Right:CreateSlider("test-slider-1", 3, 0, 10, 1, "Slider Demo", "doesn't matter", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Right:CreateSlider("test-slider-2", 7, 0, 10, 1, "Slider Demo", "doesn't matter", function(v, id) vUI:print(format(Debug, id, tostring(v))) end, nil, " px")
	Right:CreateSlider("test-slider-3", 4, 0, 10, 1, "Slider Demo", "doesn't matter", function(v, id) vUI:print(format(Debug, id, tostring(v))) end, nil, " s")
	
	Right:CreateHeader(Language["Buttons"])
	Right:CreateButton("Test", "Button Demo", "Enable something", function() vUI:print("test-button-1") end)
	Right:CreateButton("Test", "Button Demo", "Enable something", function() vUI:print("test-button-2") end)
	Right:CreateButton("Test", "Button Demo", "Enable something", function() vUI:print("test-button-3") end)
	
	Left:CreateHeader(Language["Switches"])
	Left:CreateSwitch("test-switch-1", true, "Switch Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Left:CreateSwitch("test-switch-2", true, "Switch Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Left:CreateSwitch("test-switch-3", false, "Switch Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	
	Left:CreateHeader(Language["Colors"])
	Left:CreateColorSelection("test-color-1", "B0BEC5", "Color Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Left:CreateColorSelection("test-color-2", "607D8B", "Color Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	Left:CreateColorSelection("test-color-3", "263238", "Color Demo", "", function(v, id) vUI:print(format(Debug, id, tostring(v))) end)
	
	Left:CreateHeader(Language["StatusBars"])
	
	local Bar = Left:CreateStatusBar(0, 0, 0, "Statusbar Demo", "", function(v)
		Framerate = floor(GetFramerate())
		
		return 0, 350, Framerate, Framerate
	end)
	
	Left:CreateStatusBar(5, 0, 10, "Statusbar Demo", "")
	Left:CreateStatusBar(75, 0, 100, "Statusbar Demo", "", nil, "%")
	
	Bar.Ela = 0
	Bar:SetScript("OnUpdate", function(self, ela)
		self.Ela = self.Ela + ela
		
		if (self.Ela >= 1) then
			local Min, Max, Value, Text = self.Hook()
			
			self:SetMinMaxValues(Min, Max)
			self.MiddleText:SetText(Text)
			
			self.Anim:SetChange(Value)
			self.Anim:Play()
			
			self.Ela = 0
		end
	end)
	
	Bar:GetScript("OnUpdate")(Bar, 1)
	
	Right:CreateHeader(Language["Lines"])
	Right:CreateLine("Test Line 1")
	Right:CreateLine("Test Line 2")
	Right:CreateLine("Test Line 3")
	
	Right:CreateHeader(Language["Double Lines"])
	Right:CreateDoubleLine("Test Line 1", "Hello World 1")
	Right:CreateDoubleLine("Test Line 2", "Hello World 2")
	Right:CreateDoubleLine("Test Line 3", "Hello World 3")
	
	Left:CreateHeader(Language["Inputs"])
	Left:CreateInput("test-input-1", vUI.User, "Test Input 1", nil, function(v) print(v) end)
	Left:CreateInput("test-input-2", vUI.User, "Test Input 2", nil, function(v) print(v) end)
	Left:CreateInput("test-input-3", vUI.User, "Test Input 3", nil, function(v) print(v) end)
	
	Left:CreateFooter()
	Right:CreateFooter()
	
	-- Testing
	self:NewWindow("Unit Frames")
	self:NewWindow("Tooltips")
	self:NewWindow("Misc.")
	self:NewWindow("Search")
end)

GUI:AddOptions(function(self)
	local Left, Right = self:NewWindow("Info")
	
	Left:CreateHeader("UI Information")
	Left:CreateDoubleLine("Version", vUI.Version)
	Left:CreateDoubleLine("UI Scale", Settings["ui-scale"].."%")
	Left:CreateDoubleLine("Resolution", select(GetCurrentResolution(), GetScreenResolutions()))
	Left:CreateDoubleLine("Profile", vUIData and vUIData["ui-profile"] or "Default")
	Left:CreateDoubleLine("Template", Settings["ui-template"])
	Left:CreateDoubleLine("Locale", vUI.Locale)
	
	Right:CreateHeader("User Information")
	Right:CreateDoubleLine("User", vUI.User)
	Right:CreateDoubleLine("Class", vUI.Class)
	Right:CreateDoubleLine("Realm", vUI.Realm)
end)