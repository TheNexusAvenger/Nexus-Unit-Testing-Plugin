--[[
TheNexusAvenger

Runs the Nexus Unit Testing Plugin.
--]]
--!strict

local PluginToggleButton = require(script:WaitForChild("NexusPluginComponents"):WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("PluginToggleButton"))
local TestListWindow = require(script:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("TestListWindow"))
local OutputWindow = require(script:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("OutputWindow"))



--Create the window.
local OutputView = OutputWindow.new(plugin)
local TestsLists = TestListWindow.new(plugin, OutputView)

--Create the button.
local NexusWidgetsToolbar = plugin:CreateToolbar("Nexus Widgets")
local NexusUnitTestsPlugin = NexusWidgetsToolbar:CreateButton("Unit Tests", "Opens the Nexus Unit Testing window", "https://www.roblox.com/asset/?id=4734891702")
local NexusUnitTestingButton = PluginToggleButton.new(NexusUnitTestsPlugin, TestsLists)
NexusUnitTestingButton.ClickableWhenViewportHidden = true

--Create the actions.
plugin:CreatePluginAction("NexusUnitTesting_RunAllTests", "Run Unit Tests", "Runs all the unit tests in the game.\nPart of Nexus Unit Testing.", "https://www.roblox.com/asset/?id=4734926678").Triggered:Connect(function()
    TestsLists.Enabled = true
    TestsLists.TestListView:RunAllTests()
end)
plugin:CreatePluginAction("NexusUnitTesting_RunFailedTests", "Run Failed Unit Tests", "Runs the failed unit tests from the last run.\nPart of Nexus Unit Testing.", "https://www.roblox.com/asset/?id=4734926820").Triggered:Connect(function()
    TestsLists.Enabled = true
    TestsLists.TestListView:RunFailedTests()
end)
plugin:CreatePluginAction("NexusUnitTesting_RunSelectedTests", "Run Selected Unit Tests", "Runs the selected unit tests from the last run.\nPart of Nexus Unit Testing.", "https://www.roblox.com/asset/?id=4734926979").Triggered:Connect(function()
    TestsLists.Enabled = true
    TestsLists.TestListView:RunSelectedTests()
end)