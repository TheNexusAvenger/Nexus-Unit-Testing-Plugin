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
local TestListFrameTests = NexusUnitTestingPluginProject:GetResource("UI.List.TestListFrame")
local TestScrollingListFrame = NexusUnitTestingPluginProject:GetResource("UI.List.TestScrollingListFrame")
local TestFinder = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule.Runtime.TestFinder")
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")

local TestListView = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Base.NexusWrappedInstance"):Extend()
TestListView:SetClassName("TestListView")



--[[
Creates a Test List Frame object.
--]]
function TestListView:__new()
	self:InitializeSuper("Frame")
	
	--Set up storing the list frames references.
	self:__SetChangedOverride("ModuleScriptTestFrames",function() end)
	self.ModuleScriptTestFrames = {}
	
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
			self:RunAllTests()
			
			wait()
			DB = true
		end
	end)
	SideBar.RunFailedTestsButton.MouseButton1Down:Connect(function()
		if DB then
			DB = false
			warn("Rerrunning failed tests is not implemented")
			self:RunFailedTests()
			
			DB = true
		end
	end)
	
	--Set the defaults.
	self.Size = UDim2.new(1,0,1,0)
end

--[[
Runs all of the detected tests.
--]]
function TestListView:RunAllTests()
	--Find the tests to run.
	local Tests = {}
	for _,Service in pairs(SERVICES_WITH_TESTS) do
		for _,Test in pairs(TestFinder.GetTests(Service)) do
			table.insert(Tests,Test)
		end
	end
	
	--Register the tests.
	for _,Test in pairs(Tests) do
		self:RegisterTest(Test)
	end
	
	--Run the tests.
	for _,Test in pairs(Tests) do
		Test:RunTest()
		Test:RunSubtests()
	end
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
	
	--TODO: Implement
end

--[[
Registers a ModuleScript unit test.
--]]
function TestListView:RegisterTest(ModuleScriptTest)
	--Remove the existing frame if it exists.
	if self.ModuleScriptTestFrames[ModuleScriptTest.ModuleScript] then
		self.ModuleScriptTestFrames[ModuleScriptTest.ModuleScript]:Destroy()
	end
	
	--Create the list frame.
	local ListFrame = TestListFrameTests.new(ModuleScriptTest)
	ListFrame.Parent = self.TestScrollingListFrame
	self.ModuleScriptTestFrames[ModuleScriptTest.ModuleScript] = ListFrame
	self.TestProgressBar:AddUnitTest(ModuleScriptTest)
end



return TestListView