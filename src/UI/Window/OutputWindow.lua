--[[
TheNexusAvenger

Window for the displaying the output of a test.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local OutputView = NexusUnitTestingPluginProject:GetResource("UI.Window.OutputView")

local OutputWindow = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Plugin.NexusPluginGui"):Extend()
OutputWindow:SetClassName("OutputWindow")



--[[
Creates a Output Window object.
--]]
function OutputWindow:__new()
	self:InitializeSuper("Test Output",DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Bottom,false,false,300,200,200,100))
	
	--Add the output frame.
	local Output = OutputView.new()
	Output.Size = UDim2.new(1,0,1,0)
	Output.Parent = self
	
	--Store the output view.
	self:__SetChangedOverride("OutputView",function() end)
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