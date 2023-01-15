--[[
TheNexusAvenger

Window for the list of tests and actions.
--]]
--!strict

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local OutputWindow = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("OutputWindow"))
local TestListView = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("TestListView"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local TestListWindow = PluginInstance:Extend()
TestListWindow:SetClassName("TestListWindow")

export type TestListWindow = {
    new: (Plugin: Plugin, OutputWindow: OutputWindow.OutputWindow) -> (TestListWindow),
    Extend: (self: TestListWindow) -> (TestListWindow),
} & PluginInstance.PluginInstance & Frame



--[[
Creates a Test List Window object.
--]]
function TestListWindow:__new(Plugin: Plugin, OutputWindow: OutputWindow.OutputWindow): ()
    PluginInstance.__new(self, Plugin:CreateDockWidgetPluginGui("Unit Tests", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Bottom, false, false, 300, 200, 200, 100)))
    self.Title = "Unit Tests"
    self.Name = "Unit Tests"

    --Add the test list frame.
    local ListView = TestListView.new()
    ListView.Size = UDim2.new(1, 0, 1, 0)
    ListView.Parent = self:GetWrappedInstance()
    self:DisableChangeReplication("TestListView")
    self.TestListView = ListView

    --Connect setting the output.
    ListView.TestOutputOpened:Connect(function(Test, DontForceEnabled)
        if DontForceEnabled ~= true or OutputWindow.Enabled then
            OutputWindow:SetTest(Test)
        end
    end)
end



return (TestListWindow :: any) :: TestListWindow