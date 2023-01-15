--[[
TheNexusAvenger

Entry for the output.
--]]

local TEXT_MARGIN_PIXELS = 3
local ENUMS_TO_COLORS = {
    [Enum.MessageType.MessageOutput] = Enum.StudioStyleGuideColor.MainText,
    [Enum.MessageType.MessageWarning] = Enum.StudioStyleGuideColor.WarningText,
    [Enum.MessageType.MessageError] = Enum.StudioStyleGuideColor.ErrorText,
    [Enum.MessageType.MessageInfo] = Enum.StudioStyleGuideColor.InfoText,
}



local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local PluginInstance = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Base.PluginInstance")

local OutputView = PluginInstance:Extend()
OutputView:SetClassName("OutputView")



--[[
Creates the text entry.
--]]
function OutputView:__new()
    PluginInstance.__new(self, "Frame")

    --Create the text.
    local TextLabel = PluginInstance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -(2 * TEXT_MARGIN_PIXELS), 1, 0)
    TextLabel.Position = UDim2.new(0, TEXT_MARGIN_PIXELS, 0, 0)
    TextLabel.Parent = self
    self:DisableChangeReplication("TextLabel")
    self.TextLabel = TextLabel
end

--[[
Updates the text.
--]]
function OutputView:Update(Data)
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



return OutputView