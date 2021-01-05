--[[
TheNexusAvenger

Tests the OutputView class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local OutputView = NexusUnitTestingPlugin:GetResource("UI.Window.OutputView")
local UnitTestClass = NexusUnitTestingPlugin:GetResource("NexusUnitTestingModule.UnitTest.UnitTest")

local OutputViewUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function OutputViewUnitTest:Setup()
	self.CuT = OutputView.new()
	self.CuT.Size = UDim2.new(0,200,0,50 + 22)
	
	--Parent the component under testing to make absolute sizing working.
	self.CuTParent = Instance.new("ScreenGui")
	self.CuTParent.Parent = game:GetService("Lighting")
	self.CuT.Parent = self.CuTParent
end

--[[
Tears down the test.
--]]
function OutputViewUnitTest:Teardown()
	self.CuT:Destroy()
	self.CuTParent:Destroy()
end

--[[
Tests the constructor.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("Constructor"):SetRun(function(self)
	--Assert the component under testing is correct.
	self:AssertEquals(self.CuT.ClassName,"OutputView","Class name is incorrect.")
	self:AssertEquals(#self.CuT:GetChildren(),0,"Child objects are exposed.")
end))

--[[
Tests right amount of labels are made.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("LabelEfficiency"):SetRun(function(self)
	--Set the size and assert the correct amount of list frames exist.
	self.CuT.Size = UDim2.new(0,200,0,170 + 22)
	local Temp = self.CuT.AbsoluteSize
	self:AssertEquals(#self.CuT.OutputContainer:GetChildren(),10,"Total labels is incorrect.")
	
	--Resize the frame and assert new labels were created.
	self.CuT.Size = UDim2.new(0,200,0,200 + 22)
	local Temp = self.CuT.AbsoluteSize
	self:AssertEquals(#self.CuT.OutputContainer:GetChildren(),12,"Total labels is incorrect.")
	
	--Reisize the frame and assert labels were removed.
	self.CuT.Size = UDim2.new(0,200,0,170 + 22)
	local Temp = self.CuT.AbsoluteSize
	self:AssertEquals(#self.CuT.OutputContainer:GetChildren(),10,"Total labels is incorrect.")
end))

--[[
Tests the IsScrollBarAtBottom method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("IsScrollBarAtBottom"):SetRun(function(self)
	--Set the initial size.
	self.CuT.Size = UDim2.new(0,200,0,60 + 22)
	
	--Set the output below the size requirement and assert that the scroll bar isn't at the bottom.
	self.CuT.OutputLines = {{"String 1"},{"String 2"}}
	self.CuT.MaxLineWidth = 50
	self.CuT:UpdateScrollBarSizes()
	self:AssertFalse(self.CuT:IsScrollBarAtBottom())
	
	--Set the text as requiring a bottom scroll bar and assert that the scroll bar isn't at the bottom.
	self.CuT.MaxLineWidth = 250
	self.CuT:UpdateScrollBarSizes()
	self:AssertFalse(self.CuT:IsScrollBarAtBottom())
	
	--Add additional output and assert that the scroll bar isn't at the bottom.
	self.CuT.OutputLines = {{"String 1"},{"String 2"},{"String 3"},{"String 4"}}
	self.CuT:UpdateScrollBarSizes()
	self:AssertFalse(self.CuT:IsScrollBarAtBottom())
	
	--Scroll the frame to the bottom and assert it is at the bottom.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,(5 * 17) - 60)
	self:AssertTrue(self.CuT:IsScrollBarAtBottom())
	
	--Reduce the max length and assert the scroll bar position changed.
	self.CuT.MaxLineWidth = 50
	self.CuT:UpdateScrollBarSizes()
	self:AssertTrue(self.CuT:IsScrollBarAtBottom())
	self:AssertEquals(self.CuT.ScrollingFrame.CanvasPosition.Y,(4 * 17) - 60,"Scroll bar wasn't changed.")
	
	--Increaase the max length and assert the scroll bar position changed.
	self.CuT.MaxLineWidth = 250
	self.CuT:UpdateScrollBarSizes()
	self:AssertTrue(self.CuT:IsScrollBarAtBottom())
	self:AssertEquals(self.CuT.ScrollingFrame.CanvasPosition.Y,(5 * 17) - 60,"Scroll bar wasn't changed.")
end))

--[[
Tests the UpdateScrollBarSizes method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("UpdateScrollBarSizes"):SetRun(function(self)
	--Set the output below the size requirement and assert the sizes are correct.
	self.CuT.OutputLines = {{"String 1"},{"String 2"}}
	self.CuT.MaxLineWidth = 50
	self.CuT:UpdateScrollBarSizes()
	self:AssertEquals(self.CuT.ScrollingFrame.CanvasSize,UDim2.new(0,50,0,34),"Canvas size is incorrect.")
	self:AssertEquals(self.CuT.OutputClips.Size,UDim2.new(1,0,1,-22),"Clips size is incorrect.")
	
	--Set the max line width to requiring a bottom scroll bar and assert the sizes are correct.
	self.CuT.MaxLineWidth = 250
	self.CuT:UpdateScrollBarSizes()
	self:AssertEquals(self.CuT.ScrollingFrame.CanvasSize,UDim2.new(0,250,0,34),"Canvas size is incorrect.")
	self:AssertEquals(self.CuT.OutputClips.Size,UDim2.new(1,0,1,-(17 + 22)),"Clips size is incorrect.")
end))

--[[
Tests the UpdateContainerPoisiton method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("UpdateContainerPoisiton"):SetRun(function(self)
	--Set the output below the height and assert the position is correct.
	self.CuT.OutputLines = {{"String 1"},{"String 2"}}
	self.CuT.MaxLineWidth = 50
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateContainerPoisiton()
	self:AssertEquals(self.CuT.OutputContainer.Position,UDim2.new(0,0,0,0),"Position is incorrect.")
	
	--Set the output above the height and assert the position is correct.
	self.CuT.OutputLines = {{"String 1"},{"String 2"},{"String 3"},{"String 4"},{"String 5"},{"String 6"}}
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateContainerPoisiton()
	self:AssertEquals(self.CuT.OutputContainer.Position,UDim2.new(0,0,0,0),"Position is incorrect.")
	
	--Set the scroll bar position to the middle and assert the position is unchaged.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,10)
	self.CuT:UpdateContainerPoisiton()
	self:AssertEquals(self.CuT.OutputContainer.Position,UDim2.new(0,0,0,0),"Position is incorrect.")
	
	--Set the scroll bar position to the bottom and assert the position is unchaged.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,(6 * 17) - 50)
	self.CuT:UpdateContainerPoisiton()
	self:AssertEquals(self.CuT.OutputContainer.Position,UDim2.new(0,0,0,-1),"Position is incorrect.")
end))

--[[
Tests the UpdateDisplayedOutput method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("UpdateDisplayedOutput"):SetRun(function(self)
	--Set the output as having no lines and assert the text is correct.
	self.CuT.OutputLines = {}
	self.CuT.MaxLineWidth = 50
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	
	--Set the output as having not enough lines and assert the text is correct.
	self.CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning}}
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Set the output as having more than enough lines and assert the text is correct.
	self.CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"String 3","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].TextColor3,"ErrorText","Text color is incorrect.")
	
	--Set the canvas position as nearly scrolled and assert that the correct lines show.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,10)
	self.CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"String 3","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].TextColor3,"ErrorText","Text color is incorrect.")
	
	--Set the canvas position as scrolled and assert that the correct lines show.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,20)
	self.CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 2","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 3","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"String 4","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"WarningText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"ErrorText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].TextColor3,"InfoText","Text color is incorrect.")
	
	--Set the canvas position to the bottom and assert that the correct lines show.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0,(17 * 5) - 50)
	self.CuT.OutputLines = {{"String 1",Enum.MessageType.MessageOutput},{"String 2",Enum.MessageType.MessageWarning},{"String 3",Enum.MessageType.MessageError},{"String 4",Enum.MessageType.MessageInfo},{"String 5",Enum.MessageType.MessageInfo}}
	self.CuT:UpdateScrollBarSizes()
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 3","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 4","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"String 5","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"ErrorText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"InfoText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].TextColor3,"InfoText","Text color is incorrect.")
end))

--[[
Tests the AddOutput method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("AddOutput"):SetRun(function(self)
	--Add an empty string and assert the output is correct.
	self.CuT:AddOutput("",Enum.MessageType.MessageOutput)
	self:AssertEquals(self.CuT.OutputLines,{{"",Enum.MessageType.MessageOutput}},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	
	--Add a string and assert the output is correct.
	self.CuT:AddOutput("String 1",Enum.MessageType.MessageWarning)
	self:AssertEquals(self.CuT.OutputLines,{{"",Enum.MessageType.MessageOutput},{"String 1",Enum.MessageType.MessageWarning}},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 1","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Add a string with a new line and assert the output is correct.
	self.CuT:AddOutput("String 2\nString 3\n",Enum.MessageType.MessageOutput)
	self:AssertEquals(self.CuT.OutputLines,{{"",Enum.MessageType.MessageOutput},{"String 1",Enum.MessageType.MessageWarning},{"String 2",Enum.MessageType.MessageOutput},{"String 3",Enum.MessageType.MessageOutput},{"",Enum.MessageType.MessageOutput}},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 1","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"String 2","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].TextColor3,"MainText","Text color is incorrect.")
end))

--[[
Tests the SetTest method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("SetTest"):SetRun(function(self)
	--Create 3 tests.
	local Test1,Test2,Test3 = UnitTestClass.new("Test 1"),UnitTestClass.new("Test 2"),UnitTestClass.new("Test 3")
	Test2.FullName = "Test N > Test 2"
	Test2:OutputMessage(Enum.MessageType.MessageOutput,"String 4")
	Test2:OutputMessage(Enum.MessageType.MessageWarning,"String 5")
	
	--Set a test, add messages, and assert the messages are displayed.
	self.CuT:SetTest(Test1)
	Test1:OutputMessage(Enum.MessageType.MessageError,"String 1")
	Test1:OutputMessage(Enum.MessageType.MessageInfo,"String 2\nString 3")
	self:AssertEquals(self.CuT.OutputLines,{{"String 1",Enum.MessageType.MessageError},{"String 2",Enum.MessageType.MessageInfo},{"String 3",Enum.MessageType.MessageInfo}},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 1","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 2","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"String 3","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"ErrorText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"InfoText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].TextColor3,"InfoText","Text color is incorrect.")
	self:AssertEquals(self.CuT.TopBarLabel.Text,"Test 1","Displayed test name is incorrect.")
	self:AssertEquals(self.CuT.TopBarFullNameLabel.Text,"","Displayed full test name is incorrect.")
	
	--Set a test with an existting output and assert the messages are displayed.
	self.CuT:SetTest(Test2)
	self:AssertEquals(self.CuT.OutputLines,{{"String 4",Enum.MessageType.MessageOutput},{"String 5",Enum.MessageType.MessageWarning}},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 4","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 5","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	self:AssertEquals(self.CuT.TopBarLabel.Text,"Test 2","Displayed test name is incorrect.")
	self:AssertEquals(self.CuT.TopBarFullNameLabel.Text,"(Test N > Test 2)","Displayed full test name is incorrect.")
	
	--Send an output for a previous test and assert it wasn't added.
	Test1:OutputMessage(Enum.MessageType.MessageError,"Fail")
	self:AssertEquals(self.CuT.OutputLines,{{"String 4",Enum.MessageType.MessageOutput},{"String 5",Enum.MessageType.MessageWarning}},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"String 4","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"String 5","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].TextColor3,"MainText","Text color is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].TextColor3,"WarningText","Text color is incorrect.")
	
	--Set a test with no existing output and assert the messages are displayed.
	self.CuT:SetTest(Test3)
	self:AssertEquals(self.CuT.OutputLines,{},"Stored output is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[1].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[2].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.OutputLabels[3].Text,"","Text is incorrect.")
	self:AssertEquals(self.CuT.TopBarLabel.Text,"Test 3","Displayed test name is incorrect.")
	self:AssertEquals(self.CuT.TopBarFullNameLabel.Text,"","Displayed full test name is incorrect.")
end))



return true