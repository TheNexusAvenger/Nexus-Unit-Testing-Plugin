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
Returns the output labels of the view.
--]]
function OutputViewUnitTest:GetLabels()
	local Entries = {}
	for _, Entry in pairs(self.CuT.ElementList.FrameEntries) do
		table.insert(Entries, Entry:GetChildren()[1])
	end
	return Entries
end

--[[
Tests the UpdateDisplayedOutput method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("UpdateDisplayedOutput"):SetRun(function(self)
	--Set the output as having no lines and assert the text is correct.
	self.CuT.OutputLines = {}
	self.CuT.MaxLineWidth = 50
	self.CuT:UpdateDisplayedOutput()
	local OutputLabels = self:GetLabels()
	self:AssertEquals(OutputLabels[1].Text, "No Output", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSansItalic, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")

	--Set the output as having not enough lines and assert the text is correct.
	self.CuT.OutputLines = {{"String 1", Enum.MessageType.MessageOutput}, {"String 2", Enum.MessageType.MessageWarning}}
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(OutputLabels[1].Text, "String 1", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSans, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 2", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")

	--Set the output as having more than enough lines and assert the text is correct.
	self.CuT.OutputLines = {{"String 1", Enum.MessageType.MessageOutput}, {"String 2", Enum.MessageType.MessageWarning}, {"String 3", Enum.MessageType.MessageError}, {"String 4", Enum.MessageType.MessageInfo}, {"String 5", Enum.MessageType.MessageInfo}}
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(OutputLabels[1].Text, "String 1", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSans, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 2", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "String 3", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[3].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.ErrorText, "Text color is incorrect.")

	--Set the canvas position as nearly scrolled and assert that the correct lines show.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0, 10)
	self.CuT.OutputLines = {{"String 1", Enum.MessageType.MessageOutput}, {"String 2", Enum.MessageType.MessageWarning}, {"String 3", Enum.MessageType.MessageError}, {"String 4", Enum.MessageType.MessageInfo}, {"String 5", Enum.MessageType.MessageInfo}}
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(OutputLabels[1].Text, "String 1", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSans, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 2", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "String 3", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[3].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.ErrorText, "Text color is incorrect.")

	--Set the canvas position as scrolled and assert that the correct lines show.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0, 20)
	self.CuT.OutputLines = {{"String 1", Enum.MessageType.MessageOutput}, {"String 2", Enum.MessageType.MessageWarning}, {"String 3", Enum.MessageType.MessageError}, {"String 4", Enum.MessageType.MessageInfo}, {"String 5", Enum.MessageType.MessageInfo}}
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(OutputLabels[1].Text, "String 2", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSans, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 3", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "String 4", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.ErrorText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[3].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.InfoText, "Text color is incorrect.")

	--Set the canvas position to the bottom and assert that the correct lines show.
	self.CuT.ScrollingFrame.CanvasPosition = Vector2.new(0, (17 * 5) - 50)
	self.CuT.OutputLines = {{"String 1", Enum.MessageType.MessageOutput}, {"String 2", Enum.MessageType.MessageWarning}, {"String 3", Enum.MessageType.MessageError}, {"String 4", Enum.MessageType.MessageInfo}, {"String 5", Enum.MessageType.MessageInfo}}
	self.CuT:UpdateDisplayedOutput()
	self:AssertEquals(OutputLabels[1].Text, "String 3", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSans, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 4", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "String 5", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.ErrorText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.InfoText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[3].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.InfoText, "Text color is incorrect.")
end))

--[[
Tests the AddOutput method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("AddOutput"):SetRun(function(self)
	--Add an empty string and assert the output is correct.
	self.CuT:AddOutput("", Enum.MessageType.MessageOutput)
	local OutputLabels = self:GetLabels()
	self:AssertEquals(self.CuT.OutputLines, {{"", Enum.MessageType.MessageOutput}}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")

	--Add a string and assert the output is correct.
	self.CuT:AddOutput("String 1", Enum.MessageType.MessageWarning)
	self:AssertEquals(self.CuT.OutputLines,{{"" ,Enum.MessageType.MessageOutput}, {"String 1", Enum.MessageType.MessageWarning}}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 1", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")

	--Add a string with a new line and assert the output is correct.
	self.CuT:AddOutput("String 2\nString 3\n", Enum.MessageType.MessageOutput)
	self:AssertEquals(self.CuT.OutputLines,{{"", Enum.MessageType.MessageOutput}, {"String 1", Enum.MessageType.MessageWarning}, {"String 2", Enum.MessageType.MessageOutput}, {"String 3", Enum.MessageType.MessageOutput}, {"", Enum.MessageType.MessageOutput}}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 1", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "String 2", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[3].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
end))

--[[
Tests the SetTest method.
--]]
NexusUnitTesting:RegisterUnitTest(OutputViewUnitTest.new("SetTest"):SetRun(function(self)
	--Create 3 tests.
	local Test1,Test2,Test3 = UnitTestClass.new("Test 1"), UnitTestClass.new("Test 2"), UnitTestClass.new("Test 3")
	Test2.FullName = "Test N > Test 2"
	Test2:OutputMessage(Enum.MessageType.MessageOutput, "String 4")
	Test2:OutputMessage(Enum.MessageType.MessageWarning, "String 5")
	local OutputLabels = self:GetLabels()

	--Set a test, add messages, and assert the messages are displayed.
	self.CuT:SetTest(Test1)
	Test1:OutputMessage(Enum.MessageType.MessageError, "String 1")
	Test1:OutputMessage(Enum.MessageType.MessageInfo, "String 2\nString 3")
	self:AssertEquals(self.CuT.OutputLines, {{"String 1", Enum.MessageType.MessageError}, {"String 2", Enum.MessageType.MessageInfo}, {"String 3", Enum.MessageType.MessageInfo}}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "String 1", "Text is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 2", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "String 3", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.ErrorText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.InfoText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[3].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.InfoText, "Text color is incorrect.")
	self:AssertEquals(self.CuT.TopBarLabel.Text, "Test 1", "Displayed test name is incorrect.")
	self:AssertEquals(self.CuT.TopBarFullNameLabel.Text, "", "Displayed full test name is incorrect.")

	--Set a test with an existting output and assert the messages are displayed.
	self.CuT:SetTest(Test2)
	self:AssertEquals(self.CuT.OutputLines, {{"String 4", Enum.MessageType.MessageOutput}, {"String 5", Enum.MessageType.MessageWarning}}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "String 4", "Text is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 5", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")
	self:AssertEquals(self.CuT.TopBarLabel.Text, "Test 2", "Displayed test name is incorrect.")
	self:AssertEquals(self.CuT.TopBarFullNameLabel.Text, "(Test N > Test 2)", "Displayed full test name is incorrect.")

	--Send an output for a previous test and assert it wasn't added.
	Test1:OutputMessage(Enum.MessageType.MessageError, "Fail")
	self:AssertEquals(self.CuT.OutputLines, {{"String 4", Enum.MessageType.MessageOutput}, {"String 5", Enum.MessageType.MessageWarning}}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "String 4", "Text is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "String 5", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.MainText, "Text color is incorrect.")
	self:AssertEquals(OutputLabels[2].TextColor3.ColorEnum, Enum.StudioStyleGuideColor.WarningText, "Text color is incorrect.")

	--Set a test with no existing output and assert the messages are displayed.
	self.CuT:SetTest(Test3)
	self:AssertEquals(self.CuT.OutputLines, {}, "Stored output is incorrect.")
	self:AssertEquals(OutputLabels[1].Text, "No Output", "Text is incorrect.")
	self:AssertEquals(OutputLabels[1].Font, Enum.Font.SourceSansItalic, "Font is incorrect.")
	self:AssertEquals(OutputLabels[2].Text, "", "Text is incorrect.")
	self:AssertEquals(OutputLabels[3].Text, "", "Text is incorrect.")
	self:AssertEquals(self.CuT.TopBarLabel.Text, "Test 3", "Displayed test name is incorrect.")
	self:AssertEquals(self.CuT.TopBarFullNameLabel.Text, "", "Displayed full test name is incorrect.")
end))



return true