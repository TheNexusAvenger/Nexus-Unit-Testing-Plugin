--[[
TheNexusAvenger

Frame for the list of tests and actions.
--]]
--!strict

local SERVICES_WITH_TESTS = {
    game:GetService("Workspace"),
    game:GetService("Lighting"),
    game:GetService("ReplicatedFirst"),
    game:GetService("ReplicatedStorage"),
    game:GetService("ServerScriptService"),
    game:GetService("ServerStorage"),
    game:GetService("StarterGui"),
    game:GetService("StarterPack"),
    game:GetService("StarterPlayer"),
    game:GetService("Teams"),
    game:GetService("SoundService"),
    game:GetService("Chat"),
    game:GetService("LocalizationService"),
    game:GetService("TestService"),
}



local TextService = game:GetService("TextService")

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local ButtonSideBar = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Bar"):WaitForChild("ButtonSideBar"))
local TestProgressBar = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("Bar"):WaitForChild("TestProgressBar"))
local TestListFrame = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("List"):WaitForChild("TestListFrame"))
local NexusUnitTesting = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"))
local TestFinder = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("Runtime"):WaitForChild("TestFinder"))
local UnitTest = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("UnitTest"):WaitForChild("UnitTest"))
local ModuleUnitTest = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("Runtime"):WaitForChild("ModuleUnitTest"))
local NexusEvent = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("NexusInstance"):WaitForChild("Event"):WaitForChild("NexusEvent"))
local NexusPluginComponents = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local TestListView = PluginInstance:Extend()
TestListView:SetClassName("TestListView")

export type TestListView = {
    new: () -> (TestListView),
    Extend: (self: TestListView) -> (TestListView),

    TestOutputOpened: NexusEvent.NexusEvent<UnitTest.UnitTest, boolean>,
} & PluginInstance.PluginInstance & Frame



