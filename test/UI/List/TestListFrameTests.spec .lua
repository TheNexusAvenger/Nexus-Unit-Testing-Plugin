--[[
TheNexusAvenger

Tests the TestListFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestListFrame = NexusUnitTestingPlugin:GetResource("UI.List.TestListFrame")
local UnitTestClass = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.UnitTest.UnitTest")

local TestListFrameUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Tears down the test.
--]]
function TestListFrameUnitTest:Teardown()
	self.CuT:Destroy()
end

--[[
Tests setting the CombinedState in the test.
--]]
NexusUnitTesting:RegisterUnitTest(TestListFrameUnitTest.new("CombinedStateTest"):SetRun(function(self)
	--Create the component under testing and assert it is set up correctly.
	local Test = UnitTestClass.new("Test test")
	Test.CombinedState = "NOTRUN"
	self.CuT = TestListFrame.new(Test)
	Test.CombinedState = "INPROGRESS"
	local Icon = self.CuT:GetMainContainer():GetWrappedInstance():FindFirstChildWhichIsA("ImageLabel")
	local TimeLabel = self.CuT:GetMainContainer():GetWrappedInstance():FindFirstChildWhichIsA("TextLabel")
	self:AssertEquals(Icon.ImageRectOffset,Vector2.new(256,0),"Icon is not correct.")
	self:AssertTrue(TimeLabel.Visible,"Time is not visible.")
	
	--Change the combined state and assert the icon changes.
	Test.CombinedState = "PASSED"
	self:AssertEquals(self.CuT.Name,"Test test","Frame name is incorrect.")
	self:AssertEquals(Icon.ImageRectOffset,Vector2.new(512,0),"Icon is not correct.")
	self:AssertTrue(TimeLabel.Visible,"Time is not visible.")
end))

--[[
Tests adding subtests.
--]]
NexusUnitTesting:RegisterUnitTest(TestListFrameUnitTest.new("SubTests"):SetRun(function(self)
	--Create the component under testing and assert it is has 2 subtest list frames.
	local Test = UnitTestClass.new("Test 1")
	Test.CombinedState = "INPROGRESS"
	Test:RegisterUnitTest(UnitTestClass.new("Test 2"))
	Test:RegisterUnitTest(UnitTestClass.new("Test 3"))
	self.CuT = TestListFrame.new(Test)
	self:AssertEquals(#self.CuT:GetCollapsableContainer():GetChildren(),2,"2 SubTests don't have list frames")
	
	--Add a new subtest and assert a list frame was created.
	Test:RegisterUnitTest(UnitTestClass.new("Test 4"))
	self:AssertEquals(#self.CuT:GetCollapsableContainer():GetChildren(),3,"3 SubTests don't have list frames")
end))

--[[
Tests hiding the time label for tests started before being added (TestEZ reporting).
--]]
NexusUnitTesting:RegisterUnitTest(TestListFrameUnitTest.new("StartedBeforeRegistering"):SetRun(function(self)
	--Create the component under testing and assert it is set up correctly.
	local Test = UnitTestClass.new("Test test")
	Test.CombinedState = "INPROGRESS"
	self.CuT = TestListFrame.new(Test)
	local TimeLabel = self.CuT:GetMainContainer():GetWrappedInstance():FindFirstChildWhichIsA("TextLabel")
	
	--Change the combined state and assert the time is not visible.
	Test.CombinedState = "PASSED"
	self:AssertTrue(TimeLabel.Visible,"Time is not visible.")
end))



return true