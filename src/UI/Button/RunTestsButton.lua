--[[
TheNexusAvenger

Button for running tests.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)

local RunTestsButton = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Base.NexusWrappedInstance"):Extend()
RunTestsButton:SetClassName("RunTestsButton")

local BUTTON_ICONS = "http://www.roblox.com/asset/?id=4734758315"



--[[
Creates a Run Tests Button object.
--]]
function RunTestsButton:__new(Test)
	self:InitializeSuper("ImageButton")
	
	--Set the defaults.
	self.Image = BUTTON_ICONS
	self.ImageRectSize = Vector2.new(512,512)
	self.BackgroundColor3 = "MainBackground"
	self.ImageColor3 = Color3.new(0,170/255,0)
	self.BorderSizePixel = 0
end



return RunTestsButton