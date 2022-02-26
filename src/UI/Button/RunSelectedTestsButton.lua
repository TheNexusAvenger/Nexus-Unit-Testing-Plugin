--[[
TheNexusAvenger

Button for re-running selected tests.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local NexusPluginComponents = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents")

local RunSelecteedTestsButton = NexusUnitTestingPluginProject:GetResource("NexusPluginComponents.Base.PluginInstance"):Extend()
RunSelecteedTestsButton:SetClassName("RunSelectedTestsButton")

local BUTTON_ICONS = "http://www.roblox.com/asset/?id=4734758315"



--[[
Creates a Run Selected Tests Button object.
--]]
function RunSelecteedTestsButton:__new()
    self:InitializeSuper("ImageButton")

    --Create the selected tests icon.
    local Icon = NexusPluginComponents.new("ImageLabel")
    Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = BUTTON_ICONS
    Icon.ImageRectSize = Vector2.new(512, 512)
    Icon.ImageRectOffset = Vector2.new(0, 512)
    Icon.ImageColor3 = Color3.new(0, 170/255, 255/255)
    Icon.Parent = self

    --Set the defaults.
    self.Image = BUTTON_ICONS
    self.ImageRectSize = Vector2.new(512, 512)
    self.BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground
    self.ImageColor3 = Color3.new(0, 170/255, 0)
    self.BorderSizePixel = 0
end



return RunSelecteedTestsButton