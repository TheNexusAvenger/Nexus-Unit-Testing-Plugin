--[[
TheNexusAvenger

Frame for the list of tests and actions.
--]]

local SERVICES_WITH_TESTS = {
	game:GetService("Workspace"),
	game:GetService("Lighting"),
	game:GetService("ReplicatedFirst"),
	game:GetService("ReplicatedStorage"),
	game:GetService("ServerScriptService"),
	game:GetService("ServerStorage"),
	game:GetService("StarterGui"),
	game:GetService("StarterPack"),
	game:GetService("StarterPlayer"),
	game:GetService("Teams"),
	game:GetService("SoundService"),
	game:GetService("Chat"),
	game:GetService("LocalizationService"),
	game:GetService("TestService"),
}



local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local ButtonSideBar = NexusUnitTestingPluginProject:GetResource("UI.Bar.ButtonSideBar")
local TestProgressBar = NexusUnitTestingPluginProject:GetResource("UI.Bar.TestProgressBar")
local TestListFrame = NexusUnitTestingPluginProject:GetResource("UI.List.TestListFrame")
local TestScrollingListFrame = NexusUnitTestingPluginProject:GetResource("UI.List.TestScrollingListFrame")
local TestFinder = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule.Runtime.TestFinder")
local ModuleUnitTest = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule.Runtime.ModuleUnitTest")
local NexusEventCreator = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule.NexusInstance.Event.NexusEventCreator")
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")

local TestListView = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Base.NexusWrappedInstance"):Extend()
TestListView:SetClassName("TestListView")



--[[
Creates a Test List Frame object.
--]]
function TestListView:__new()
	self:InitializeSuper("Frame")
	
	--Store the plugin.
	self:__SetChangedOverride("Plugin",function() end)
	self.Plugin = NexusPluginFramework:GetPlugin()
	
	--Set up storing the list frames references.
	self:__SetChangedOverride("ModuleScriptTestFrames",function() end)
	self.ModuleScriptTestFrames = {}
	
	--Create the event for opening the output.
	self:__SetChangedOverride("TestOutputOpened",function() end)
	self.TestOutputOpened = NexusEventCreator:CreateEvent()
	
	--Store the current selected tests for re-selecting on rerun.
	self:__SetChangedOverride("SelectedTestsNames",function() end)
	self.SelectedTestsNames = {}
	
	--Create the bars.
	local SideBar = ButtonSideBar.new()
	SideBar.Hidden = true
	SideBar.Parent = self
	self:__SetChangedOverride("ButtonSideBar",function() end)
	self.ButtonSideBar = SideBar
	
	local BottomBar = TestProgressBar.new()
	BottomBar.Hidden = true
	BottomBar.Size = UDim2.new(1,-29,0,28)
	BottomBar.Position = UDim2.new(0,29,1,-28)
	BottomBar.Parent = self
	self:__SetChangedOverride("TestProgressBar",function() end)
	self.TestProgressBar = BottomBar
	
	--Creating the scrolling frame.
	local ScrollFrame = TestScrollingListFrame.new()
	ScrollFrame.Hidden = true
	ScrollFrame.Size = UDim2.new(1,-29,1,-29)
	ScrollFrame.Position = UDim2.new(0,29,0,0)
	ScrollFrame.Parent = self
	self:__SetChangedOverride("TestScrollingListFrame",function() end)
	self.TestScrollingListFrame = ScrollFrame
	
	--Connect the events.
	local DB = true
	SideBar.RunTestsButton.MouseButton1Down:Connect(function()
		if DB then
			DB = false
			delay(0.1,function() DB = true end)
			self:RunAllTests()
		end
	end)
	SideBar.RunFailedTestsButton.MouseButton1Down:Connect(function()
		if DB then
			DB = false
			delay(0.1,function() DB = true end)
			self:RunFailedTests()
		end
	end)
	SideBar.RunSelectedTestsButton.MouseButton1Down:Connect(function()
		if DB then
			DB = false
			delay(0.1,function() DB = true end)
			self:RunSelectedTests()
		end
	end)
	
	--[[
	Connects the events of a list frame.
	--]]
	local CurrentOutputTest
	local function ConnectNewListFrameEvents(ListFrame,BaseFullName)
		if BaseFullName == nil then
			BaseFullName = ""
		end
		
		if ListFrame:IsA(TestListFrame.ClassName) then
			--Set the full name.
			local FullName = BaseFullName..ListFrame.Test.Name
			ListFrame.Test.FullName = FullName
			
			--Select the list frame if it was selected before.
			--TODO: Disabled as a limitation with NexusSelectionConstraint. Will be resolved with https://trello.com/c/MX45bA3G/24-allow-externally-selecting-multiple-collapsablelistframes-with-nexusselectionconstraint
			--if self.SelectedTestsNames[FullName] then
			--	ListFrame.Selected = true
			--end
			
			--Connect the double click.
			ListFrame.DoubleClicked:Connect(function()
				self.TestOutputOpened:Fire(ListFrame.Test)
				CurrentOutputTest = FullName
			end)
			
			--Connect selecting the list frame.
			ListFrame:GetPropertyChangedSignal("Selected"):Connect(function()
				if ListFrame.Selected then
					self.SelectedTestsNames[FullName] = true
				else
					self.SelectedTestsNames[FullName] = nil
				end
			end)
			
			--Connect the child added.
			ListFrame:GetCollapsableContainer().ChildAdded:Connect(function(SubListFrame)
				ConnectNewListFrameEvents(SubListFrame,FullName.." > ")
			end)
			
			--Open the output window if the test name matches (test is rerunning).
			if CurrentOutputTest == FullName then
				self.TestOutputOpened:Fire(ListFrame.Test,true)
			end
			
		end
	end
	ScrollFrame.ChildAdded:Connect(ConnectNewListFrameEvents)
	
	--Set the defaults.
	self.Size = UDim2.new(1,0,1,0)
