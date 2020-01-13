--[[
TheNexusAvenger

Tests the TestProgressBar class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestProgressBar = NexusUnitTestingPlugin:GetResource("UI.TestProgressBar")
local UnitTestClass = NexusUnitTestingPlugin:GetResource("NexusUnitTesting.UnitTest.UnitTest")



--[[
Tests the UpdateProgressBar method.
--]]
NexusUnitTesting:RegisterUnitTest("UpdateProgressBar",function(UnitTest)
	--Create the component under testing and assert it is set up correctly.
	local CuT = TestProgressBar.new()
	local Icon = CuT.Icon
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(0,0),"Icon is not correct.")
	
	--Add a series of tests and assert it is correct.
	local Test1 = UnitTestClass.new("Test 1")
	Test1.State = "PASSED"
	local Test2 = UnitTestClass.new("Test 2")
	Test2.State = "PASSED"
	local Test3 = UnitTestClass.new("Test 3")
	Test3.State = "INPROGRESS"
	Test1:RegisterUnitTest(Test2)
	Test1:RegisterUnitTest(Test3)
	CuT:AddUnitTest(Test1)
	CuT.Parent = Instance.new("ScreenGui",game.StarterGui)
	UnitTest:AssertEquals(CuT.PassedTotalLabel.Text,"2","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.FailedTotalLabel.Text,"0","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.SkippedTotalLabel.Text,"0","Tests count is incorrect.")
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(256,0),"Icon is not correct.")
	
	--Change a test and assert it changed.
	Test3.State = "FAILED"
	UnitTest:AssertEquals(CuT.PassedTotalLabel.Text,"2","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.FailedTotalLabel.Text,"1","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.SkippedTotalLabel.Text,"0","Tests count is incorrect.")
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(768,0),"Icon is not correct.")
	
	--Add another test as a subtest and assert it changed.
	local Test4 = UnitTestClass.new("Test 4")
	Test4.State = "SKIPPED"
	Test3:RegisterUnitTest(Test4)
	UnitTest:AssertEquals(CuT.PassedTotalLabel.Text,"2","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.FailedTotalLabel.Text,"1","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.SkippedTotalLabel.Text,"1","Tests count is incorrect.")
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(768,0),"Icon is not correct.")
	
	--Remove a test and assert it changed.
	CuT:RemoveUnitTest(Test3)
	UnitTest:AssertEquals(CuT.PassedTotalLabel.Text,"2","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.FailedTotalLabel.Text,"0","Tests count is incorrect.")
	UnitTest:AssertEquals(CuT.SkippedTotalLabel.Text,"0","Tests count is incorrect.")
	UnitTest:AssertEquals(Icon.ImageRectOffset,Vector2.new(512,0),"Icon is not correct.")
end)



return true