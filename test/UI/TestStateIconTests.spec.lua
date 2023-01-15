--[[
TheNexusAvenger

Tests the TestStateIcon class.
--]]
--!strict

local NexusUnitTestingPlugin = game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin")
local TestStateIcon = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("TestStateIcon"))

return function()
    local TestTestStateIcon = nil
    beforeEach(function()
        TestTestStateIcon = TestStateIcon.new()
    end)
    afterEach(function()
        TestTestStateIcon:Destroy()
    end)

    describe("A test state icon", function()
        it("should update based on the test state.", function()
            --Assert the icon is correct.
            expect(TestTestStateIcon.TestState).to.equal("NOTRUN")
            expect(TestTestStateIcon.Image).to.equal("https://www.roblox.com/asset/?id=4595118527")
            expect(TestTestStateIcon.ImageColor3).to.equal(Color3.fromRGB(0, 170, 255))
            expect(TestTestStateIcon.ImageRectSize).to.equal(Vector2.new(256, 256))
            expect(TestTestStateIcon.ImageRectOffset).to.equal(Vector2.new(0, 0))

            --Set the test as in progress and assert it is correct.
            TestTestStateIcon.TestState = "INPROGRESS"
            expect(TestTestStateIcon.Image).to.equal("https://www.roblox.com/asset/?id=4595118527")
            expect(TestTestStateIcon.ImageColor3).to.equal(Color3.fromRGB(255, 150, 0))
            expect(TestTestStateIcon.ImageRectSize).to.equal(Vector2.new(256, 256))
            expect(TestTestStateIcon.ImageRectOffset).to.equal(Vector2.new(256, 0))

            --Set the test as passed and assert it is correct.
            TestTestStateIcon.TestState = "PASSED"
            expect(TestTestStateIcon.Image).to.equal("https://www.roblox.com/asset/?id=4595118527")
            expect(TestTestStateIcon.ImageColor3).to.equal(Color3.fromRGB(0, 200, 0))
            expect(TestTestStateIcon.ImageRectSize).to.equal(Vector2.new(256, 256))
            expect(TestTestStateIcon.ImageRectOffset).to.equal(Vector2.new(512, 0))

            --Set the test as failed and assert it is correct.
            TestTestStateIcon.TestState = "FAILED"
            expect(TestTestStateIcon.Image).to.equal("https://www.roblox.com/asset/?id=4595118527")
            expect(TestTestStateIcon.ImageColor3).to.equal(Color3.fromRGB(200, 0, 0))
            expect(TestTestStateIcon.ImageRectSize).to.equal(Vector2.new(256, 256))
            expect(TestTestStateIcon.ImageRectOffset).to.equal(Vector2.new(768, 0))

            --Set the test as failed and skipped it is correct.
            TestTestStateIcon.TestState = "SKIPPED"
            expect(TestTestStateIcon.Image).to.equal("https://www.roblox.com/asset/?id=4595118527")
            expect(TestTestStateIcon.ImageColor3).to.equal(Color3.fromRGB(220, 220, 0))
            expect(TestTestStateIcon.ImageRectSize).to.equal(Vector2.new(256, 256))
            expect(TestTestStateIcon.ImageRectOffset).to.equal(Vector2.new(0, 256))
        end)

        it("should update the output indicator", function()
            --Assert the indicator isn't visible by default.
            expect(TestTestStateIcon.OutputIndicator.Visible).to.equal(false)

            --Set that there is output and assert the indicator is visible.
            TestTestStateIcon.HasOutput = true
            expect(TestTestStateIcon.OutputIndicator.Visible).to.equal(true)
            
            --Set that there is not output and assert the indicator is not visible.
            TestTestStateIcon.HasOutput = false
            expect(TestTestStateIcon.OutputIndicator.Visible).to.equal(false)
        end)
    end)
end