--[[
TheNexusAvenger

Tests the OutputView class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local OutputView = NexusUnitTestingPlugin:GetResource("UI.Window.OutputView")
local UnitTestClass = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.UnitTest.UnitTest")



--[[
Tests right amount of labels are made.
--]]
NexusUnitTesting:RegisterUnitTest("LabelEfficiency",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	UnitTest:AssertEquals(CuT.ClassName,"OutputView","Class name is incorrect.")
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Child objects are exposed.")
	
	--Set the size and assert the correct amount of list frames exist.
	CuT.Size = UDim2.new(0,200,0,170)
	local Temp = CuT.AbsoluteSize
	UnitTest:AssertEquals(#CuT.OutputContainer:GetChildren(),10,"Total labels is incorrect.")
	
	--Resize the frame and assert new labels were created.
	CuT.Size = UDim2.new(0,200,0,200)
	local Temp = CuT.AbsoluteSize
	UnitTest:AssertEquals(#CuT.OutputContainer:GetChildren(),12,"Total labels is incorrect.")
	
	--Reisize the frame and assert labels were removed.
	CuT.Size = UDim2.new(0,200,0,170)
	local Temp = CuT.AbsoluteSize
	UnitTest:AssertEquals(#CuT.OutputContainer:GetChildren(),10,"Total labels is incorrect.")
end)

--[[
Tests the IsScrollBarAtBottom method.
--]]
NexusUnitTesting:RegisterUnitTest("IsScrollBarAtBottom",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Size = UDim2.new(0,200,0,60)
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	
	--Set the output below the size requirement and assert that the scroll bar isn't at the bottom.
	CuT.OutputLines = {{"String 1"},{"String 2"}}
	CuT.MaxLineWidth = 50
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertFalse(CuT:IsScrollBarAtBottom())
	
	--Set the text as requiring a bottom scroll bar and assert that the scroll bar isn't at the bottom.
	CuT.MaxLineWidth = 250
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertFalse(CuT:IsScrollBarAtBottom())
	
	--Add additional output and assert that the scroll bar isn't at the bottom.
	CuT.OutputLines = {{"String 1"},{"String 2"},{"String 3"},{"String 4"}}
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertFalse(CuT:IsScrollBarAtBottom())
	
	--Scroll the frame to the bottom and assert it is at the bottom.
	CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,((4 * 17) + 16) - 60)
	UnitTest:AssertTrue(CuT:IsScrollBarAtBottom())
	
	--Reduce the max length and assert the scroll bar position changed.
	CuT.MaxLineWidth = 50
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertTrue(CuT:IsScrollBarAtBottom())
	UnitTest:AssertEquals(CuT.ScrollingFrame.CanvasPosition.Y,(4 * 17) - 60,"Scroll bar wasn't changed.")
	
	--Increaase the max length and assert the scroll bar position changed.
	CuT.MaxLineWidth = 250
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertTrue(CuT:IsScrollBarAtBottom())
	UnitTest:AssertEquals(CuT.ScrollingFrame.CanvasPosition.Y,((4 * 17) + 16) - 60,"Scroll bar wasn't changed.")
end)

--[[
Tests the UpdateScrollBarSizes method.
--]]
NexusUnitTesting:RegisterUnitTest("UpdateScrollBarSizes",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Size = UDim2.new(0,200,0,50)
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	
	--Set the output below the size requirement and assert the sizes are correct.
	CuT.OutputLines = {{"String 1"},{"String 2"}}
	CuT.MaxLineWidth = 50
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertEquals(CuT.ScrollingFrame.CanvasSize,UDim2.new(0,50,0,34),"Canvas size is incorrect.")
	UnitTest:AssertEquals(CuT.OutputClips.Size,UDim2.new(1,0,1,0),"Clips size is incorrect.")
	
	--Set the max line width to requiring a bottom scroll bar and assert the sizes are correct.
	CuT.MaxLineWidth = 250
	CuT:UpdateScrollBarSizes()
	UnitTest:AssertEquals(CuT.ScrollingFrame.CanvasSize,UDim2.new(0,250,0,34),"Canvas size is incorrect.")
	UnitTest:AssertEquals(CuT.OutputClips.Size,UDim2.new(1,0,1,-17),"Clips size is incorrect.")
end)

--[[
Tests the UpdateContainerPoisiton method.
--]]
NexusUnitTesting:RegisterUnitTest("UpdateContainerPoisiton",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Size = UDim2.new(0,200,0,50)
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	
	--Set the output below the height and assert the position is correct.
	CuT.OutputLines = {{"String 1"},{"String 2"}}
	CuT.MaxLineWidth = 50
	CuT:UpdateScrollBarSizes()
	CuT:UpdateContainerPoisiton()
	UnitTest:AssertEquals(CuT.OutputContainer.Position,UDim2.new(0,0,0,0),"Position is incorrect.")
	
	--Set the output above the height and assert the position is correct.
	CuT.OutputLines = {{"String 1"},{"String 2"},{"String 3"},{"String 4"},{"String 5"},{"String 6"}}
	CuT:UpdateScrollBarSizes()
	CuT:UpdateContainerPoisiton()
	UnitTest:AssertEquals(CuT.OutputContainer.Position,UDim2.new(0,0,0,0),"Position is incorrect.")
	
	--Set the scroll bar position to the middle and assert the position is unchaged.
	CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,10)
	CuT:UpdateContainerPoisiton()
	UnitTest:AssertEquals(CuT.OutputContainer.Position,UDim2.new(0,0,0,0),"Position is incorrect.")
	
	--Set the scroll bar position to the bottom and assert the position is unchaged.
	CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,(6 * 17) - 50)
	CuT:UpdateContainerPoisiton()
	UnitTest:AssertEquals(CuT.OutputContainer.Position,UDim2.new(0,0,0,-1),"Position is incorrect.")
end)

--[[
Tests the UpdateDisplayedOutput method.
--]]
NexusUnitTesting:RegisterUnitTest("UpdateDisplayedOutput",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Size = UDim2.new(0,200,0,50)
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	
	--Set the output as having no lines and assert the text is correct.
	CuT.OutputLines = {}
	CuT.MaxLineWidth = 50
	CuT:UpdateScrollBarSizes()
	CuT:UpdateDisplayedOutput()
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
	
	--Set the output as having not enough lines and assert the text is correct.
	CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning}}
	CuT:UpdateScrollBarSizes()
	CuT:UpdateDisplayedOutput()
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Set the output as having more than enough lines and assert the text is correct.
	CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	CuT:UpdateScrollBarSizes()
	CuT:UpdateDisplayedOutput()
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"String 3","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].TextColor3,"ErrorText","Text color is incorrect.")
	
	--Set the canvas position as nearly scrolled and assert that the correct lines show.
	CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,10)
	CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	CuT:UpdateScrollBarSizes()
	CuT:UpdateDisplayedOutput()
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"String 3","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].TextColor3,"ErrorText","Text color is incorrect.")
	
	--Set the canvas position as scrolled and assert that the correct lines show.
	CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,20)
	CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	CuT:UpdateScrollBarSizes()
	CuT:UpdateDisplayedOutput()
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 2","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 3","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"String 4","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"WarningText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"ErrorText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].TextColor3,"InfoText","Text color is incorrect.")
	
	--Set the canvas position to the bottom and assert that the correct lines show.
	CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,(17 * 5) - 50)
	CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	CuT:UpdateScrollBarSizes()
	CuT:UpdateDisplayedOutput()
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 3","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 4","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"String 5","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"ErrorText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"InfoText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].TextColor3,"InfoText","Text color is incorrect.")
end)

