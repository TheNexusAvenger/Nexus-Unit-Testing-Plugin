--[[
TheNexusAvenger

Tests the TestListFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestListFrame = NexusUnitTestingPlugin:GetResource("UI.TestListFrame")
local UnitTestClass = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.UnitTest.UnitTest")



--[[
Tests setting the CombinedState in the test.
--]]
NexusUnitTesting:RegisterUnitTest("CombinedStateTest",function(UnitTest)
	--Create the component under testing and assert it is set up correctly.
	local Test = UnitTestClass.new("Test test")
	Test.CombinedState = "INPROGRESS"
	local CuT = TestListFrame.new(Test)
	local Icon = CuT:GetMainContainer():GetWrappedInstance():FindFirstChildWhichIsA("ImageLabel")
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(256,0),"Icon is not correct.")
	
	--Change the combined state and assert the icon changes.
	Test.CombinedState = "PASSED"
	UnitTest:AssertEquals(CuT.Name,"Test test","Frame name is incorrect.")
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(512,0),"Icon is not correct.")
end)

--[[
Tests adding subtests.
--]]
NexusUnitTesting:RegisterUnitTest("SubTests",function(UnitTest)
	--Create the component under testing and assert it is has 2 subtest list frames.
	local Test = UnitTestClass.new("Test 1")
	Test.CombinedState = "INPROGRESS"
	Test:RegisterUnitTest(UnitTestClass.new("Test 2"))
	Test:RegisterUnitTest(UnitTestClass.new("Test 3"))
	local CuT = TestListFrame.new(Test)
	UnitTest:AssertEquals(#CuT:GetCollapsableContainer():GetChildren(),2,"2 SubTests don't have list frames")
	
	--Add a new subtest and assert a list frame was created.
	Test:RegisterUnitTest(UnitTestClass.new("Test 4"))
	UnitTest:AssertEquals(#CuT:GetCollapsableContainer():GetChildren(),3,"3 SubTests don't have list frames")
end)



return true