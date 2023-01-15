--[[
TheNexusAvenger

Window for the displaying the output of a test.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local OutputView = NexusUnitTestingPluginProject:GetResource("UI.Window.OutputView")
local PluginInstance = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Base.PluginInstance")

local OutputWindow = PluginInstance:Extend()
OutputWindow:SetClassName("OutputWindow")



--[[
Creates a Output Window object.
--]]
function OutputWindow:__new(Plugin)
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
function OutputWindow:SetTest(Test)
    self.Enabled = true
    self.OutputView:SetTest(Test)
end



return OutputWindow