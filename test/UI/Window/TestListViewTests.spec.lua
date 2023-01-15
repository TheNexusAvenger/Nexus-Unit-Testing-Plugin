--[[
TheNexusAvenger

Tests the TestListView class.
--]]
--!strict

local NexusUnitTestingPlugin = game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin")
local TestListView = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("TestListView"))
local ModuleUnitTest = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("Runtime"):WaitForChild("ModuleUnitTest"))

return function()
    local TestTestListView = nil
    beforeEach(function()
        TestTestListView = TestListView.new()
    end)
    afterEach(function()
        TestTestListView:Destroy()
    end)

    describe("A test list view", function()
        it("should accept new tests.", function()
            --Create 3 tests.
            local ModuleScript1, ModuleScript2 = Instance.new("ModuleScript"), Instance.new("ModuleScript")
            ModuleScript1.Name = "ModuleScript1"
            ModuleScript2.Name = "ModuleScript2"
            local ModuleUnitTest1, ModuleUnitTest2, ModuleUnitTest3 = ModuleUnitTest.new(ModuleScript1), ModuleUnitTest.new(ModuleScript2), ModuleUnitTest.new(ModuleScript1)

            --Register a test and assert it was added.
            TestTestListView:RegisterTest(ModuleUnitTest1)
            expect(#TestTestListView.Tests.Children).to.equal(1)
            expect(TestTestListView.ModuleScriptsToEntry[ModuleScript1]).to.equal(TestTestListView.Tests.Children[1])

            --Register a new test and assert it was added.
            TestTestListView:RegisterTest(ModuleUnitTest2)
            expect(#TestTestListView.Tests.Children).to.equal(2)
            expect(TestTestListView.ModuleScriptsToEntry[ModuleScript2]).to.equal(TestTestListView.Tests.Children[2])

            --Register a rerun test and assert it was added.
            TestTestListView:RegisterTest(ModuleUnitTest3)
            expect(#TestTestListView.Tests.Children).to.equal(2)
            expect(TestTestListView.ModuleScriptsToEntry[ModuleScript1]).to.equal(TestTestListView.Tests.Children[1])
        end)
    end)
end