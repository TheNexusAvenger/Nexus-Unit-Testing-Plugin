--[[
TheNexusAvenger

Frame for viewing the output of a test.
--]]

local TEXT_MARGIN_PIXELS = 3
local LINE_HEIGHT_PIXELS = 17



local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local NexusPluginComponents = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents")
local PluginInstance = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Base.PluginInstance")
local OutputTextEntry = NexusUnitTestingPluginProject:GetResource("UI.List.OutputTextEntry")

local TextService = game:GetService("TextService")

local OutputView = PluginInstance:Extend()
OutputView:SetClassName("OutputView")



--[[
Creates a Output View frame object.
--]]
function OutputView:__new()
    self:InitializeSuper("Frame")

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

    local ElementList = NexusPluginComponents.new("ElementList", OutputTextEntry)
    ElementList.EntryHeight = LINE_HEIGHT_PIXELS
    ElementList:ConnectScrollingFrame(ScrollingFrame)
    self:DisableChangeReplication("ElementList")
    self.ElementList = ElementList

    self:DisableChangeReplication("MaxLineWidth")
    self:GetPropertyChangedSignal("MaxLineWidth"):Connect(function()
        ElementList.CurrentWidth = math.max(100, self.MaxLineWidth)
    end)
    self.MaxLineWidth = 0

    --Set the defaults.
    self.Size = UDim2.new(1, 0, 1, 0)
    self.ElementList:SetEntries({{Message="No Test Selected"}})
end

--[[
Updates the displayed output.
--]]
function OutputView:UpdateDisplayedOutput()
    if #self.OutputLines == 0 then
        self.ElementList:SetEntries({{Message="No Output"}})
    else
        self.ElementList:SetEntries(self.OutputLines)
    end
end

--[[
Processes a new output entry.
--]]
function OutputView:ProcessOutput(String, Type)
    --If the string has multiple lines, split the string and add them.
    if string.find(String,"\n") then
        for _,SubString in pairs(string.split(String,"\n")) do
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
function OutputView:AddOutput(String, Type)
    self:ProcessOutput(String, Type)
    self:UpdateDisplayedOutput()
end

--[[
Sets the test to use for the output.
--]]
function OutputView:SetTest(Test)
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
    for _,Event in pairs(self.TestEvents) do
        Event:Disconnect()
    end
    self.TestEvents = {}

    --Add the existing output.
    for _, Output in pairs(Test.Output) do
        self:ProcessOutput(Output.Message, Output.Type)
    end
    self:UpdateDisplayedOutput()

    --Connect the events.
    table.insert(self.TestEvents,Test.MessageOutputted:Connect(function(Message,Type)
        self:AddOutput(Message,Type)
    end))
end



return OutputView