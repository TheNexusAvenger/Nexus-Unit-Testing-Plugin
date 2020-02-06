--[[
TheNexusAvenger

Frame for showing and selecting tests.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local TestStateIcon = NexusUnitTestingPluginProject:GetResource("UI.TestStateIcon")
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")
local NexusUnitTesting = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule")

local TestListFrame = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.UI.CollapsableList.NexusCollapsableListFrame"):Extend()
TestListFrame:SetClassName("TestListFrame")

local TextService = game:GetService("TextService")



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
	
	--Create the text for the test name and time.
	local TestNameLabel = NexusPluginFramework.new("TextLabel")
	TestNameLabel.Hidden = true
	TestNameLabel.Size = UDim2.new(1,-24,0,16)
	TestNameLabel.Position = UDim2.new(0,22,0,1)
	TestNameLabel.Text = Test.Name
	TestNameLabel.Parent = self:GetMainContainer()
	
	local TestTimeLabel = NexusPluginFramework.new("TextLabel")
	TestTimeLabel.Hidden = true
	TestTimeLabel.Size = UDim2.new(1,-24,0,16)
	TestTimeLabel.Position = UDim2.new(0,22 + 4 + TextService:GetTextSize(Test.Name,TestNameLabel.TextSize,TestNameLabel.Font,Vector2.new(2000,16)).X,0,1)
	TestTimeLabel.TextColor3 = "SubText"
	TestTimeLabel.Text = ""
	TestTimeLabel.Parent = self:GetMainContainer()
	
	--Create the list constraint.
	local UIListLayout = NexusPluginFramework.new("UIListLayout")
	UIListLayout.Hidden = true
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = self:GetCollapsableContainer()
	
	--Add the existing subtests.
	for _,SubTest in pairs(Test.SubTests) do
		local NewListFrame = TestListFrame.new(SubTest)
		NewListFrame.Parent = self:GetCollapsableContainer()
	end
	
	--Connect changing the test state.
	local TestStartTime = 0
	Test:GetPropertyChangedSignal("CombinedState"):Connect(function()
		Icon.TestState = Test.CombinedState
		
		if Test.CombinedState == NexusUnitTesting.TestState.InProgress then
			TestStartTime = tick()
		elseif Test.CombinedState ~= NexusUnitTesting.TestState.NotRun then
			TestTimeLabel.Text = string.format("%.3f",tick() - TestStartTime).." seconds"
		end
	end)
	
	--Connect tests being added.
	Test.TestAdded:Connect(function(NewTest)
		local NewListFrame = TestListFrame.new(NewTest)
		NewListFrame.Parent = self:GetCollapsableContainer()
	end)
	
	--Set the defaults.
	self.Name = Test.Name
	self.Size = UDim2.new(1,0,0,20)
end



return TestListFrame