end

--[[
Runs all of the detected tests.
--]]
function TestListView:RunAllTests()
	--Find the tests to run.
	local Tests = {}
	local Modules = {}
	for _,Service in pairs(SERVICES_WITH_TESTS) do
		for _,Test in pairs(TestFinder.GetTests(Service)) do
			table.insert(Tests,Test)
			Test.Overrides["plugin"] = self.Plugin
			Modules[Test.ModuleScript] = true
		end
	end
	
	--Remove the non-existent tests.
	local FramesToRemove = {}
	for Index,Frame in pairs(self.ModuleScriptTestFrames) do
		local Test = Frame.Test
		if not Modules[Test.ModuleScript] then
			local ExistingListFrame = self.ModuleScriptTestFrames[Test.ModuleScript]
			if ExistingListFrame then
				FramesToRemove[Index] = Frame
			end
		end
	end
	for Index,Frame in pairs(FramesToRemove) do
		self.TestProgressBar:RemoveUnitTest(Frame.Test,true)
		Frame:Destroy()
		self.ModuleScriptTestFrames[Index] = nil
	end
	
	--Run the tests.
	self:RunTests(Tests)
end

--[[
Reruns the failed test. Runs all of the
tests if no test run was done.
--]]
function TestListView:RunFailedTests()
	--Run all the tests if nothing was run.
	if #self.TestScrollingListFrame:GetChildren() == 0 then
		self:RunAllTests()
		return
	end
	
	--[[
	Return if a test contains a failed test.
	--]]
	local function ContainsFailedTest(Test)
		--Return true if the test failed.
		if Test.State == "FAILED" or Test.CombinedState == "FAILED" then
			return true
		end
		
		--Return if a subtest has a failure.
		for _,SubTest in pairs(Test.SubTests) do
			if ContainsFailedTest(SubTest) then
				return true
			end
		end
		
		--Return false (no failure).
		return false
	end
	
	--Determine the ModuleScripts to rerun.
	local TestsToRerun = {}
	local FramesToRemove = {}
	for Index,Frame in pairs(self.ModuleScriptTestFrames) do
		local Test = Frame.Test
		if ContainsFailedTest(Test) then
			local ModuleScript = Test.ModuleScript
			if ModuleScript:IsDescendantOf(game) then
				table.insert(TestsToRerun,ModuleUnitTest.new(ModuleScript))
			else
				FramesToRemove[Index] = Frame
			end
		end
	end
	
	--Remove the non-existent tests.
	for Index,Frame in pairs(FramesToRemove) do
		self.TestProgressBar:RemoveUnitTest(Frame.Test,true)
		Frame:Destroy()
		self.ModuleScriptTestFrames[Index] = nil
	end 
	
	--Run the tests.
	self:RunTests(TestsToRerun)
