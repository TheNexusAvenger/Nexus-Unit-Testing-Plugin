--[[
TheNexusAvenger

Tests the TestProgressBar class.
--]]
--!strict

local NexusUnitTestingPlugin = game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin")
local TestProgressBar = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Bar"):WaitForChild("TestProgressBar"))
local UnitTestClass = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("UnitTest"):WaitForChild("UnitTest"))

return function()
    local TestTestProgressBar = nil
    beforeEach(function()
        TestTestProgressBar = TestProgressBar.new()
    end)
    afterEach(function()
        TestTestProgressBar:Destroy()
    end)

    describe("A test progress bar", function()
        it("should update with new tests.", function()
            --Modify the progress bar and assert it is set up correctly.
            TestTestProgressBar.TimeText = "[Mock time]"
            local Icon = TestTestProgressBar.Icon
            expect(Icon.ImageRectOffset).to.equal(Vector2.new(0, 0))

            --Add a series of tests and assert it is correct.
            local Test1 = UnitTestClass.new("Test 1")
            Test1.State = "PASSED" :: any
            local Test2 = UnitTestClass.new("Test 2")
            Test2.State = "PASSED" :: any
            local Test3 = UnitTestClass.new("Test 3")
            Test3.State = "INPROGRESS" :: any
            Test1:RegisterUnitTest(Test2)
            Test1:RegisterUnitTest(Test3)
            TestTestProgressBar:AddUnitTest(Test1)
            expect(TestTestProgressBar.TotalsTextLabel.Text).to.equal("2 passed, 0 failed, 0 skipped (3 total) [Mock time]")
            expect(Icon.ImageRectOffset).to.equal(Vector2.new(256, 0))

            --Change a test and assert it changed.
            Test3.State = "FAILED" :: any
            expect(TestTestProgressBar.TotalsTextLabel.Text).to.equal("2 passed, 1 failed, 0 skipped (3 total) [Mock time]")
            expect(Icon.ImageRectOffset).to.equal(Vector2.new(768, 0))

            --Add another test as a subtest and assert it changed.
            local Test4 = UnitTestClass.new("Test 4")
            Test4.State = "SKIPPED" :: any
            Test3:RegisterUnitTest(Test4)
            expect(TestTestProgressBar.TotalsTextLabel.Text).to.equal("2 passed, 1 failed, 1 skipped (4 total) [Mock time]")
            expect(Icon.ImageRectOffset).to.equal(Vector2.new(768, 0))

            --Remove a test and assert it changed.
            TestTestProgressBar:RemoveUnitTest(Test3)
            expect(TestTestProgressBar.TotalsTextLabel.Text).to.equal("2 passed, 0 failed, 0 skipped (2 total) [Mock time]")
            expect(Icon.ImageRectOffset).to.equal(Vector2.new(512, 0))
        end)

        it("should set the time.", function()
            TestTestProgressBar:SetTime(10, 20, 30)
            expect(TestTestProgressBar.TimeText).to.equal("[Started at 10:20:30]")
            TestTestProgressBar:SetTime(1, 2, 3)
            expect(TestTestProgressBar.TimeText).to.equal("[Started at 1:02:03]")
            TestTestProgressBar:SetTime(0, 0, 0)
            expect(TestTestProgressBar.TimeText).to.equal("[Started at 0:00:00]")
        end)
    end)
end