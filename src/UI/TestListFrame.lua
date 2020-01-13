--[[
TheNexusAvenger

Icon for showing the state of a test.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent)
local TestStateIcon = NexusUnitTestingPluginProject:GetResource("UI.TestStateIcon")
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")

local TestListFrame = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.UI.CollapsableList.NexusCollapsableListFrame"):Extend()
TestListFrame:SetClassName("TestListFrame")



--[[
Creates a Test List Frame object.
--]]
function TestListFrame:__new(Test)
	self:InitializeSuper()
	
	--Store the test.
	self:__SetChangedOverride("Test",function() end)
	self.Test = Test
	
	--Create the icon.
	local Icon = TestStateIcon.new()
	Icon.Hidden = true
	Icon.Size = UDim2.new(0,16,0,16)
	Icon.Position = UDim2.new(0,2,0,2)
	Icon.TestState = Test.CombinedState
	Icon.Parent = self:GetMainContainer()
	
	--Create the text for the test name.
	local TestNameLabel = NexusPluginFramework.new("TextLabel")
	TestNameLabel.Hidden = true
	TestNameLabel.Size = UDim2.new(1,-24,0,16)
	TestNameLabel.Position = UDim2.new(0,22,0,1)
	TestNameLabel.Text = Test.Name
	TestNameLabel.Parent = self:GetMainContainer()
	
	--Create the list constraint.
	local UIListLayout = NexusPluginFramework.new("UIListLayout")
	UIListLayout.Hidden = true
	UIListLayout.Parent = self:GetCollapsableContainer()
	
	--Add the existing subtests.
	for _,SubTest in pairs(Test.SubTests) do
		local NewListFrame = TestListFrame.new(SubTest)
		NewListFrame.Parent = self:GetCollapsableContainer()
	end
	
	--Connect changing the test state.
	Test:GetPropertyChangedSignal("CombinedState"):Connect(function()
		Icon.TestState = Test.CombinedState
	end)
	
	--Connect tests being added.
	Test.TestAdded:Connect(function(NewTest)
		local NewListFrame = TestListFrame.new(NewTest)
		NewListFrame.Parent = self:GetCollapsableContainer()
	end)
	
	--Set the defaults.
	self.Size = UDim2.new(1,0,0,20)
end



return TestListFrame