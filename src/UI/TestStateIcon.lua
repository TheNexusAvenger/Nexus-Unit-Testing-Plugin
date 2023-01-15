--[[
TheNexusAvenger

Icon for showing the state of a test.
--]]
--!strict

local NexusUnitTestingPlugin = script.Parent.Parent
local NexusUnitTesting = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local TEST_ICON_SPRITESHEET = "https://www.roblox.com/asset/?id=4595118527"
local ICON_SIZE = Vector2.new(256, 256)

local ICON_POSITIONS = {
    [NexusUnitTesting.TestState.NotRun] = Vector2.new(0, 0),
    [NexusUnitTesting.TestState.InProgress] = Vector2.new(256, 0),
    [NexusUnitTesting.TestState.Passed] = Vector2.new(512, 0),
    [NexusUnitTesting.TestState.Failed] = Vector2.new(768, 0),
    [NexusUnitTesting.TestState.Skipped] = Vector2.new(0, 256),
}
local ICON_COLORS = {
    [NexusUnitTesting.TestState.NotRun] = Color3.fromRGB(0, 170, 255),
    [NexusUnitTesting.TestState.InProgress] = Color3.fromRGB(255, 150, 0),
    [NexusUnitTesting.TestState.Passed] = Color3.fromRGB(0, 200, 0),
    [NexusUnitTesting.TestState.Failed] = Color3.fromRGB(200, 0, 0),
    [NexusUnitTesting.TestState.Skipped] = Color3.fromRGB(220, 220, 0),
}

local TestStateIcon = PluginInstance:Extend()
TestStateIcon:SetClassName("TestStateIcon")

export type TestStateIcon = {
    new: () -> (TestStateIcon),
    Extend: (self: TestStateIcon) -> (TestStateIcon),

    TestState: string,
    HasOutput: boolean,
} & PluginInstance.PluginInstance & ImageLabel



--[[
Creates the Test State Icon.
--]]
function TestStateIcon:__new(): ()
    PluginInstance.__new(self, "ImageLabel")

    --Set up changing the test state.
    self:DisableChangeReplication("TestState")
    self:GetPropertyChangedSignal("TestState"):Connect(function()
        self.ImageColor3 = ICON_COLORS[self.TestState]
        self.ImageRectOffset = ICON_POSITIONS[self.TestState]
    end)

    --Add an indicator for if there is any output.
    local OutputIndicator = PluginInstance.new("Frame")
    OutputIndicator.BackgroundColor3 = Color3.new(0, 170/255, 255/255)
    OutputIndicator.Size = UDim2.new(0.5, 0, 0.5, 0)
    OutputIndicator.Position = UDim2.new(0.5, 0, 0.5, 0)
    OutputIndicator.Parent = self

    local UICorner = PluginInstance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = OutputIndicator
    self:DisableChangeReplication("OutputIndicator")
    self.OutputIndicator = OutputIndicator

    --Set up showing and hiding the indicator.
    self:DisableChangeReplication("HasOutput")
    self:GetPropertyChangedSignal("HasOutput"):Connect(function()
        OutputIndicator.Visible = self.HasOutput
    end)

    --Set the defaults.
    self.BackgroundTransparency = 1
    self.Image = TEST_ICON_SPRITESHEET
    self.ImageRectSize = ICON_SIZE
    self.TestState = NexusUnitTesting.TestState.NotRun
    self.HasOutput = false
end



return (TestStateIcon :: any) :: TestStateIcon