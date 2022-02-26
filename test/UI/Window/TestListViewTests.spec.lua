--[[
TheNexusAvenger

Tests the TestListView class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestListView = NexusUnitTestingPlugin:GetResource("UI.Window.TestListView")
local ModuleUnitTest = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.Runtime.ModuleUnitTest")

local TestListViewUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function TestListViewUnitTest:Setup()
    self.CuT = TestListView.new()
end

--[[
Tears down the test.
--]]
function TestListViewUnitTest:Teardown()
    self.CuT:Destroy()
end

--[[
Tests the RegisterTest method.
--]]
NexusUnitTesting:RegisterUnitTest(TestListViewUnitTest.new("RegisterTest"):SetRun(function(self)
    --Create 3 tests.
    local ModuleScript1, ModuleScript2 = Instance.new("ModuleScript"), Instance.new("ModuleScript")
    ModuleScript1.Name = "ModuleScript1"
    ModuleScript2.Name = "ModuleScript2"
    local ModuleUnitTest1, ModuleUnitTest2, ModuleUnitTest3 = ModuleUnitTest.new(ModuleScript1), ModuleUnitTest.new(ModuleScript2), ModuleUnitTest.new(ModuleScript1)

    --Register a test and assert it was added.
    self.CuT:RegisterTest(ModuleUnitTest1)
    self:AssertEquals(#self.CuT.Tests.Children, 1, "List frame wasn't added.")
    self:AssertEquals(self.CuT.ModuleScriptsToEntry[ModuleScript1], self.CuT.Tests.Children[1], "List frame wasn't stored.")

    --Register a new test and assert it was added.
    self.CuT:RegisterTest(ModuleUnitTest2)
    self:AssertEquals(#self.CuT.Tests.Children, 2, "List frame wasn't added.")
    self:AssertEquals(self.CuT.ModuleScriptsToEntry[ModuleScript2], self.CuT.Tests.Children[2], "List frame wasn't stored.")

    --Register a rerun test and assert it was added.
    self.CuT:RegisterTest(ModuleUnitTest3)
    self:AssertEquals(#self.CuT.Tests.Children, 2, "List frame was added.")
    self:AssertEquals(self.CuT.ModuleScriptsToEntry[ModuleScript1], self.CuT.Tests.Children[1], "List frame wasn't stored.")
end))



return true