--[[
Creates a Test List Frame object.
--]]
function TestListView:__new(): ()
    PluginInstance.__new(self, "Frame")

    --Create the state container for the tests.
    self:DisableChangeReplication("Tests")
    self.Tests = NexusPluginComponents.new("SelectionList")
    self:DisableChangeReplication("ModuleScriptsToEntry")
    self.ModuleScriptsToEntry = {}
    self:DisableChangeReplication("TestEvents")
    self.TestEvents = {}
    self:DisableChangeReplication("SelectedTestsNames")
    self.SelectedTestsNames = {}
    self:DisableChangeReplication("CurrentOutputTest")

    --Create the events.
    self:DisableChangeReplication("TestOutputOpened")
    self.TestOutputOpened = NexusEvent.new()

    --Create the bars.
    local SideBar = ButtonSideBar.new()
    SideBar.Parent = self:GetWrappedInstance()
    self:DisableChangeReplication("ButtonSideBar")
    self.ButtonSideBar = SideBar

    local BottomBar = TestProgressBar.new()
    BottomBar.Size = UDim2.new(1, -29, 0, 28)
    BottomBar.Position = UDim2.new(0, 29, 1, -28)
    BottomBar.Parent = self:GetWrappedInstance()
    self:DisableChangeReplication("TestProgressBar")
    self.TestProgressBar = BottomBar

    --Create the text for no tests.
    local NoTestsLabel = NexusPluginComponents.new("TextLabel")
    NoTestsLabel.Size = UDim2.new(1, -32, 0, 16)
    NoTestsLabel.Position = UDim2.new(0, 31, 0, 2)
    NoTestsLabel.Visible = false
    NoTestsLabel.Font = Enum.Font.SourceSansItalic
    NoTestsLabel.Text = "No tests found. Make sure test ModuleScripts end in .spec or .nexusspec"
    NoTestsLabel.Parent = self
    self:DisableChangeReplication("NoTestsLabel")
    self.NoTestsLabel = NoTestsLabel

    --Creating the scrolling frame.
    local ScrollingFrame = NexusPluginComponents.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -29, 1, -29)
    ScrollingFrame.Position = UDim2.new(0, 29, 0, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Parent = self
    self:DisableChangeReplication("ScrollingFrame")
    self.ScrollingFrame = ScrollingFrame

    local ElementList = NexusPluginComponents.new("ElementList", function()
        --Create the frame.
        local Frame = TestListFrame.new()
        Frame.SelectionList = self.Tests
        Frame.TestListView = self

        --Connect the double click.
        Frame.DoubleClicked:Connect(function()
            local Entry = Frame.SelectionListEntry
            if not Entry or not Entry.Test then return end
            self.TestOutputOpened:Fire(Entry.Test)
            self.CurrentOutputTest = Entry.Test.FullName
        end)

        --Return the frame.
        return Frame
    end)
    ElementList.EntryHeight = 20
    ElementList:ConnectScrollingFrame(ScrollingFrame)
    self:DisableChangeReplication("ElementList")
    self.ElementList = ElementList

    --Connect the events.
    local DB = true
    SideBar.RunTestsButton.MouseButton1Down:Connect(function()
        if DB then
            DB = false
            delay(0.1, function() DB = true end)
            self:RunAllTests()
        end
    end)
    SideBar.RunFailedTestsButton.MouseButton1Down:Connect(function()
        if DB then
            DB = false
            delay(0.1, function() DB = true end)
            self:RunFailedTests()
        end
    end)
    SideBar.RunSelectedTestsButton.MouseButton1Down:Connect(function()
        if DB then
            DB = false
            delay(0.1, function() DB = true end)
            self:RunSelectedTests()
        end
    end)

    --Set the defaults.
    self.Size = UDim2.new(1, 0, 1, 0)
end

--[[
Updates the view of tests.
--]]
function TestListView:TestsUpdated(): ()
    --Set the element list.
    local Tests = self.Tests:GetDescendants()
    self.ElementList:SetEntries(Tests)

    --Update the max width.
    local MaxWidth = 100
    for _, Entry in Tests do
        MaxWidth = math.max(MaxWidth, (20 * (Entry.Indent - 1)) + Entry.EntryWidth)
    end
    self.ElementList.CurrentWidth = MaxWidth
end

--[[
Runs all of the detected tests.
--]]
function TestListView:RunAllTests(): ()
    --Find the tests to run.
    local Tests = {}
    local Modules = {}
    for _, Service in SERVICES_WITH_TESTS do
        for _, Test in TestFinder.GetTests(Service) do
            table.insert(Tests, Test)
            Modules[Test.ModuleScript] = true
        end
    end

    --Remove the non-existent tests.
    local EntriesToRemove = {}
    for _, Entry in self.Tests.Children do
        local Test = Entry.Test
        if not Modules[Test.ModuleScript] then
            table.insert(EntriesToRemove, Entry)
        end
    end
    self:RemvoeEntries(EntriesToRemove)

    --Run the tests.
    self:RunTests(Tests)
end

--[[
Reruns the failed test. Runs all of the
tests if no test run was done.
--]]
function TestListView:RunFailedTests()
    --Run all the tests if nothing was run.
    if #self.Tests.Children == 0 then
        self:RunAllTests()
        return
    end

    --[[
    Return if a test contains a failed test.
    --]]
    local function ContainsFailedTest(Test: UnitTest.UnitTest): boolean
        --Return true if the test failed.
        if Test.State == "FAILED" or Test.CombinedState == "FAILED" then
            return true
        end

        --Return if a subtest has a failure.
        for _, SubTest in Test.SubTests :: {UnitTest.UnitTest} do
            if ContainsFailedTest(SubTest :: any) then
                return true
            end
        end

        --Return false (no failure).
        return false
    end

    --Determine the ModuleScripts to rerun.
    local TestsToRerun = {}
    local EntriesToRemove = {}
    for _, Entry in self.Tests.Children do
        local Test = Entry.Test
        if ContainsFailedTest(Test) then
            local ModuleScript = Test.ModuleScript
            if ModuleScript:IsDescendantOf(game) then
                table.insert(TestsToRerun, ModuleUnitTest.new(ModuleScript))
            else
                table.insert(EntriesToRemove, Entry)
            end
        end
    end

    --Remove the non-existent tests.
    self:RemvoeEntries(EntriesToRemove)

    --Run the tests.
    self:RunTests(TestsToRerun)
end

--[[
Reruns the selected test. Runs all of the
tests if tests were selected.
--]]
function TestListView:RunSelectedTests(): ()
    --[[
    Returns if an entry is selected or a child is.
    --]]
    local function EntryIsSelected(Entry: TestListFrame.TestListFrame): boolean
        --If the label is selected, return true.
        if Entry.Selected then
            return true
        end

        --Return true if a subtest is selected.
        for _, SubEntry in Entry.Children do
            if EntryIsSelected(SubEntry) then
                return true
            end
        end

        --Return false (list frame and children aren't selected).
        return false
    end

    --Determine the tests to rerun and the frames to remove.
    local EntriesToRemove = {}
    local TestsToRerun = {}
    for _, Entry in self.Tests.Children do
        --Add the test to be removed if the module was removed.
        if EntryIsSelected(Entry) then
            local ModuleScript = Entry.Test.ModuleScript
            if ModuleScript:IsDescendantOf(game) then
                table.insert(TestsToRerun, ModuleUnitTest.new(ModuleScript))
            else
                table.insert(EntriesToRemove, Entry)
            end
        end
    end

    --Rerun all tests if none are selected.
    if #TestsToRerun == 0 then
        self:RunAllTests()
        return
    end

    --Remove the non-existent tests.
    self:RemvoeEntries(EntriesToRemove)

    --Run the tests.
    self:RunTests(TestsToRerun)
end

--[[
Removes a list of test entries.
--]]
function TestListView:RemvoeEntries(Entries: {TestListFrame.TestListFrame}): ()
    for _, Entry in Entries do
        self.TestProgressBar:RemoveUnitTest(Entry.Test, true)
        self.Tests:RemoveChild(Entry)
        self.ModuleScriptsToEntry[Entry.Test.ModuleScript] = nil
        for _, Event in self.TestEvents[Entry.Test] do
            Event:Disconnect()
        end
        self.TestEvents[Entry.Test] = nil
    end
end

--[[
Connects the events of a test.
--]]
function TestListView:ConnectTest(Test: UnitTest.UnitTest, Entry: TestListFrame.TestListFrame, RootTest: UnitTest.UnitTest, BaseFullName: string?): ()
    BaseFullName = BaseFullName or ""

    --Set up the event storage.
    if not self.TestEvents[RootTest] then
        self.TestEvents[RootTest] = {}
    end
    local Events = self.TestEvents[RootTest]

    --Set the full name.
    local FullName = (BaseFullName :: string)..Test.Name
    Test.FullName = FullName
    Entry.DurationPosition = 22 + 4 + TextService:GetTextSize(Test.Name, 14, Enum.Font.SourceSans, Vector2.new(2000, 16)).X
    Entry.EntryWidth = Entry.DurationPosition

    --Select the list frame if it was selected before.
    if self.SelectedTestsNames[FullName] then
        Entry.Selected = true
    end

    --Connect changing the test state.
    local TestStartTime = 0
    table.insert(Events, Test:GetPropertyChangedSignal("CombinedState"):Connect(function()
        if Test.CombinedState == NexusUnitTesting.TestState.InProgress then
            TestStartTime = tick()
        elseif Test.CombinedState ~= NexusUnitTesting.TestState.NotRun then
            if TestStartTime ~= 0 then
                Entry.Duration = tick() - TestStartTime
                Entry.EntryWidth = Entry.EntryWidth + TextService:GetTextSize(string.format("%.3f", Entry.Duration).." seconds" or "", 14, Enum.Font.SourceSans, Vector2.new(2000, 16)).X + 4
            end
        end
        self:TestsUpdated()
    end))

    --Connect the test outputting.
    if #Test.Output > 0 then
        Entry.HasOutput = true
    else
        Entry.HasOutput = false
        local MessageOutputtedEvent
        MessageOutputtedEvent = Test.MessageOutputted:Connect(function()
            Entry.HasOutput = true
            if MessageOutputtedEvent then
                MessageOutputtedEvent:Disconnect()
                MessageOutputtedEvent = nil :: any
            end
        end)
        table.insert(Events, MessageOutputtedEvent)
        self:TestsUpdated()
    end

    --Connect tests being added.
    Test.TestAdded:Connect(function(NewTest)
        local NewEntry = Entry:CreateChild()
        NewEntry.Test = NewTest
        self:ConnectTest(NewTest, NewEntry, RootTest, FullName.." > ")
    end)

    --Add the existing subtests.
    for _, NewTest in Test.SubTests :: {UnitTest.UnitTest} do
        local NewEntry = Entry:CreateChild()
        NewEntry.Test = NewTest
        self:ConnectTest(NewTest, NewEntry, RootTest, FullName.." > ")
    end

    --Open the output window if the test name matches (test is rerunning).
    if self.CurrentOutputTest == FullName then
        self.TestOutputOpened:Fire(Test, true)
    end
end

--[[
Runs a list of tests.
--]]
function TestListView:RunTests(Tests: {UnitTest.UnitTest}): ()
    --Set the test time.
    self.TestProgressBar:SetTime()

    --Sort the tests.
    table.sort(Tests, function(TestA, TestB)
        return (TestA.Name :: string) < (TestB.Name :: string)
    end)

    --Register the tests.
    for _, Test in Tests do
        self:RegisterTest(Test)
    end

    --Run the tests.
    for _, Test in Tests do
        Test:RunTest()
        Test:RunSubtests()
    end

    --Update the bar if there is no tests.
    if #Tests == 0 then
        self.TestProgressBar:UpdateProgressBar()
        self:TestsUpdated()
    end
    self.NoTestsLabel.Visible = (#self.Tests.Children == 0)
end

--[[
Registers a ModuleScript unit test.
--]]
function TestListView:RegisterTest(ModuleScriptTest: ModuleUnitTest.ModuleUnitTest): ()
    --Remove the existing entry if it exists.
    if self.ModuleScriptsToEntry[ModuleScriptTest.ModuleScript] then
        local Entry = self.ModuleScriptsToEntry[ModuleScriptTest.ModuleScript]
        self.Tests:RemoveChild(Entry)
        self.TestProgressBar:RemoveUnitTest(Entry.Test, true)
    end

    --Create the child entry.
    local Entry = self.Tests:CreateChild()
    Entry.Test = ModuleScriptTest
    self.ModuleScriptsToEntry[ModuleScriptTest.ModuleScript] = Entry
    self.TestProgressBar:AddUnitTest(ModuleScriptTest)

    --Sort the entries.
    table.sort(self.Tests.Children, function(EntryA, entryB)
        return EntryA.Test.Name < entryB.Test.Name
    end)

    --Connect the child.
    self:ConnectTest(ModuleScriptTest, Entry, ModuleScriptTest)
    self:TestsUpdated()
end



return (TestListView :: TestListView) :: any