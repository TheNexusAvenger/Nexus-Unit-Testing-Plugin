--[[
TheNexusAvenger

Tests the ButtonSideBar class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local ButtonSideBar = NexusUnitTestingPlugin:GetResource("UI.Bar.ButtonSideBar")

local ButtonSideBarUnitTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function ButtonSideBarUnitTest:Setup()
	self.CuT = ButtonSideBar.new()
end

--[[
Tears down the test.
--]]
function ButtonSideBarUnitTest:Teardown()
	self.CuT:Destroy()
end

--[[
Tests the constructor.
--]]
NexusUnitTesting:RegisterUnitTest(ButtonSideBarUnitTest.new("Constructor"):SetRun(function(self)
	--Assert the component under testing. is set up correctly.
	self:AssertEquals(#self.CuT:GetChildren(),0,"Child buttons are exposed.")
	self:AssertEquals(#self.CuT:GetWrappedInstance():GetChildren(),3,"Child buttons are incorrect.")
end))



return true