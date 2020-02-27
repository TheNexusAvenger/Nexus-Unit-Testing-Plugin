--[[
TheNexusAvenger

Tests the TestStateIcon class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestStateIcon = NexusUnitTestingPlugin:GetResource("UI.TestStateIcon")

local TestStateIconUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function TestStateIconUnitTest:Setup()
	self.CuT = TestStateIcon.new()
end

--[[
Tears down the test.
--]]
function TestStateIconUnitTest:Teardown()
	self.CuT:Destroy()
end

--[[
Tests setting the TestState.
--]]
NexusUnitTesting:RegisterUnitTest(TestStateIconUnitTest.new("TestState"):SetRun(function(self)
	--Assert the component under testing is correct.
	self:AssertEquals(self.CuT.TestState,"NOTRUN","Test state is incorrect.")
	self:AssertEquals(self.CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	self:AssertEquals(self.CuT.ImageColor3,Color3.new(0,170/255,255/255),"Color is incorrect.")
	self:AssertEquals(self.CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	self:AssertEquals(self.CuT.ImageRectOffset,Vector2.new(0,0),"Spritesheet image position is incorrect.")
	
	--Set the test as in progress and assert it is correct.
	self.CuT.TestState = "INPROGRESS"
	self:AssertEquals(self.CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	self:AssertEquals(self.CuT.ImageColor3,Color3.new(255/255,150/255,0),"Color is incorrect.")
	self:AssertEquals(self.CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	self:AssertEquals(self.CuT.ImageRectOffset,Vector2.new(256,0),"Spritesheet image position is incorrect.")
	
	--Set the test as passed and assert it is correct.
	self.CuT.TestState = "PASSED"
	self:AssertEquals(self.CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	self:AssertEquals(self.CuT.ImageColor3,Color3.new(0,200/255,0),"Color is incorrect.")
	self:AssertEquals(self.CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	self:AssertEquals(self.CuT.ImageRectOffset,Vector2.new(512,0),"Spritesheet image position is incorrect.")

	--Set the test as failed and assert it is correct.
	self.CuT.TestState = "FAILED"
	self:AssertEquals(self.CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	self:AssertEquals(self.CuT.ImageColor3,Color3.new(200/255,0,0),"Color is incorrect.")
	self:AssertEquals(self.CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	self:AssertEquals(self.CuT.ImageRectOffset,Vector2.new(768,0),"Spritesheet image position is incorrect.")
	
	--Set the test as failed and skipped it is correct.
	self.CuT.TestState = "SKIPPED"
	self:AssertEquals(self.CuT.Image,"http://www.roblox.com/asset/?id=4595118527","Image is incorrect.")
	self:AssertEquals(self.CuT.ImageColor3,Color3.new(220/255,220/255,0),"Color is incorrect.")
	self:AssertEquals(self.CuT.ImageRectSize,Vector2.new(256,256),"Spritesheet image size is incorrect.")
	self:AssertEquals(self.CuT.ImageRectOffset,Vector2.new(0,256),"Spritesheet image position is incorrect.")
end))



return true