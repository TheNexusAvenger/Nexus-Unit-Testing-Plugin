--[[
TheNexusAvenger

Frame containing the buttons.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local TestStateIcon = NexusUnitTestingPluginProject:GetResource("UI.TestStateIcon")
local RunTestsButton = NexusUnitTestingPluginProject:GetResource("UI.Button.RunTestsButton")
local RunFailedTestsButton = NexusUnitTestingPluginProject:GetResource("UI.Button.RunFailedTestsButton")
local RunSelectedTestsButton = NexusUnitTestingPluginProject:GetResource("UI.Button.RunSelectedTestsButton")
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")
local NexusUnitTesting = NexusUnitTestingPluginProject:GetResource("NexusUnitTestingModule")

local ButtonSideBar = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Base.NexusWrappedInstance"):Extend()
ButtonSideBar:SetClassName("ButtonSideBar")



--[[
Creates a Button Side Bar object.
--]]
function ButtonSideBar:__new()
	self:InitializeSuper("Frame")
	
	--Create the buttons.
	local RunTests = RunTestsButton.new()
	RunTests.Hidden = true
	RunTests.Size = UDim2.new(0,14,0,14)
	RunTests.Position = UDim2.new(0,7,0,7)
	RunTests.Parent = self
	self:__SetChangedOverride("RunTestsButton",function() end)
	self.RunTestsButton = RunTests
	
	local RunFailedTests = RunFailedTestsButton.new()
	RunFailedTests.Hidden = true
	RunFailedTests.Size = UDim2.new(0,14,0,14)
	RunFailedTests.Position = UDim2.new(0,7,0,32)
	RunFailedTests.Parent = self
	self:__SetChangedOverride("RunFailedTestsButton",function() end)
	self.RunFailedTestsButton = RunFailedTests
	
	local RunSelectedTests = RunSelectedTestsButton.new()
	RunSelectedTests.Hidden = true
	RunSelectedTests.Size = UDim2.new(0,14,0,14)
	RunSelectedTests.Position = UDim2.new(0,7,0,57)
	RunSelectedTests.Parent = self
	self:__SetChangedOverride("RunSelectedTestsButton",function() end)
	self.RunSelectedTestsButton = RunSelectedTests
	
	--Set the defaults.
	self.BorderSizePixel = 1
	self.Size = UDim2.new(0,28,1,0)
end



return ButtonSideBar