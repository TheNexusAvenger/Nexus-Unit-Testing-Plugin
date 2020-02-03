--[[
TheNexusAvenger

Frame containing the progress of the tests.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local TestStateIcon = NexusUnitTestingPluginProject:GetResource("UI.TestStateIcon")
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")
local NexusUnitTesting = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule")

local TestProgressBar = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Base.NexusWrappedInstance"):Extend()
TestProgressBar:SetClassName("TestProgressBar")



--[[
Creates a Test Progress Bar object.
--]]
function TestProgressBar:__new()
	self:InitializeSuper("Frame")
	
	--Store the tests.
	self:__SetChangedOverride("Tests",function() end)
	self.Tests = {}
	self:__SetChangedOverride("TestEvents",function() end)
	self.TestEvents = {}
	
	--Create the icon.
	local Icon = TestStateIcon.new()
	Icon.Hidden = true
	Icon.Size = UDim2.new(0,16,0,16)
	Icon.Position = UDim2.new(0,6,0,6)
	Icon.Parent = self
	self:__SetChangedOverride("Icon",function() end)
	self.Icon = Icon
	
	--Create the bars.
	local BarBackground = NexusPluginFramework.new("Frame")
	BarBackground.Size = UDim2.new(1,-32,0,18)
	BarBackground.Position = UDim2.new(0,30,0,5)
	BarBackground.Parent = self
	
	local PassedBar = NexusPluginFramework.new("Frame")
	PassedBar.Size = UDim2.new(0,0,0,0)
	PassedBar.BorderSizePixel = 0
	PassedBar.BackgroundColor3 = Color3.new(0,200/255,0)
	PassedBar.ClipsDescendants = true
	PassedBar.Parent = BarBackground
	self:__SetChangedOverride("PassedBar",function() end)
	self.PassedBar = PassedBar
	
	local PassedTotalLabel = NexusPluginFramework.new("TextLabel")
	PassedTotalLabel.Hidden = true
	PassedTotalLabel.Size = UDim2.new(1,-8,0,16)
	PassedTotalLabel.Position = UDim2.new(0,4,0,1)
	PassedTotalLabel.Text = "0"
	PassedTotalLabel.TextSize = 16
	PassedTotalLabel.Font = "SourceSansBold"
	PassedTotalLabel.TextStrokeColor3 = Color3.new(0,0,0)
	PassedTotalLabel.TextStrokeTransparency = 0
	PassedTotalLabel.Parent = PassedBar
	self:__SetChangedOverride("PassedTotalLabel",function() end)
	self.PassedTotalLabel = PassedTotalLabel
	
	local FailedBar = NexusPluginFramework.new("Frame")
	FailedBar.Size = UDim2.new(0,0,0,0)
	FailedBar.BorderSizePixel = 0
	FailedBar.BackgroundColor3 = Color3.new(200/255,0,0)
	FailedBar.ClipsDescendants = true
	FailedBar.Parent = BarBackground
	self:__SetChangedOverride("FailedBar",function() end)
	self.FailedBar = FailedBar
	
	local FailedTotalLabel = NexusPluginFramework.new("TextLabel")
	FailedTotalLabel.Hidden = true
	FailedTotalLabel.Size = UDim2.new(1,-8,0,16)
	FailedTotalLabel.Position = UDim2.new(0,4,0,1)
	FailedTotalLabel.Text = "0"
	FailedTotalLabel.TextSize = 16
	FailedTotalLabel.Font = "SourceSansBold"
	FailedTotalLabel.TextStrokeColor3 = Color3.new(0,0,0)
	FailedTotalLabel.TextStrokeTransparency = 0
	FailedTotalLabel.Parent = FailedBar
	self:__SetChangedOverride("FailedTotalLabel",function() end)
	self.FailedTotalLabel = FailedTotalLabel
	
	local SkippedBar = NexusPluginFramework.new("Frame")
	SkippedBar.Size = UDim2.new(0,0,0,0)
	SkippedBar.BorderSizePixel = 0
	SkippedBar.BackgroundColor3 = Color3.new(200/255,200/255,0)
	SkippedBar.ClipsDescendants = true
	SkippedBar.Parent = BarBackground
	self:__SetChangedOverride("SkippedBar",function() end)
	self.SkippedBar = SkippedBar
	
	local SkippedTotalLabel = NexusPluginFramework.new("TextLabel")
	SkippedTotalLabel.Hidden = true
	SkippedTotalLabel.Size = UDim2.new(1,-8,0,16)
	SkippedTotalLabel.Position = UDim2.new(0,4,0,1)
	SkippedTotalLabel.Text = "0"
	SkippedTotalLabel.TextSize = 16
	SkippedTotalLabel.Font = "SourceSansBold"
	SkippedTotalLabel.TextStrokeColor3 = Color3.new(0,0,0)
	SkippedTotalLabel.TextStrokeTransparency = 0
	SkippedTotalLabel.Parent = SkippedBar
	self:__SetChangedOverride("SkippedTotalLabel",function() end)
	self.SkippedTotalLabel = SkippedTotalLabel
	
	--Set the defaults.
	self.Size = UDim2.new(1,0,0,28)
end

--[[
Updates the progress bar.
--]]
function TestProgressBar:UpdateProgressBar()
	--Determinee the amount of each type.
	local TotalTests,InProgressTests,PassedTests,FailedTests,SkippedTests = 0,0,0,0,0
	for _,Test in pairs(self.Tests) do
		TotalTests = TotalTests + 1
		
		if Test.State == NexusUnitTesting.TestState.Passed then
			PassedTests = PassedTests + 1
		elseif Test.State == NexusUnitTesting.TestState.InProgress then
			InProgressTests = InProgressTests + 1
		elseif Test.State == NexusUnitTesting.TestState.Failed then
			FailedTests = FailedTests + 1
		elseif Test.State == NexusUnitTesting.TestState.Skipped then
			SkippedTests = SkippedTests + 1
		end
	end
	
	--Update the icon.
	if InProgressTests > 0 then
		self.Icon.TestState = NexusUnitTesting.TestState.InProgress
	elseif FailedTests > 0 then
		self.Icon.TestState = NexusUnitTesting.TestState.Failed
	elseif PassedTests > 0 then
		self.Icon.TestState = NexusUnitTesting.TestState.Passed
	elseif SkippedTests > 0 then
		self.Icon.TestState = NexusUnitTesting.TestState.Skipped
	else
		self.Icon.TestState = NexusUnitTesting.TestState.NotRun
	end
	
	--Update the sizes.
	self.PassedTotalLabel.Text = tostring(PassedTests)
	self.FailedTotalLabel.Text = tostring(FailedTests)
	self.SkippedTotalLabel.Text = tostring(SkippedTests)
	self.PassedBar.Size = UDim2.new(PassedTests/TotalTests,0,1,0)
	self.FailedBar.Size = UDim2.new(FailedTests/TotalTests,0,1,0)
	self.SkippedBar.Size = UDim2.new(SkippedTests/TotalTests,0,1,0)
	self.FailedBar.Position = UDim2.new(PassedTests/TotalTests,0,0,0)
	self.SkippedBar.Position = UDim2.new((PassedTests + FailedTests)/TotalTests,0,0,0)
end

--[[
Adds a unit test to track.
--]]
function TestProgressBar:AddUnitTest(UnitTest,DontUpdateBar)
	--Store the test.
	table.insert(self.Tests,UnitTest)
	
	--Connect the events.
	local Events = {}
	self.TestEvents[UnitTest] = Events
	table.insert(Events,UnitTest:GetPropertyChangedSignal("State"):Connect(function()
		self:UpdateProgressBar()
	end))
	table.insert(Events,UnitTest.TestAdded:Connect(function(SubUnitTest)
		self:AddUnitTest(SubUnitTest)
	end))
	
	--Add the subtests.
	for _,SubUnitTest in pairs(UnitTest.SubTests) do
		self:AddUnitTest(SubUnitTest,true)
	end
	
	--Update the bar.
	if DontUpdateBar ~= true then
		self:UpdateProgressBar()
	end
end

--[[
Removes a unit test to track.
--]]
function TestProgressBar:RemoveUnitTest(UnitTest,DontUpdateBar)
	--Remove the unit test.
	for i,Test in pairs(self.Tests) do
		if Test == UnitTest then
			table.remove(self.Tests,i)
			break
		end
	end
	
	--Disconnect the events.
	for _,Connection in pairs(self.TestEvents[UnitTest] or {}) do
		Connection:Disconnect()
	end
	
	--Remove the subtests.
	for _,SubUnitTest in pairs(UnitTest.SubTests) do
		self:RemoveUnitTest(SubUnitTest,true)
	end
	
	--Update the bar.
	if DontUpdateBar ~= true then
		self:UpdateProgressBar()
	end
end



return TestProgressBar