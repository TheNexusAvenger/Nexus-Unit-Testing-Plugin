--[[
TheNexusAvenger

Toggle button for a PluginGui.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent)

local PluginToggleButton = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Plugin.NexusPluginButton"):Extend()
PluginToggleButton:SetClassName("PluginToggleButton")



--[[
Creates a Plugin Toggle Button.
--]]
function PluginToggleButton:__new(Toolbar,ButtonName,ButtonTooltip,ButtonIcon,PluginGui)
	self:InitializeSuper(Toolbar,ButtonName,ButtonTooltip,ButtonIcon)
	
	--Set up the changed event.
	PluginGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		self.Active = PluginGui.Enabled
	end)
	
	--Set the default.
	self.Active = PluginGui.Enabled
end



return PluginToggleButton