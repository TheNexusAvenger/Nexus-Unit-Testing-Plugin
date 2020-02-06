--[[
TheNexusAvenger

Displays a list of tests.
--]]

local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")

local TestScrollingListFrame = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.UI.Scroll.NexusScrollingFrame"):Extend()
TestScrollingListFrame:SetClassName("TestScrollingListFrame")



--[[
Creates a Test List Frame object.
--]]
function TestScrollingListFrame:__new()
	self:InitializeSuper("Qt5")
	self.CanvasSize = UDim2.new(0,0,0,0)
	
	--Create a list constraint.
	local UIListLayout = NexusPluginFramework.new("UIListLayout")
	UIListLayout.Hidden = true
	UIListLayout.SortOrder = Enum.SortOrder.Name
	UIListLayout.Parent = self
	
	--Add the selection constraint.
	local SelectionConstraint = NexusPluginFramework.new("ListSelectionConstraint")
	self.ChildAdded:Connect(function(Child)
		if Child:IsA("TestListFrame") then
			--Add the list frame.
			SelectionConstraint:AddListFrame(Child)
			
			--Sort the frames.
			SelectionConstraint:SortListFrames(function(ListFrameA,ListFrameB)
				return ListFrameA.Test.Name < ListFrameB.Test.Name
			end)
		end
	end)
	self.ChildRemoved:Connect(function(Child)
		if Child:IsA("TestListFrame") then
			SelectionConstraint:RemoveListFrame(Child)
		end
	end)
	
	--Set up updating the canvas size.
	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
	end)
end



return TestScrollingListFrame