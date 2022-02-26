--[[
TheNexusAvenger

Runs the Nexus Unit Testing Plugin.
--]]

local NexusUnitTestingPluginProject = require(script.Parent)
local PluginToggleButton = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Input.Custom.PluginToggleButton")
local TestListWindow = NexusUnitTestingPluginProject:GetResource("UI.Window.TestListWindow")
local OutputWindow = NexusUnitTestingPluginProject:GetResource("UI.Window.OutputWindow")


--Create the window.
local OutputView = OutputWindow.new(plugin)
local TestsLists = TestListWindow.new(plugin, OutputView)

--Create the button.
local NexusWidgetsToolbar = plugin:CreateToolbar("Nexus Widgets")
local NexusUnitTestsPlugin = NexusWidgetsToolbar:CreateButton("Unit Tests", "Opens the Nexus Unit Testing window", "http://www.roblox.com/asset/?id=4734891702")
local NexusUnitTestingButton = PluginToggleButton.new(NexusUnitTestsPlugin, TestsLists)
NexusUnitTestingButton.ClickableWhenViewportHidden = true

--Create the actions.
plugin:CreatePluginAction("NexusUnitTesting_RunAllTests","Run Unit Tests","Runs all the unit tests in the game.\nPart of Nexus Unit Testing.","http://www.roblox.com/asset/?id=4734926678").Triggered:Connect(function()
    TestsLists.Enabled = true
    TestsLists.TestListView:RunAllTests()
end)
plugin:CreatePluginAction("NexusUnitTesting_RunFailedTests","Run Failed Unit Tests","Runs the failed unit tests from the last run.\nPart of Nexus Unit Testing.","http://www.roblox.com/asset/?id=4734926820").Triggered:Connect(function()
    TestsLists.Enabled = true
    TestsLists.TestListView:RunFailedTests()
end)
plugin:CreatePluginAction("NexusUnitTesting_RunSelectedTests","Run Selected Unit Tests","Runs the selected unit tests from the last run.\nPart of Nexus Unit Testing.","http://www.roblox.com/asset/?id=4734926979").Triggered:Connect(function()
    TestsLists.Enabled = true
    TestsLists.TestListView:RunSelectedTests()
end)