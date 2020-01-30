--[[
TheNexusAvenger

Tests the TestScrollingListFrame class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local TestScrollingListFrame = NexusUnitTestingPlugin:GetResource("UI.TestScrollingListFrame")
local NexusPluginFramework = NexusUnitTestingPlugin:GetResource("NexusPluginFramework")



--[[
Tests setting the CombinedState in the test.
--]]
NexusUnitTesting:RegisterUnitTest("CombinedStateTest",function(UnitTest)
	--Create the component under testing and assert it is the correct size.
	local CuT = TestScrollingListFrame.new()
	UnitTest:AssertEquals(CuT.CanvasSize,UDim2.new(0,0,0,0),"Default canvas size is incorrect.")
	
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
	Frame1.Parent = CuT
	Frame3.Parent = CuT
	Frame2.Parent = CuT
	
	--Assert the positions and canvas size are correct.
	UnitTest:AssertEquals(Frame1.AbsolutePosition,Vector2.new(0,0),"Position is incorrect.")
	UnitTest:AssertEquals(Frame2.AbsolutePosition,Vector2.new(0,200),"Position is incorrect.")
	UnitTest:AssertEquals(Frame3.AbsolutePosition,Vector2.new(0,400),"Position is incorrect.")
	UnitTest:AssertEquals(CuT.CanvasSize,UDim2.new(0,0,0,600),"Canvas size is incorrect.")
	
	--Remove 2 frames and assert the position and canvas size are correct.
	Frame1:Destroy()
	Frame2:Destroy()
	UnitTest:AssertEquals(Frame3.AbsolutePosition,Vector2.new(0,0),"Position is incorrect.")
	UnitTest:AssertEquals(CuT.CanvasSize,UDim2.new(0,0,0,200),"Canvas size is incorrect.")
	
	--Remove the last frame and assert the canvas size resets.
	Frame3:Destroy()
	UnitTest:AssertEquals(CuT.CanvasSize,UDim2.new(0,0,0,200),"Canvas size is incorrect.")
end)



return true