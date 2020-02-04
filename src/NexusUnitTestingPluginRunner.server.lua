--[[
TheNexusAvenger

Runs the Nexus Unit Testing Plugin.
--]]

local NexusUnitTestingPluginProject = require(script.Parent)
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")
local PluginToggleButton = NexusUnitTestingPluginProject:GetResource("UI.PluginToggleButton")
local TestListWindow = NexusUnitTestingPluginProject:GetResource("UI.Window.TestListWindow")


--Create the window.
local TestsLists = TestListWindow.new()

--Create the button.
local NexusWidgetsToolbar = NexusPluginFramework.new("PluginToolbar","Nexus Widgets")
local NexusUnitTestingButton = PluginToggleButton.new(NexusWidgetsToolbar,"Unit Tests","Opens the Nexus Unio Testing window","",TestsLists)
NexusUnitTestingButton.ClickableWhenViewportHidden = true