--[[
TheNexusAvenger

Frame for showing and selecting tests.
--]]
--!strict

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local TestStateIcon = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("TestStateIcon"))
local NexusPluginComponents = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"))
local CollapsableListFrame = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("CollapsableListFrame"))

local TestListFrame = CollapsableListFrame:Extend()
TestListFrame:SetClassName("TestListFrame")

export type TestListFrame = {
    new: () -> (TestListFrame),
    Extend: (self: TestListFrame) -> (TestListFrame),

    Update: (self: TestListFrame, Data: any) -> (),
} & CollapsableListFrame.CollapsableListFrame



--[[
Creates a Test List Frame object.
--]]
function TestListFrame:__new(): ()
    CollapsableListFrame.__new(self)
    self:DisableChangeReplication("TestListView")

    --Create the icon.
    local Icon = TestStateIcon.new()
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(0, 2, 0, 2)
    Icon.Parent = self.AdornFrame
    self:DisableChangeReplication("Icon")
    self.Icon = Icon

    --Create the text for the test name and time.
    local TestNameLabel = NexusPluginComponents.new("TextLabel")
    TestNameLabel.Size = UDim2.new(1, -24, 0, 16)
    TestNameLabel.Position = UDim2.new(0, 22, 0, 1)
    TestNameLabel.Parent = self.AdornFrame
    self:DisableChangeReplication("TestNameLabel")
    self.TestNameLabel = TestNameLabel

    local TestTimeLabel = NexusPluginComponents.new("TextLabel")
    TestTimeLabel.Size = UDim2.new(1, -24, 0, 16)
    TestTimeLabel.TextColor3 = "SubText"
    TestTimeLabel.Text = ""
    TestTimeLabel.Parent = self.AdornFrame
    self:DisableChangeReplication("TestTimeLabel")
    self.TestTimeLabel = TestTimeLabel

    --Set the defaults.
    self.Size = UDim2.new(1, 0, 0, 20)
end

--[[
Updates the value of the list frame.
--]]
function TestListFrame:Update(Data: any): ()
    CollapsableListFrame.Update(self, Data)

    --Update the test display.
    local Test = Data and Data.Test
    if not Test then return end
    self.Icon.TestState = Test.CombinedState
    self.Icon.HasOutput = Data.HasOutput
    self.TestNameLabel.Text = Test.Name
    self.TestTimeLabel.Text = Data.Duration and string.format("%.3f", Data.Duration).." seconds" or ""
    self.TestTimeLabel.Position = UDim2.new(0, Data.DurationPosition, 0, 1)

    --Update if the frame is selected.
    if not self.TestListView or not Test.FullName then return end
    self.TestListView.SelectedTestsNames[Test.FullName] = Data.Selected and true or nil
end



return (TestListFrame :: any) :: TestListFrame