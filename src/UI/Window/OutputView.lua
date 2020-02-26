--[[
TheNexusAvenger

Frame for viewing the output of a test.
--]]

local TEXT_MARGIN_PIXELS = 3
local LINE_HEIGHT_PIXELS = 17
local ENUMS_TO_COLORS = {
	[Enum.MessageType.MessageOutput] = "MainText",
	[Enum.MessageType.MessageWarning] = "WarningText",
	[Enum.MessageType.MessageError] = "ErrorText",
	[Enum.MessageType.MessageInfo] = "InfoText",
}



local NexusUnitTestingPluginProject = require(script.Parent.Parent.Parent)
local NexusPluginFramework = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework")

local TextService = game:GetService("TextService")

local OutputView = NexusUnitTestingPluginProject:GetResource("NexusPluginFramework.Base.NexusWrappedInstance"):Extend()
OutputView:SetClassName("OutputView")



--[[
Creates a Output View frame object.
--]]
function OutputView:__new()
	self:InitializeSuper("Frame")
	
	--Store the labels.
	self:__SetChangedOverride("OutputLabels",function() end)
	self.OutputLabels = {}
	
	--Store the output data.
	self:__SetChangedOverride("OutputLines",function() end)
	self.OutputLines = {}
	self:__SetChangedOverride("MaxLineWidth",function() end)
	self.MaxLineWidth = 0
	self:__SetChangedOverride("TestEvents",function() end)
	self.TestEvents = {}
	
	--Create the top bar.
	local TopBar = NexusPluginFramework.new("Frame")
	TopBar.Hidden = true
	TopBar.BorderSizePixel = 1
	TopBar.Size = UDim2.new(1,0,0,21)
	TopBar.Parent = self
	
	local TopBarLabel = NexusPluginFramework.new("TextLabel")
	TopBarLabel.Size = UDim2.new(1,-4,0,16)
	TopBarLabel.Position = UDim2.new(0,2,0,2)
	TopBarLabel.Text = ""
	TopBarLabel.Font = "SourceSansBold"
	TopBarLabel.Parent = TopBar
	self:__SetChangedOverride("TopBarLabel",function() end)
	self.TopBarLabel = TopBarLabel
	
	local TopBarFullNameLabel = NexusPluginFramework.new("TextLabel")
	TopBarFullNameLabel.Size = UDim2.new(1,-4,0,16)
	TopBarFullNameLabel.Position = UDim2.new(0,2,0,2)
	TopBarFullNameLabel.Text = ""
	TopBarFullNameLabel.Font = "SourceSansItalic"
	TopBarFullNameLabel.Parent = TopBar
	self:__SetChangedOverride("TopBarFullNameLabel",function() end)
	self.TopBarFullNameLabel = TopBarFullNameLabel
			
	--Create the scrolling frame.
	local ScrollingFrame = NexusPluginFramework.new("ScrollingFrame","Qt5")
	ScrollingFrame.Hidden = true
	ScrollingFrame.Size = UDim2.new(1,0,1,-22)
	ScrollingFrame.Position = UDim2.new(0,0,0,22)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.Parent = self
	self:__SetChangedOverride("ScrollingFrame",function() end)
	self.ScrollingFrame = ScrollingFrame
	
	--Create the output view.
	local OutputClips = NexusPluginFramework.new("Frame")
	OutputClips.Hidden = true
	OutputClips.Size = UDim2.new(1,-17,1,-22)
	OutputClips.Position = UDim2.new(0,0,0,22)
	OutputClips.ClipsDescendants = true
	OutputClips.Parent = self
	self:__SetChangedOverride("OutputClips",function() end)
	self.OutputClips = OutputClips
	
	local OutputContainer = NexusPluginFramework.new("Frame")
	OutputContainer.Size = UDim2.new(1,1,1,0)
	OutputContainer.Parent = OutputClips
	self:__SetChangedOverride("OutputContainer",function() end)
	self.OutputContainer = OutputContainer
	
	--Connect the events.
	ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:UpdateTotalLabels()
		self:UpdateContainerPoisiton()
		self:UpdateDisplayedOutput()
	end)
	ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		self:UpdateContainerPoisiton()
		self:UpdateDisplayedOutput()
	end)
	
	--Set the defaults.
	self.Size = UDim2.new(1,0,1,0)
	self:UpdateTotalLabels()
