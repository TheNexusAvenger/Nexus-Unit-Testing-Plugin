--[[
TheNexusAvenger

Entry for the output.
--]]
--!strict

local TEXT_MARGIN_PIXELS = 3
local ENUMS_TO_COLORS = {
    [Enum.MessageType.MessageOutput] = Enum.StudioStyleGuideColor.MainText,
    [Enum.MessageType.MessageWarning] = Enum.StudioStyleGuideColor.WarningText,
    [Enum.MessageType.MessageError] = Enum.StudioStyleGuideColor.ErrorText,
    [Enum.MessageType.MessageInfo] = Enum.StudioStyleGuideColor.InfoText,
}



local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local OutputTextEntry = PluginInstance:Extend()
OutputTextEntry:SetClassName("OutputView")

export type OutputTextEntry = {
    GuiInstance: GuiObject,
    new: (InitialIndex: number, InitialData: any) -> (OutputTextEntry),
    Extend: (self: OutputTextEntry) -> (OutputTextEntry),

    Update: (self: OutputTextEntry, Index: number, Data: {Message: string, Type: Enum.MessageType}?) -> (),
} & PluginInstance.PluginInstance & Frame



--[[
Creates the text entry.
--]]
function OutputTextEntry:__new(InitialIndex: number, InitialData: any): ()
    PluginInstance.__new(self, "Frame")

    --Create the text.
    local TextLabel = PluginInstance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -(2 * TEXT_MARGIN_PIXELS), 1, 0)
    TextLabel.Position = UDim2.new(0, TEXT_MARGIN_PIXELS, 0, 0)
    TextLabel.Parent = self
    self:DisableChangeReplication("TextLabel")
    self.TextLabel = TextLabel

    --Set the initial data.
    self:DisableChangeReplication("GuiInstance")
    self.GuiInstance = self
    self:Update(InitialIndex, InitialData)
end

--[[
Updates the text.
--]]
function OutputTextEntry:Update(Index: number, Data: {Message: string, Type: Enum.MessageType}?): ()
    if Data then
        self.TextLabel.Text = Data.Message
        if Data.Type then
            self.TextLabel.TextColor3 = ENUMS_TO_COLORS[Data.Type]
            self.TextLabel.Font = Enum.Font.SourceSans
        else
            self.TextLabel.TextColor3 = Enum.StudioStyleGuideColor.MainText
            self.TextLabel.Font = Enum.Font.SourceSansItalic
        end
    else
        self.TextLabel.Text = ""
    end
end



return (OutputTextEntry :: any) :: OutputTextEntry