--[[
TheNexusAvenger

Tests the OutputView class.
--]]
--!strict
--$NexusUnitTestExtensions

local NexusUnitTestingPlugin = game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin")
local OutputView = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("OutputView"))
local UnitTestClass = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("UnitTest"):WaitForChild("UnitTest"))

return function()
    local TestOutputView = nil
    beforeEach(function()
        TestOutputView = OutputView.new()
        TestOutputView.Size = UDim2.new(0, 200, 0, 50 + 22)

        local Parent = Instance.new("ScreenGui")
        Parent.Parent = game:GetService("Lighting")
        TestOutputView.Parent = Parent
        task.wait()
	wait()
    end)
    afterEach(function()
        TestOutputView.Parent:Destroy()
        TestOutputView:Destroy()
    end)

    local function GetLabels()
        local Entries = {}
        for _, Entry in TestOutputView.ScrollingFrame:GetChildren() do
            table.insert(Entries, Entry:FindFirstChildOfClass("TextLabel"))
        end
        return Entries
    end

    describe("An output view", function()
        it("should update the displayed output.", function()
            --Set the output as having no lines and assert the text is correct.
            TestOutputView.OutputLines = {}
            TestOutputView.MaxLineWidth = 50
            TestOutputView:UpdateDisplayedOutput()
            local OutputLabels = GetLabels()
            expect(OutputLabels[1].Text).to.equal("No Output")
            expect(OutputLabels[1].Font).to.equal(Enum.Font.SourceSansItalic)
            expect(OutputLabels[2]).to.equal(nil)
            expect(OutputLabels[3]).to.equal(nil)

            --Set the output as having not enough lines and assert the text is correct.
            TestOutputView.OutputLines = {{Message = "String 1", Type = Enum.MessageType.MessageOutput}, {Message = "String 2", Type = Enum.MessageType.MessageWarning}}
            TestOutputView:UpdateDisplayedOutput()
            OutputLabels = GetLabels()
            expect(OutputLabels[1].Text).to.equal("String 1")
            expect(OutputLabels[1].Font).to.equal(Enum.Font.SourceSans)
            expect(OutputLabels[2].Text).to.equal("String 2")
            expect(OutputLabels[3]).to.equal(nil)
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.WarningText)

            --Set the output as having more than enough lines and assert the text is correct.
            TestOutputView.OutputLines = {{Message = "String 1", Type = Enum.MessageType.MessageOutput}, {Message = "String 2", Type = Enum.MessageType.MessageWarning}, {Message = "String 3", Type = Enum.MessageType.MessageError}, {Message = "String 4", Type = Enum.MessageType.MessageInfo}, {Message = "String 5", Type = Enum.MessageType.MessageInfo}}
            TestOutputView:UpdateDisplayedOutput()
            OutputLabels = GetLabels()
            expect(OutputLabels[1].Text).to.equal("String 1")
            expect(OutputLabels[1].Font).to.equal(Enum.Font.SourceSans)
            expect(OutputLabels[2].Text).to.equal("String 2")
            expect(OutputLabels[3].Text).to.equal("String 3")
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.WarningText)
            expect(OutputLabels[3].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.ErrorText)
        end)

        it("should add output entries.", function()
            --Add an empty string and assert the output is correct.
            TestOutputView:AddOutput("", Enum.MessageType.MessageOutput)
            local OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({{Message = "", Type = Enum.MessageType.MessageOutput}})
            expect(OutputLabels[1].Text).to.equal("")
            expect(OutputLabels[2]).to.equal(nil)
            expect(OutputLabels[3]).to.equal(nil)
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)

            --Add a string and assert the output is correct.
            TestOutputView:AddOutput("String 1", Enum.MessageType.MessageWarning)
            OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({{Message = "" ,Type = Enum.MessageType.MessageOutput}, {Message = "String 1", Type = Enum.MessageType.MessageWarning}})
            expect(OutputLabels[1].Text).to.equal("")
            expect(OutputLabels[2].Text).to.equal("String 1")
            expect(OutputLabels[3]).to.equal(nil)
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.WarningText)

            --Add a string with a new line and assert the output is correct.
            TestOutputView:AddOutput("String 2\nString 3\n", Enum.MessageType.MessageOutput)
            OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({{Message = "", Type = Enum.MessageType.MessageOutput}, {Message = "String 1", Type = Enum.MessageType.MessageWarning}, {Message = "String 2", Type = Enum.MessageType.MessageOutput}, {Message = "String 3", Type = Enum.MessageType.MessageOutput}, {Message = "", Type = Enum.MessageType.MessageOutput}})
            expect(OutputLabels[1].Text).to.equal("")
            expect(OutputLabels[2].Text).to.equal("String 1")
            expect(OutputLabels[3].Text).to.equal("String 2")
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.WarningText)
            expect(OutputLabels[3].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
        end)

        it("should update from set tests.", function()
            --Create 3 tests.
            local Test1, Test2, Test3 = UnitTestClass.new("Test 1"), UnitTestClass.new("Test 2"), UnitTestClass.new("Test 3")
            Test2.FullName = "Test N > Test 2"
            Test2:OutputMessage(Enum.MessageType.MessageOutput, "String 4")
            Test2:OutputMessage(Enum.MessageType.MessageWarning, "String 5")
            local OutputLabels = GetLabels()

            --Set a test, add messages, and assert the messages are displayed.
            TestOutputView:SetTest(Test1)
            Test1:OutputMessage(Enum.MessageType.MessageError, "String 1")
            Test1:OutputMessage(Enum.MessageType.MessageInfo, "String 2\nString 3")
            OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({{Message = "String 1", Type = Enum.MessageType.MessageError}, {Message = "String 2", Type = Enum.MessageType.MessageInfo}, {Message = "String 3", Type = Enum.MessageType.MessageInfo}})
            expect(OutputLabels[1].Text).to.equal("String 1")
            expect(OutputLabels[2].Text).to.equal("String 2")
            expect(OutputLabels[3].Text).to.equal("String 3")
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.ErrorText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.InfoText)
            expect(OutputLabels[3].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.InfoText)
            expect(TestOutputView.TopBarLabel.Text).to.equal("Test 1")
            expect(TestOutputView.TopBarFullNameLabel.Text).to.equal("")

            --Set a test with an existting output and assert the messages are displayed.
            TestOutputView:SetTest(Test2)
            OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({{Message = "String 4", Type = Enum.MessageType.MessageOutput}, {Message = "String 5", Type = Enum.MessageType.MessageWarning}})
            expect(OutputLabels[1].Text).to.equal("String 4")
            expect(OutputLabels[2].Text).to.equal("String 5")
            expect(OutputLabels[3]).to.equal(nil)
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.WarningText)
            expect(TestOutputView.TopBarLabel.Text).to.equal("Test 2")
            expect(TestOutputView.TopBarFullNameLabel.Text).to.equal("(Test N > Test 2)")

            --Send an output for a previous test and assert it wasn't added.
            Test1:OutputMessage(Enum.MessageType.MessageError, "Fail")
            OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({{Message = "String 4", Type = Enum.MessageType.MessageOutput}, {Message = "String 5", Type = Enum.MessageType.MessageWarning}})
            expect(OutputLabels[1].Text).to.equal("String 4")
            expect(OutputLabels[2].Text).to.equal("String 5")
            expect(OutputLabels[3]).to.equal(nil)
            expect(OutputLabels[1].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.MainText)
            expect(OutputLabels[2].TextColor3.ColorEnum).to.equal(Enum.StudioStyleGuideColor.WarningText)

            --Set a test with no existing output and assert the messages are displayed.
            TestOutputView:SetTest(Test3)
            OutputLabels = GetLabels()
            expect(TestOutputView.OutputLines).to.deepEqual({})
            expect(OutputLabels[1].Text).to.equal("No Output")
            expect(OutputLabels[1].Font).to.equal(Enum.Font.SourceSansItalic)
            expect(OutputLabels[2]).to.equal(nil)
            expect(OutputLabels[3]).to.equal(nil)
            expect(TestOutputView.TopBarLabel.Text).to.equal("Test 3")
            expect(TestOutputView.TopBarFullNameLabel.Text).to.equal("")
        end)
    end)
end