end

--[[
Returns if the scroll bar is at the bottom.
Returns false if the scroll bar doesn't exist.
--]]
function OutputView:IsScrollBarAtBottom()
	return self.ScrollingFrame.CanvasPosition.Y ~= 0 and self.ScrollingFrame.CanvasPosition.Y + self.ScrollingFrame.AbsoluteWindowSize.Y == #self.OutputLines * LINE_HEIGHT_PIXELS
end

--[[
Adds and removes text labels depending on the
size of the frame.
--]]
function OutputView:UpdateTotalLabels()
	--Determine how many labels are needed.
	local RequiredLabels = math.ceil(self.ScrollingFrame.AbsoluteSize.Y/LINE_HEIGHT_PIXELS)
	
	--Add extra labels.
	for i = 1,RequiredLabels do
		if not self.OutputLabels[i] then
			local NewLabel = NexusPluginFramework.new("TextLabel")
			NewLabel.Size = UDim2.new(1,0,0,LINE_HEIGHT_PIXELS)
			NewLabel.Position = UDim2.new(0,TEXT_MARGIN_PIXELS,0,17 * (i - 1))
			NewLabel.Text = ""
			NewLabel.Parent = self.OutputContainer
			self.OutputLabels[i] = NewLabel
		end
	end
	
	--Remove unneded labels.
	for i = RequiredLabels + 1,#self.OutputLabels do
		if self.OutputLabels[i] then
			self.OutputLabels[i]:Destroy()
			self.OutputLabels[i] = nil
		end
	end
end

