--[[
TheNexusAvenger

Frame containing the progress of the tests.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local TestStateIcon = NexusUnitTestingPluginProject:GetResource("UI.TestStateIcon")
local NexusPluginComponents = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents")
local PluginInstance = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Base.PluginInstance")
local NexusUnitTesting = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule")

local TestProgressBar = PluginInstance:Extend()
TestProgressBar:SetClassName("TestProgressBar")



--[[
Creates a Test Progress Bar object.
--]]
function TestProgressBar:__new()
    PluginInstance.__new(self, "Frame")

    --Store the tests.
    self:DisableChangeReplication("TimeText")
    self:DisableChangeReplication("Tests")
    self:DisableChangeReplication("TestEvents")
    self.TimeText = ""
    self.Tests = {}
    self.TestEvents = {}

    --Create the icon.
    local Icon = TestStateIcon.new()
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(0, 6, 0, 6)
    Icon.Parent = self:GetWrappedInstance()
    self:DisableChangeReplication("Icon")
    self.Icon = Icon

    --Create the bars.
    local BarBackground = NexusPluginComponents.new("Frame")
    BarBackground.Size = UDim2.new(1, -32, 0, 6)
    BarBackground.Position = UDim2.new(0, 30, 0, 2)
    BarBackground.BorderSizePixel = 1
    BarBackground.Parent = self

    local PassedBar = NexusPluginComponents.new("Frame")
    PassedBar.Size = UDim2.new(0, 0, 0, 0)
    PassedBar.BorderSizePixel = 0
    PassedBar.BackgroundColor3 = Color3.new(0, 200/255, 0)
    PassedBar.ClipsDescendants = true
    PassedBar.Parent = BarBackground
    self:DisableChangeReplication("PassedBar")
    self.PassedBar = PassedBar

    local FailedBar = NexusPluginComponents.new("Frame")
    FailedBar.Size = UDim2.new(0, 0, 0, 0)
    FailedBar.BorderSizePixel = 0
    FailedBar.BackgroundColor3 = Color3.new(200/255, 0, 0)
    FailedBar.ClipsDescendants = true
    FailedBar.Parent = BarBackground
    self:DisableChangeReplication("FailedBar")
    self.FailedBar = FailedBar

    local SkippedBar = NexusPluginComponents.new("Frame")
    SkippedBar.Size = UDim2.new(0, 0, 0, 0)
    SkippedBar.BorderSizePixel = 0
    SkippedBar.BackgroundColor3 = Color3.new(200/255, 200/255 ,0)
    SkippedBar.ClipsDescendants = true
    SkippedBar.Parent = BarBackground
    self:DisableChangeReplication("SkippedBar")
    self.SkippedBar = SkippedBar

    local TotalsTextLabel = NexusPluginComponents.new("TextLabel")
    TotalsTextLabel.Size = UDim2.new(1, -32, 0, 16)
    TotalsTextLabel.Position = UDim2.new(0, 30, 0, 10)
    TotalsTextLabel.Text = "Not run"
    TotalsTextLabel.Parent = self
    self:DisableChangeReplication("TotalsTextLabel")
    self.TotalsTextLabel = TotalsTextLabel

    --Set the defaults.
    self.BorderSizePixel = 1
    self.Size = UDim2.new(1, 0, 0, 28)
end

--[[
Updates the progress bar.
--]]
function TestProgressBar:UpdateProgressBar()
    --Determinee the amount of each type.
    local TotalTests, InProgressTests, PassedTests, FailedTests, SkippedTests = 0, 0, 0, 0, 0
    for _,Test in pairs(self.Tests) do
        TotalTests = TotalTests + 1

        if Test.State == NexusUnitTesting.TestState.Passed then
            PassedTests = PassedTests + 1
        elseif Test.State == NexusUnitTesting.TestState.InProgress then
            InProgressTests = InProgressTests + 1
        elseif Test.State == NexusUnitTesting.TestState.Failed then
            FailedTests = FailedTests + 1
        elseif Test.State == NexusUnitTesting.TestState.Skipped then
            SkippedTests = SkippedTests + 1
        end
    end

    --Update the icon.
    if InProgressTests > 0 then
        self.Icon.TestState = NexusUnitTesting.TestState.InProgress
    elseif FailedTests > 0 then
        self.Icon.TestState = NexusUnitTesting.TestState.Failed
    elseif PassedTests > 0 then
        self.Icon.TestState = NexusUnitTesting.TestState.Passed
    elseif SkippedTests > 0 then
        self.Icon.TestState = NexusUnitTesting.TestState.Skipped
    else
        self.Icon.TestState = NexusUnitTesting.TestState.NotRun
    end

    --Update the text.
    self.TotalsTextLabel.Text = tostring(PassedTests).." passed, "..tostring(FailedTests).." failed, "..tostring(SkippedTests).." skipped ("..tostring(TotalTests).." total) "..self.TimeText

    --Update the sizes.
    if TotalTests == 0 then TotalTests = 1 end
    self.PassedBar.Size = UDim2.new(PassedTests / TotalTests, 0, 1, 0)
    self.FailedBar.Size = UDim2.new(FailedTests / TotalTests, 0, 1, 0)
    self.SkippedBar.Size = UDim2.new(SkippedTests / TotalTests, 0, 1, 0)
    self.FailedBar.Position = UDim2.new(PassedTests / TotalTests, 0, 0, 0)
    self.SkippedBar.Position = UDim2.new((PassedTests + FailedTests) / TotalTests, 0, 0, 0)
end

--[[
Updates the time text of the test.
Does not update the text automatically.
--]]
function TestProgressBar:SetTime(Hours, Minutes, Seconds)
    --Set the time if it isn't set.
    if not Hours and not Minutes and not Seconds then
        local CurrentTime = os.date("*t", tick())
        Hours, Minutes, Seconds = CurrentTime.hour, CurrentTime.min, CurrentTime.sec
    elseif Hours and not Minutes and not Seconds then
        local CurrentTime = os.date("*t", Hours)
        Hours, Minutes, Seconds = CurrentTime.hour, CurrentTime.min, CurrentTime.sec
    end

    --Format and set the time.
    Hours = tostring(Hours)
    Minutes = string.format("%02d", Minutes)
    Seconds = string.format("%02d", Seconds)
    self.TimeText = "[Started at "..Hours..":"..Minutes..":"..Seconds.."]"
end

--[[
Adds a unit test to track.
--]]
function TestProgressBar:AddUnitTest(UnitTest, DontUpdateBar)
    --Store the test.
    table.insert(self.Tests, UnitTest)

    --Connect the events.
    local Events = {}
    self.TestEvents[UnitTest] = Events
    table.insert(Events, UnitTest:GetPropertyChangedSignal("State"):Connect(function()
        self:UpdateProgressBar()
    end))
    table.insert(Events, UnitTest.TestAdded:Connect(function(SubUnitTest)
        self:AddUnitTest(SubUnitTest)
    end))

    --Add the subtests.
    for _,SubUnitTest in pairs(UnitTest.SubTests) do
        self:AddUnitTest(SubUnitTest,true)
    end

    --Update the bar.
    if DontUpdateBar ~= true then
        self:UpdateProgressBar()
    end
end

--[[
Removes a unit test to track.
--]]
function TestProgressBar:RemoveUnitTest(UnitTest, DontUpdateBar)
    --Remove the unit test.
    for i,Test in pairs(self.Tests) do
        if Test == UnitTest then
            table.remove(self.Tests, i)
            break
        end
    end

    --Disconnect the events.
    for _,Connection in pairs(self.TestEvents[UnitTest] or {}) do
        Connection:Disconnect()
    end

    --Remove the subtests.
    for _,SubUnitTest in pairs(UnitTest.SubTests) do
        self:RemoveUnitTest(SubUnitTest, true)
    end

    --Update the bar.
    if DontUpdateBar ~= true then
        self:UpdateProgressBar()
    end
end



return TestProgressBar