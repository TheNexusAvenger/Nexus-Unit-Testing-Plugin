--[[
TheNexusAvenger

Window for the list of tests and actions.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local TestListView = NexusUnitTestingPluginProject:GetResource("UI.Window.TestListView")

local TestListWindow = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Plugin.NexusPluginGui"):Extend()
TestListWindow:SetClassName("TestListWindow")



--[[
Creates a Test List Window object.
--]]
function TestListWindow:__new(OutputWindow)
	self:InitializeSuper("Unit Tests",DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Bottom,false,false,300,200,200,100))
	
	--Add the test list frame.
	local ListView = TestListView.new()
	ListView.Size = UDim2.new(1,0,1,0)
	ListView.Parent = self
	
	--Connect setting the output.
	ListView.TestOutputOpened:Connect(function(Test,DontForceEnabled)
		if DontForceEnabled ~= true or OutputWindow.Enabled then
			OutputWindow:SetTest(Test)
		end
	end)
end



return TestListWindow