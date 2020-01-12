--[[
TheNexusAvenger

Tests the TestStateIcon class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestStateIcon = NexusUnitTestingPlugin:GetResource("UI.TestStateIcon")


--[[
Tests setting the TestState.
--]]
NexusUnitTesting:RegisterUnitTest("TestState",function(UnitTest)
	--Create the component under testing and assert it is correct.
	local CuT = TestStateIcon.new()
	UnitTest:AssertEquals(CuT.TestState,"NOTRUN","Test state is incorrect.")
	UnitTest:AssertEquals(CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	UnitTest:AssertEquals(CuT.ImageColor3,Color3.new(0,170/255,255/255),"Color is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectOffset,Vector2.new(0,0),"Spritesheet image position is incorrect.")
	
	--Set the test as in progress and assert it is correct.
	CuT.TestState = "INPROGRESS"
	UnitTest:AssertEquals(CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	UnitTest:AssertEquals(CuT.ImageColor3,Color3.new(255/255,150/255,0),"Color is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectOffset,Vector2.new(256,0),"Spritesheet image position is incorrect.")
	
	--Set the test as passed and assert it is correct.
	CuT.TestState = "PASSED"
	UnitTest:AssertEquals(CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	UnitTest:AssertEquals(CuT.ImageColor3,Color3.new(0,200/255,0),"Color is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectOffset,Vector2.new(512,0),"Spritesheet image position is incorrect.")

	--Set the test as failed and assert it is correct.
	CuT.TestState = "FAILED"
	UnitTest:AssertEquals(CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	UnitTest:AssertEquals(CuT.ImageColor3,Color3.new(200/255,0,0),"Color is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectOffset,Vector2.new(768,0),"Spritesheet image position is incorrect.")
	
	--Set the test as failed and skipped it is correct.
	CuT.TestState = "SKIPPED"
	UnitTest:AssertEquals(CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	UnitTest:AssertEquals(CuT.ImageColor3,Color3.new(220/255,220/255,0),"Color is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	UnitTest:AssertEquals(CuT.ImageRectOffset,Vector2.new(0,256),"Spritesheet image position is incorrect.")
end)



return true