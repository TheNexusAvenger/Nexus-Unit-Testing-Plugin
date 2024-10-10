--[[
TheNexusAvenger

Frame for viewing the output of a test.
--]]
--!strict

local TEXT_MARGIN_PIXELS = 3
local LINE_HEIGHT_PIXELS = 17



local TextService = game:GetService("TextService")

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local NexusPluginComponents = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))
local OutputTextEntry = require(NexusUnitTestingPlugin:WaitForChild("UI"):WaitForChild("List"):WaitForChild("OutputTextEntry"))
local UnitTest = require(NexusUnitTestingPlugin:WaitForChild("NexusUnitTestingModule"):WaitForChild("UnitTest"):WaitForChild("UnitTest"))
local NexusVirtualList = require(NexusUnitTestingPlugin:WaitForChild("NexusVirtualList"))

local OutputView = PluginInstance:Extend()
OutputView:SetClassName("OutputView")

export type OutputView = {
    new: () -> (OutputView),
    Extend: (self: OutputView) -> (OutputView),

    AddOutput: (self: OutputView, String: string, Type: Enum.MessageType) -> (),
    SetTest: (self: OutputView, Test: UnitTest.UnitTest) -> (),
} & PluginInstance.PluginInstance & Frame



--[[
Creates a Output View frame object.
--]]
function OutputView:__new(): ()
    PluginInstance.__new(self, "Frame")

    --Store the output data.
    self:DisableChangeReplication("OutputLines")
    self.OutputLines = {}
    self:DisableChangeReplication("TestEvents")
    self.TestEvents = {}

    --Create the top bar.
    local TopBar = NexusPluginComponents.new("Frame")
    TopBar.BorderSizePixel = 1
    TopBar.Size = UDim2.new(1, 0, 0, 21)
    TopBar.Parent = self

    local TopBarLabel = NexusPluginComponents.new("TextLabel")
    TopBarLabel.Size = UDim2.new(1, -4, 0, 16)
    TopBarLabel.Position = UDim2.new(0, 2, 0, 2)
    TopBarLabel.Text = ""
    TopBarLabel.Font = Enum.Font.SourceSansBold
    TopBarLabel.Parent = TopBar
    self:DisableChangeReplication("TopBarLabel")
    self.TopBarLabel = TopBarLabel

    local TopBarFullNameLabel = NexusPluginComponents.new("TextLabel")
    TopBarFullNameLabel.Size = UDim2.new(1, -4, 0, 16)
    TopBarFullNameLabel.Position = UDim2.new(0, 2, 0, 2)
    TopBarFullNameLabel.Text = ""
    TopBarFullNameLabel.Font = Enum.Font.SourceSansItalic
    TopBarFullNameLabel.Parent = TopBar
    self:DisableChangeReplication("TopBarFullNameLabel")
    self.TopBarFullNameLabel = TopBarFullNameLabel

    --Create the scrolling frame.
    local ScrollingFrame = NexusPluginComponents.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -22)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 22)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Parent = self
    self:DisableChangeReplication("ScrollingFrame")
    self.ScrollingFrame = ScrollingFrame

    local VirtualList = NexusVirtualList.CreateVirtualScrollList(ScrollingFrame, OutputTextEntry.new)
    VirtualList:SetEntryHeight(LINE_HEIGHT_PIXELS)
    self:DisableChangeReplication("VirtualList")
    self.VirtualList = VirtualList

    self:DisableChangeReplication("MaxLineWidth")
    self:GetPropertyChangedSignal("MaxLineWidth"):Connect(function()
        VirtualList:SetScrollWidth(UDim.new(0, math.max(100, self.MaxLineWidth)))
    end)
    self.MaxLineWidth = 0

    --Set the defaults.
    self:DisableChangeReplication("GuiInstance")
    self.GuiInstance = self
    self.Size = UDim2.new(1, 0, 1, 0)
    self.VirtualList:SetData({{Message="No Test Selected"}})
end

--[[
Updates the displayed output.
--]]
function OutputView:UpdateDisplayedOutput(): ()
    if #self.OutputLines == 0 then
        self.VirtualList:SetData({{Message = "No Output"}})
    else
        self.VirtualList:SetData(self.OutputLines)
    end
end

--[[
Processes a new output entry.
--]]
function OutputView:ProcessOutput(String: string, Type: Enum.MessageType): ()
    --If the string has multiple lines, split the string and add them.
    if string.find(String,"\n") then
        for _,SubString in string.split(String,"\n") do
            self:AddOutput(SubString, Type)
        end
        return
    end

    --Add the string.
    table.insert(self.OutputLines, {Message = String, Type = Type})

    --Update the max size.
    local StringWidth = TextService:GetTextSize(String, 14, Enum.Font.SourceSans, Vector2.new(2000, LINE_HEIGHT_PIXELS)).X + (TEXT_MARGIN_PIXELS * 2)
    if StringWidth > self.MaxLineWidth then
        self.MaxLineWidth = StringWidth
    end
end

--[[
Adds a line to display in the output.
--]]
function OutputView:AddOutput(String: string, Type: Enum.MessageType)
    self:ProcessOutput(String, Type)
    self:UpdateDisplayedOutput()
end

--[[
Sets the test to use for the output.
--]]
function OutputView:SetTest(Test: UnitTest.UnitTest): ()
    --Set the top bar name.
    self.TopBarLabel.Text = Test.Name
    if Test.FullName then
        self.TopBarFullNameLabel.Text = "("..Test.FullName..")"
        self.TopBarFullNameLabel.Position = UDim2.new(0, TextService:GetTextSize(Test.Name, 14, Enum.Font.SourceSansBold, Vector2.new(2000, 16)).X + 4, 0, 2)
    else
        self.TopBarFullNameLabel.Text = ""
    end

    --Clear the output.
    self.OutputLines = {}
    self.MaxLineWidth = 0

    --Disconnect the existing events.
    for _,Event in self.TestEvents do
        Event:Disconnect()
    end
    self.TestEvents = {}

    --Add the existing output.
    for _, Output in Test.Output :: {{Message: string, Type: Enum.MessageType}} do
        self:ProcessOutput(Output.Message, Output.Type)
    end
    self:UpdateDisplayedOutput()

    --Connect the events.
    table.insert(self.TestEvents,Test.MessageOutputted:Connect(function(Message,Type)
        self:AddOutput(Message,Type)
    end))
end



return (OutputView :: any) :: OutputView