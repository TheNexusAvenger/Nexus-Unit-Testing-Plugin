--[[
TheNexusAvenger

Tests the ButtonSideBar class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusUnitTestingPlugin = require(game:GetService("ReplicatedStorage"):WaitForChild("NexusUnitTestingPlugin"))
local ButtonSideBar = NexusUnitTestingPlugin:GetResource("UI.Bar.ButtonSideBar")



--[[
Tests the constructor.
--]]
NexusUnitTesting:RegisterUnitTest("Constructor",function(UnitTest)
	--Create the component under testing and assert it is set up correctly.
	local CuT = ButtonSideBar.new()
	UnitTest:AssertEquals(#CuT:GetChildren(),0,"Child buttons are exposed.")
	UnitTest:AssertEquals(#CuT:GetWrappedInstance():GetChildren(),2,"Child buttons are incorrect.")
end)



return true