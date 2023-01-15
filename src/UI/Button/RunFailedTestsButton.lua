--[[
TheNexusAvenger

Button for re-running failed tests.
--]]
--!strict

local BUTTON_ICONS = "https://www.roblox.com/asset/?id=4734758315"

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local NexusPluginComponents = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"))
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local RunFailedTestsButton = PluginInstance:Extend()
RunFailedTestsButton:SetClassName("RunFailedTestsButton")

export type RunFailedTestsButton = {
    new: () -> (RunFailedTestsButton),
    Extend: (self: RunFailedTestsButton) -> (RunFailedTestsButton),
} & PluginInstance.PluginInstance & ImageButton



--[[
Creates a Run Failed Tests Button object.
--]]
function RunFailedTestsButton:__new(): ()
    PluginInstance.__new(self, "ImageButton")

    --Create the failed tests icon.
    local Icon = NexusPluginComponents.new("ImageLabel")
    Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = BUTTON_ICONS
    Icon.ImageRectSize = Vector2.new(512, 512)
    Icon.ImageRectOffset = Vector2.new(512, 0)
    Icon.ImageColor3 = Color3.fromRGB(200, 0, 0)
    Icon.Parent = self

    --Set the defaults.
    self.Image = BUTTON_ICONS
    self.ImageRectSize = Vector2.new(512, 512)
    self.BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground
    self.ImageColor3 = Color3.fromRGB(0, 170, 0)
    self.BorderSizePixel = 0
end



return (RunFailedTestsButton :: any) :: RunFailedTestsButton