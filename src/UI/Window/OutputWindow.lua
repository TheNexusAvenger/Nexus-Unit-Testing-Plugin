--[[
TheNexusAvenger

Window for the displaying the output of a test.
--]]
--!strict

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local OutputView = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("OutputView"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))
local UnitTest = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("UnitTest"):WaitForChild("UnitTest"))

local OutputWindow = PluginInstance:Extend()
OutputWindow:SetClassName("OutputWindow")

export type OutputWindow = {
    new: (Plugin: Plugin) -> (OutputWindow),
    Extend: (self: OutputWindow) -> (OutputWindow),

    SetTest: (self: OutputWindow, Test: UnitTest.UnitTest) -> (),
} & PluginInstance.PluginInstance & DockWidgetPluginGui



--[[
Creates a Output Window object.
--]]
function OutputWindow:__new(Plugin: Plugin)
    PluginInstance.__new(self, Plugin:CreateDockWidgetPluginGui("Test Output", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Bottom, false, false, 300, 200, 200, 100)))
    self.Title = "Test Output"
    self.Name = "Test Output"

    --Add the output view.
    local Output = OutputView.new()
    Output.Size = UDim2.new(1, 0, 1, 0)
    Output.Parent = self
    self:DisableChangeReplication("OutputView")
    self.OutputView = Output
end

--[[
Sets the test to display.
--]]
function OutputWindow:SetTest(Test: UnitTest.UnitTest): ()
    self.Enabled = true
    self.OutputView:SetTest(Test)
end



return OutputWindow