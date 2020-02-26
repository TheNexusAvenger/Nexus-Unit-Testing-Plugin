--[[
TheNexusAvenger

Runs the Nexus Unit Testing Plugin.
--]]

local NexusUnitTestingPluginProject = require(script.Parent)
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")
local PluginToggleButton = NexusUnitTestingPluginProject:GetResource("UI.PluginToggleButton")
local TestListWindow = NexusUnitTestingPluginProject:GetResource("UI.Window.TestListWindow")
local OutputWindow = NexusUnitTestingPluginProject:GetResource("UI.Window.OutputWindow")


--Create the window.
NexusPluginFramework:SetPlugin(plugin)
local OutputView = OutputWindow.new()
local TestsLists = TestListWindow.new(OutputView)

--Create the button.
local NexusWidgetsToolbar = NexusPluginFramework.new("PluginToolbar","Nexus Widgets")
local NexusUnitTestingButton = PluginToggleButton.new(NexusWidgetsToolbar,"Unit Tests","Opens the Nexus Unit Testing window","http://www.roblox.com/asset/?id=4734891702",TestsLists)
NexusUnitTestingButton.ClickableWhenViewportHidden = true