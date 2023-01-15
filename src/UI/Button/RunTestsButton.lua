--[[
TheNexusAvenger

Button for running tests.
--]]
--!strict

local BUTTON_ICONS = "https://www.roblox.com/asset/?id=4734758315"

local NexusUnitTestingPlugin = script.Parent.Parent.Parent
local PluginInstance = require(NexusUnitTestingPlugin:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginInstance"))

local RunTestsButton = PluginInstance:Extend()
RunTestsButton:SetClassName("RunTestsButton")

export type RunTestsButton = {
    new: () -> (RunTestsButton),
    Extend: (self: RunTestsButton) -> (RunTestsButton),
} & PluginInstance.PluginInstance & ImageButton


--[[
Creates a Run Tests Button object.
--]]
function RunTestsButton:__new(): ()
    PluginInstance.__new(self, "ImageButton")

    --Set the defaults.
    self.Image = BUTTON_ICONS
    self.ImageRectSize = Vector2.new(512, 512)
    self.BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground
    self.ImageColor3 = Color3.fromRGB(0, 170, 0)
    self.BorderSizePixel = 0
end



return (RunTestsButton :: any) :: RunTestsButton