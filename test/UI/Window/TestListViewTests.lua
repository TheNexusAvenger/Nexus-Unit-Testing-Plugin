--[[
TheNexusAvenger

Tests the TestListView class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestListView = NexusUnitTestingPlugin:GetResource("UI.Window.TestListView")
local ModuleUnitTest = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.Runtime.ModuleUnitTest")



--[[
Tests the constructor.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the component under testing and assert it is set up correctly.
	local CuT = TestListView.new()
	UnitTest:AssertEquals(CuT.ClassName,"TestListView","Class name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Child objects are exposed.")
end)

--[[
Tests the RegisterTest method.
--]]
NexusUnitTesting:RegisterUnitTest("RegisterTest",function(UnitTest)
	--Create the component under testing and 3 tests.
	local CuT = TestListView.new()
	local ModuleScript1,ModuleScript2 = Instance.new("ModuleScript"),Instance.new("ModuleScript")
	ModuleScript1.Name = "ModuleScript1"
	ModuleScript2.Name = "ModuleScript2"
	local ModuleUnitTest1,ModuleUnitTest2,ModuleUnitTest3 = ModuleUnitTest.new(ModuleScript1),ModuleUnitTest.new(ModuleScript2),ModuleUnitTest.new(ModuleScript1)
	
	--Register a test and assert it was added.
	CuT:RegisterTest(ModuleUnitTest1)
	UnitTest:AssertEquals(#CuT.TestScrollingListFrame:GetChildren(),1,"List frame wasn't added.")
	UnitTest:AssertEquals(CuT.ModuleScriptTestFrames[ModuleScript1],CuT.TestScrollingListFrame:GetChildren()[1],"List frame wasn't stored.")
	
	--Register a new test and assert it was added.
	CuT:RegisterTest(ModuleUnitTest2)
	UnitTest:AssertEquals(#CuT.TestScrollingListFrame:GetChildren(),2,"List frame wasn't added.")
	UnitTest:AssertEquals(CuT.ModuleScriptTestFrames[ModuleScript2],CuT.TestScrollingListFrame:GetChildren()[2],"List frame wasn't stored.")
	
	--Register a rerun test and assert it was added.
	CuT:RegisterTest(ModuleUnitTest3)
	UnitTest:AssertEquals(#CuT.TestScrollingListFrame:GetChildren(),2,"List frame was added.")
	UnitTest:AssertEquals(CuT.ModuleScriptTestFrames[ModuleScript1],CuT.TestScrollingListFrame:GetChildren()[2],"List frame wasn't stored.")
end)



return true