--[[
TheNexusAvenger

Frame containing the buttons.
--]]
--!strict

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local RunTestsButton = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Button"):WaitForChild("RunTestsButton"))
local RunFailedTestsButton = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Button"):WaitForChild("RunFailedTestsButton"))
local RunSelectedTestsButton = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Button"):WaitForChild("RunSelectedTestsButton"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local ButtonSideBar = PluginInstance:Extend()
ButtonSideBar:SetClassName("ButtonSideBar")

export type ButtonSideBar = {
    new: () -> (ButtonSideBar),
    Extend: (self: ButtonSideBar) -> (ButtonSideBar),

    RunTestsButton: RunTestsButton.RunTestsButton,
    RunFailedTestsButton: RunFailedTestsButton.RunFailedTestsButton,
    RunSelectedTestsButton: RunSelectedTestsButton.RunSelectedTestsButton,
} & PluginInstance.PluginInstance & Frame



--[[
Creates a Button Side Bar object.
--]]
function ButtonSideBar:__new(): ()
    PluginInstance.__new(self, "Frame")

    --Create the buttons.
    local RunTests = RunTestsButton.new()
    RunTests.Size = UDim2.new(0, 14, 0, 14)
    RunTests.Position = UDim2.new(0, 7, 0, 7)
    RunTests.Parent = self
    self:DisableChangeReplication("RunTestsButton")
    self.RunTestsButton = RunTests

    local RunFailedTests = RunFailedTestsButton.new()
    RunFailedTests.Size = UDim2.new(0, 14, 0, 14)
    RunFailedTests.Position = UDim2.new(0, 7, 0, 32)
    RunFailedTests.Parent = self
    self:DisableChangeReplication("RunFailedTestsButton")
    self.RunFailedTestsButton = RunFailedTests

    local RunSelectedTests = RunSelectedTestsButton.new()
    RunSelectedTests.Size = UDim2.new(0, 14, 0, 14)
    RunSelectedTests.Position = UDim2.new(0, 7, 0, 57)
    RunSelectedTests.Parent = self
    self:DisableChangeReplication("RunSelectedTestsButton")
    self.RunSelectedTestsButton = RunSelectedTests

    --Set the defaults.
    self.BorderSizePixel = 1
    self.Size = UDim2.new(0, 28, 1, 0)
end



return (ButtonSideBar :: any) :: ButtonSideBar