--[[
Updates the size and position of the
scrolling frame.
--]]
function OutputView:UpdateScrollBarSizes()
	--Update the canvas size.
	local IsAtBottom = self:IsScrollBarAtBottom()
	self.ScrollingFrame.CanvasSize = UDim2.new(0,self.MaxLineWidth,0,#self.OutputLines * LINE_HEIGHT_PIXELS)
	
	--Determine the X offset.
	local SizeXOffset = 0
	if #self.OutputLines * LINE_HEIGHT_PIXELS > self.OutputClips.AbsoluteSize.Y then
		SizeXOffset = -17
	end
	
	--Update the clips size if a bottom scroll bar exists.
	if self.MaxLineWidth > self.OutputClips.AbsoluteSize.X then
		self.OutputClips.Size = UDim2.new(1,SizeXOffset,1,-(17 + 22))
		if IsAtBottom then
			self.ScrollingFrame.CanvasPosition = Vector2.new(self.ScrollingFrame.CanvasPosition.X,(#self.OutputLines * LINE_HEIGHT_PIXELS) - self.OutputClips.AbsoluteSize.Y + 16)
		end
	else
		self.OutputClips.Size = UDim2.new(1,SizeXOffset,1,-22)
		if IsAtBottom then
			self.ScrollingFrame.CanvasPosition = Vector2.new(self.ScrollingFrame.CanvasPosition.X,(#self.OutputLines * LINE_HEIGHT_PIXELS) - self.OutputClips.AbsoluteSize.Y)
		end
	end
end

--[[
Updates the position of the output
container.
--]]
function OutputView:UpdateContainerPoisiton()
	if self:IsScrollBarAtBottom() then
		self.OutputContainer.Position = UDim2.new(0,-self.ScrollingFrame.CanvasPosition.X,0,-((math.ceil(self.ScrollingFrame.AbsoluteWindowSize.Y/LINE_HEIGHT_PIXELS) * LINE_HEIGHT_PIXELS) - self.ScrollingFrame.AbsoluteWindowSize.Y))
	else
		self.OutputContainer.Position = UDim2.new(0,-self.ScrollingFrame.CanvasPosition.X,0,0)
	end
end

--[[
Updates the displayed output.
--]]
function OutputView:UpdateDisplayedOutput()
	local StartIndex = math.max(0,math.floor(self.ScrollingFrame.CanvasPosition.Y/LINE_HEIGHT_PIXELS))
	
	--Set the text to the output or unset the text.
	for i = 1,math.ceil(self.ScrollingFrame.AbsoluteWindowSize.Y/LINE_HEIGHT_PIXELS) do
		local EntryId = StartIndex + i
		local OutputData = self.OutputLines[EntryId]
		local OutputLabel = self.OutputLabels[i]
		if OutputLabel then
			if OutputData then
				OutputLabel.Text = OutputData[1]
				OutputLabel.TextColor3 = ENUMS_TO_COLORS[OutputData[2]]
			else
				OutputLabel.Text = ""
			end
		end
	end
end

--[[
Processes a new output entry.
--]]
function OutputView:ProcessOutput(String,Type)
	--If the string has multiple lines, split the string and add them.
	if string.find(String,"\n") then
		for _,SubString in pairs(string.split(String,"\n")) do
			self:AddOutput(SubString,Type)
		end
		return
	end
	
	--Add the string.
	table.insert(self.OutputLines,{String,Type})
	
	--Update the max size.
	local StringWidth = TextService:GetTextSize(String,14,"SourceSans",Vector2.new(2000,LINE_HEIGHT_PIXELS)).X + (TEXT_MARGIN_PIXELS * 2)
	if StringWidth > self.MaxLineWidth then
		self.MaxLineWidth = StringWidth
	end
end

--[[
Adds a line to display in the output.
--]]
function OutputView:AddOutput(String,Type)
	--Process the output.
	self:ProcessOutput(String,Type)
	
	--Update the output view.
	self:UpdateScrollBarSizes()
	self:UpdateContainerPoisiton()
	self:UpdateDisplayedOutput()
end

--[[
Sets the test to use for the output.
--]]
function OutputView:SetTest(Test)
	--Set the top bar name.
	self.TopBarLabel.Text = Test.Name
	if Test.FullName then
		self.TopBarFullNameLabel.Text = "("..Test.FullName..")"
		self.TopBarFullNameLabel.Position = UDim2.new(0,TextService:GetTextSize(Test.Name,14,"SourceSansBold",Vector2.new(2000,16)).X + 4,0,2)
	else
		self.TopBarFullNameLabel.Text = ""
	end
	
	--Clear the output.
	self.OutputLines = {}
	self.MaxLineWidth = 0
	
	--Disconnect the existing events.
	for _,Event in pairs(self.TestEvents) do
		Event:Disconnect()
	end
	self.TestEvents = {}
	
	--Add the existing output.
	for _,Output in pairs(Test.Output) do
		self:ProcessOutput(Output[1],Output[2])
	end
	
	--Update the displayed output if it wasn't done so already.
	self:UpdateTotalLabels()
	self:UpdateScrollBarSizes()
	self:UpdateContainerPoisiton()
	self:UpdateDisplayedOutput()
	if self.MaxLineWidth > self.OutputClips.AbsoluteSize.X then
		self.ScrollingFrame.CanvasPosition = Vector2.new(self.ScrollingFrame.CanvasPosition.X,(#self.OutputLines * LINE_HEIGHT_PIXELS) - self.OutputClips.AbsoluteSize.Y + 16)
	else
		self.ScrollingFrame.CanvasPosition = Vector2.new(self.ScrollingFrame.CanvasPosition.X,(#self.OutputLines * LINE_HEIGHT_PIXELS) - self.OutputClips.AbsoluteSize.Y)
	end
	
	--Connect the events.
	table.insert(self.TestEvents,Test.MessageOutputted:Connect(function(Message,Type)
		self:AddOutput(Message,Type)
	end))
end



return OutputView