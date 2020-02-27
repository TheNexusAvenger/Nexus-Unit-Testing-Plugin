--[[
TheNexusAvenger

Tests the TestScrollingListFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestScrollingListFrame = NexusUnitTestingPlugin:GetResource("UI.List.TestScrollingListFrame")
local NexusPluginFramework = NexusUnitTestingPlugin:GetResource("NexusPluginFramework")

local TestScrollingListFrameUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function TestScrollingListFrameUnitTest:Setup()
	self.CuT = TestScrollingListFrame.new()
end

--[[
Tears down the test.
--]]
function TestScrollingListFrameUnitTest:Teardown()
	self.CuT:Destroy()
end

--[[
Tests setting the CombinedState in the test.
--]]
NexusUnitTesting:RegisterUnitTest(TestScrollingListFrameUnitTest.new("CombinedStateTest"):SetRun(function(self)
	--The component under testing is the correct size.
	self:AssertEquals(self.CuT.CanvasSize,UDim2.new(0,0,0,0),"Default canvas size is incorrect.")
	
	--Add several frames.
	local Frame1 = NexusPluginFramework.new("Frame")
	Frame1.Name = "Frame1"
	Frame1.Size = UDim2.new(0,200,0,200)
	local Frame2 = NexusPluginFramework.new("Frame")
	Frame2.Name = "Frame2"
	Frame2.Size = UDim2.new(0,200,0,200)
	local Frame3 = NexusPluginFramework.new("Frame")
	Frame3.Name = "Frame3"
	Frame3.Size = UDim2.new(0,200,0,200)
	Frame1.Parent = self.CuT
	Frame3.Parent = self.CuT
	Frame2.Parent = self.CuT
	
	--Assert the positions and canvas size are correct.
	self:AssertEquals(Frame1.AbsolutePosition,Vector2.new(0,0),"Position is incorrect.")
	self:AssertEquals(Frame2.AbsolutePosition,Vector2.new(0,200),"Position is incorrect.")
	self:AssertEquals(Frame3.AbsolutePosition,Vector2.new(0,400),"Position is incorrect.")
	self:AssertEquals(self.CuT.CanvasSize,UDim2.new(0,0,0,600),"Canvas size is incorrect.")
	
	--Remove 2 frames and assert the position and canvas size are correct.
	Frame1:Destroy()
	Frame2:Destroy()
	self:AssertEquals(Frame3.AbsolutePosition,Vector2.new(0,0),"Position is incorrect.")
	self:AssertEquals(self.CuT.CanvasSize,UDim2.new(0,0,0,200),"Canvas size is incorrect.")
	
	--Remove the last frame and assert the canvas size resets.
	Frame3:Destroy()
	self:AssertEquals(self.CuT.CanvasSize,UDim2.new(0,0,0,200),"Canvas size is incorrect.")
end))



return true