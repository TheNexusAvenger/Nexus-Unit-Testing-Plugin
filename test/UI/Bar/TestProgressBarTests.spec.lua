--[[
TheNexusAvenger

Tests the TestProgressBar class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestProgressBar = NexusUnitTestingPlugin:GetResource("UI.Bar.TestProgressBar")
local UnitTestClass = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.UnitTest.UnitTest")

local TestProgressBarUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function TestProgressBarUnitTest:Setup()
    self.CuT = TestProgressBar.new()
end

--[[
Tears down the test.
--]]
function TestProgressBarUnitTest:Teardown()
    self.CuT:Destroy()
end

--[[
Tests the UpdateProgressBar method.
--]]
NexusUnitTesting:RegisterUnitTest(TestProgressBarUnitTest.new("UpdateProgressBar"):SetRun(function(self)
    --Modify the component under testing and assert it is set up correctly.
    self.CuT.TimeText = "[Mock time]"
    local Icon = self.CuT.Icon
    self:AssertEquals(Icon.ImageRectOffset, Vector2.new(0, 0), "Icon is not correct.")

    --Add a series of tests and assert it is correct.
    local Test1 = UnitTestClass.new("Test 1")
    Test1.State = "PASSED"
    local Test2 = UnitTestClass.new("Test 2")
    Test2.State = "PASSED"
    local Test3 = UnitTestClass.new("Test 3")
    Test3.State = "INPROGRESS"
    Test1:RegisterUnitTest(Test2)
    Test1:RegisterUnitTest(Test3)
    self.CuT:AddUnitTest(Test1)

    self:AssertEquals(self.CuT.TotalsTextLabel.Text, "2 passed, 0 failed, 0 skipped (3 total) [Mock time]", "Test count is incorrect.")
    self:AssertEquals(Icon.ImageRectOffset, Vector2.new(256, 0), "Icon is not correct.")

    --Change a test and assert it changed.
    Test3.State = "FAILED"
    self:AssertEquals(self.CuT.TotalsTextLabel.Text, "2 passed, 1 failed, 0 skipped (3 total) [Mock time]", "Test count is incorrect.")
    self:AssertEquals(Icon.ImageRectOffset, Vector2.new(768, 0), "Icon is not correct.")

    --Add another test as a subtest and assert it changed.
    local Test4 = UnitTestClass.new("Test 4")
    Test4.State = "SKIPPED"
    Test3:RegisterUnitTest(Test4)
    self:AssertEquals(self.CuT.TotalsTextLabel.Text, "2 passed, 1 failed, 1 skipped (4 total) [Mock time]", "Test count is incorrect.")
    self:AssertEquals(Icon.ImageRectOffset, Vector2.new(768, 0), "Icon is not correct.")

    --Remove a test and assert it changed.
    self.CuT:RemoveUnitTest(Test3)
    self:AssertEquals(self.CuT.TotalsTextLabel.Text, "2 passed, 0 failed, 0 skipped (2 total) [Mock time]", "Test count is incorrect.")
    self:AssertEquals(Icon.ImageRectOffset, Vector2.new(512, 0), "Icon is not correct.")
end))

--[[
Tests the SetTime method.
--]]
NexusUnitTesting:RegisterUnitTest(TestProgressBarUnitTest.new("SetTime"):SetRun(function(self)
    --Set the time and assert it is correct.
    self.CuT:SetTime(10, 20, 30)
    self:AssertEquals(self.CuT.TimeText, "[Started at 10:20:30]", "Time is incorrect.")
    self.CuT:SetTime(1, 2, 3)
    self:AssertEquals(self.CuT.TimeText, "[Started at 1:02:03]", "Time is incorrect.")
    self.CuT:SetTime(0, 0, 0)
    self:AssertEquals(self.CuT.TimeText, "[Started at 0:00:00]", "Time is incorrect.")
end))



return true