--[[
TheNexusAvenger

Frame containing the buttons.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local RunTestsButton = NexusUnitTestingPluginProject:GetResource("UI.Button.RunTestsButton")
local RunFailedTestsButton = NexusUnitTestingPluginProject:GetResource("UI.Button.RunFailedTestsButton")
local RunSelectedTestsButton = NexusUnitTestingPluginProject:GetResource("UI.Button.RunSelectedTestsButton")

local ButtonSideBar = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Base.PluginInstance"):Extend()
ButtonSideBar:SetClassName("ButtonSideBar")



--[[
Creates a Button Side Bar object.
--]]
function ButtonSideBar:__new()
    self:InitializeSuper("Frame")

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



return ButtonSideBar