--[[
Tests the AddOutput method.
--]]
NexusUnitTesting:RegisterUnitTest("AddOutput",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Size = UDim2.new(0,200,0,50)
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	
	--Add an empty string and assert the output is correct.
	CuT:AddOutput("",Enum.MessageType.MessageOutput)
	UnitTest:AssertEquals(CuT.OutputLines,{{"",Enum.MessageType.MessageOutput}},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	
	--Add a string and assert the output is correct.
	CuT:AddOutput("String 1",Enum.MessageType.MessageWarning)
	UnitTest:AssertEquals(CuT.OutputLines,{{"",Enum.MessageType.MessageOutput},{"String 1",Enum.MessageType.MessageWarning}},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 1","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Add a string with a new line and assert the output is correct.
	CuT:AddOutput("String 2\nString 3\n",Enum.MessageType.MessageOutput)
	UnitTest:AssertEquals(CuT.OutputLines,{{"",Enum.MessageType.MessageOutput},{"String 1",Enum.MessageType.MessageWarning},{"String 2",Enum.MessageType.MessageOutput},{"String 3",Enum.MessageType.MessageOutput},{"",Enum.MessageType.MessageOutput}},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 1","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"String 2","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].TextColor3,"MainText","Text color is incorrect.")
end)

--[[
Tests the SetTest method.
--]]
NexusUnitTesting:RegisterUnitTest("SetTest",function(UnitTest)
	--Create the component under testing.
	local CuT = OutputView.new()
	CuT.Size = UDim2.new(0,200,0,50)
	CuT.Parent = Instance.new("ScreenGui",game:GetService("Lighting"))
	delay(0.1,function() CuT.Parent:Destroy() end)
	
	--Create 3 tests.
	local Test1,Test2,Test3 = UnitTestClass.new("Test 1"),UnitTestClass.new("Test 2"),UnitTestClass.new("Test 3")
	Test2:OutputMessage(Enum.MessageType.MessageOutput,"String 4")
	Test2:OutputMessage(Enum.MessageType.MessageWarning,"String 5")
	
	--Set a test, add messages, and assert the messages are displayed.
	CuT:SetTest(Test1)
	Test1:OutputMessage(Enum.MessageType.MessageError,"String 1")
	Test1:OutputMessage(Enum.MessageType.MessageInfo,"String 2\nString 3")
	UnitTest:AssertEquals(CuT.OutputLines,{{"String 1",Enum.MessageType.MessageError},{"String 2",Enum.MessageType.MessageInfo},{"String 3",Enum.MessageType.MessageInfo}},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"String 3","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"ErrorText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"InfoText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].TextColor3,"InfoText","Text color is incorrect.")
	
	--Set a test with an existting output and assert the messages are displayed.
	CuT:SetTest(Test2)
	UnitTest:AssertEquals(CuT.OutputLines,{{"String 4",Enum.MessageType.MessageOutput},{"String 5",Enum.MessageType.MessageWarning}},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 4","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 5","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Send an output for a previous test and assert it wasn't added.
	Test1:OutputMessage(Enum.MessageType.MessageError,"Fail")
	UnitTest:AssertEquals(CuT.OutputLines,{{"String 4",Enum.MessageType.MessageOutput},{"String 5",Enum.MessageType.MessageWarning}},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"String 4","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"String 5","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Set a test with no existing output and assert the messages are displayed.
	CuT:SetTest(Test3)
	UnitTest:AssertEquals(CuT.OutputLines,{},"Stored output is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[1].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[2].Text,"","Text is incorrect.")
	UnitTest:AssertEquals(CuT.OutputLabels[3].Text,"","Text is incorrect.")
end)



return true