end

--[[
Reruns the selected test. Runs all of the
tests if tests were selected.
--]]
function TestListView:RunSelectedTests()
	--[[
	Returns if a list frame is selected or a child is.
	--]]
	local function ListFrameIsSelected(ListFrame)
		--If the label is selected, return true.
		if ListFrame.Selected then
			return true
		end
		
		--Return true if a subtest is selected.
		for _,TestListFrame in pairs(ListFrame:GetCollapsableContainer():GetChildren()) do
			if ListFrameIsSelected(TestListFrame) then
				return true
			end
		end
		
		--Return false (list frame and children aren't selected).
		return false
	end
	
	--Determine the tests to rerun and the frames to remove.
	local FramesToRemove = {}
	local TestsToRerun = {}
	for Index,ListFrame in pairs(self.ModuleScriptTestFrames) do
		--Add the test to be removed if the module was removed.
		if ListFrameIsSelected(ListFrame) then
			local ModuleScript = ListFrame.Test.ModuleScript
			if ModuleScript:IsDescendantOf(game) then
				table.insert(TestsToRerun,ModuleUnitTest.new(ModuleScript))
			else
				FramesToRemove[Index] = ListFrame
			end
		end
	end
	
	--Rerun all tests if none are selected.
	if #TestsToRerun == 0 then
		self:RunAllTests()
		return
	end
	
	--Remove the non-existent tests.
	for Index,Frame in pairs(FramesToRemove) do
		self.TestProgressBar:RemoveUnitTest(Frame.Test,true)
		Frame:Destroy()
		self.ModuleScriptTestFrames[Index] = nil
	end
	
	--Run the tests.
	self:RunTests(TestsToRerun)
end

--[[
Runs a list of tests.
--]]
function TestListView:RunTests(Tests)
	--Set the test time.
	self.TestProgressBar:SetTime()
	
	--Sort the tests.
	table.sort(Tests,function(TestA,TestB)
		return TestA.Name < TestB.Name
	end)
	
	--Register the tests.
	for _,Test in pairs(Tests) do
		self:RegisterTest(Test)
	end
	
	--Run the tests.
	for _,Test in pairs(Tests) do
		Test:RunTest()
		Test:RunSubtests()
	end
	
	--Update the bar if there is no tests.
	if #Tests == 0 then
		self.TestProgressBar:UpdateProgressBar()
	end
end

--[[
Registers a ModuleScript unit test.
--]]
function TestListView:RegisterTest(ModuleScriptTest)
	--Remove the existing frame if it exists.
	if self.ModuleScriptTestFrames[ModuleScriptTest.ModuleScript] then
		local ExistingListFrame = self.ModuleScriptTestFrames[ModuleScriptTest.ModuleScript]
		self.TestProgressBar:RemoveUnitTest(ExistingListFrame.Test,true)
		ExistingListFrame:Destroy()
	end
	
	--Create the list frame.
	local ListFrame = TestListFrame.new(ModuleScriptTest)
	ListFrame.Parent = self.TestScrollingListFrame
	self.ModuleScriptTestFrames[ModuleScriptTest.ModuleScript] = ListFrame
	self.TestProgressBar:AddUnitTest(ModuleScriptTest)
end



return TestListView