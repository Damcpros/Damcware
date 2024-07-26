-- Define Services
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Define Global Variables
local lplr = PlayerService.LocalPlayer
local PlayerGui = lplr.PlayerGui
local DamcWare = Instance.new("ScreenGui",PlayerGui)
local connections = {}

-- Create Gui Library
local GuiLibrary = {}

local themes = {
	["Green"] = {
		Color1 = Color3.fromRGB(229, 255, 0),
		Color2 = Color3.fromRGB(34, 255, 0),
	},
	["Blue"] = {
		Color1 = Color3.fromRGB(48, 131, 255),
		Color2 = Color3.fromRGB(35, 98, 186),
	},
	["CottonCandy"] = {
		Color1 = Color3.fromRGB(106, 190, 255),
		Color2 = Color3.fromRGB(204, 152, 255),
	},
}

GuiLibrary.Theme = themes.Green

GuiLibrary.RegisteredWindows = {}
GuiLibrary.RegisteredModules = {}

function GuiLibrary:DarkenColor(color : Color3,int)
	local R = color.R / int
	local G = color.G / int
	local B = color.B / int
	
	return Color3.new(R,G,B)
end

function GuiLibrary:BrightenColor(color : Color3,int)
	local R = color.R * int
	local G = color.G * int
	local B = color.B * int

	return Color3.new(R,G,B)
end

local WindowCount = 0

function GuiLibrary:CreateWindow(name)
	local Window = Instance.new("Frame",DamcWare)
	Window.Position = UDim2.fromScale(0.025 + (0.12 * WindowCount),0.12)
	Window.Size = UDim2.fromScale(0.1,0.05)
	
	local WindowText = Instance.new("TextLabel",DamcWare)
	WindowText.Position = UDim2.fromScale(0.025 + (0.12 * WindowCount),0.12)
	WindowText.Size = UDim2.fromScale(0.1,0.05)
	WindowText.Text = name
	WindowText.TextSize = 12
	WindowText.TextColor3 = Color3.fromRGB(255,255,255)
	WindowText.BackgroundTransparency = 1
	
	table.insert(connections,RunService.Heartbeat:Connect(function(delta)
		WindowText.Visible = Window.Visible
	end))
	
	local ModuleFrame = Instance.new("Frame",Window)
	ModuleFrame.Size = UDim2.fromScale(1,15)
	ModuleFrame.BackgroundTransparency = 1
	ModuleFrame.Position = UDim2.fromScale(0,0.9)
	
	local WindowUiCorner = Instance.new("UICorner",Window)
	local WindowGradientColor = Instance.new("UIGradient",Window)
	WindowGradientColor.Color = ColorSequence.new(GuiLibrary.Theme.Color1,GuiLibrary.Theme.Color2)
	
	local ModuleFrameSort = Instance.new("UIListLayout",ModuleFrame)
	ModuleFrameSort.SortOrder = Enum.SortOrder.LayoutOrder
	
	GuiLibrary.RegisteredWindows[name] = {
		MainInstance = Window,
		ColorData = WindowGradientColor,
		CreateButton = function(tab)
			local ButtonInstance = Instance.new("TextButton",ModuleFrame)
			ButtonInstance.Size = UDim2.fromScale(1,0.06)
			ButtonInstance.Text = tab.Name
			ButtonInstance.TextSize = 12
			ButtonInstance.TextColor3 = Color3.fromRGB(255,255,255)
			ButtonInstance.BackgroundColor3 = Color3.fromRGB(40,40,40)
			ButtonInstance.BorderSizePixel = 0
			ButtonInstance.LayoutOrder = #ModuleFrame:GetChildren() + 1
			ButtonInstance.AutoButtonColor = false
			
			local dropdownFrame = Instance.new("ScrollingFrame",ModuleFrame)
			dropdownFrame.Size = UDim2.fromScale(1,0)
			dropdownFrame.Visible = false
			dropdownFrame.BorderSizePixel = 0
			dropdownFrame.ScrollBarThickness = 0.1
			dropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
			dropdownFrame.LayoutOrder = ButtonInstance.LayoutOrder + 1
			
			local dropdownFrameSort = Instance.new("UIListLayout",dropdownFrame)
			dropdownFrameSort.SortOrder = Enum.SortOrder.LayoutOrder
			
			local returnTable = {
				Enabled = false,
			}
			
			returnTable.ToggleButton = function(Enabled)
				if Enabled then returnTable.Enabled = Enabled else returnTable.Enabled = not returnTable.Enabled end
				task.spawn(tab.Function,returnTable.Enabled)
				ButtonInstance.BackgroundColor3 = returnTable.Enabled and GuiLibrary:DarkenColor(GuiLibrary.Theme.Color2,1.5) or Color3.fromRGB(40,40,40)
			end
			
			returnTable.RegisterToggle = function(Table)
				local ToggleInstance = Instance.new("TextLabel", dropdownFrame)
				ToggleInstance.Position = UDim2.fromScale(0,0)
				ToggleInstance.Size = UDim2.fromScale(1, 0.028)
				ToggleInstance.BackgroundTransparency = 1
				ToggleInstance.TextColor3 = Color3.fromRGB(255,255,255)
				ToggleInstance.TextSize = 11
				ToggleInstance.Text = "  " .. Table.Name
				ToggleInstance.TextXAlignment = Enum.TextXAlignment.Left
				
				local ToggleBoxInstance = Instance.new("TextButton", ToggleInstance)
				ToggleBoxInstance.Text = " ✔️"
				ToggleBoxInstance.Position = UDim2.fromScale(0.8, 0.15)
				ToggleBoxInstance.Size = UDim2.fromScale(0.15, 0.7)
				ToggleBoxInstance.Transparency = 0
				ToggleBoxInstance.BorderSizePixel = 0
				ToggleBoxInstance.AutoButtonColor = false
				ToggleBoxInstance.BackgroundColor3 = Color3.fromRGB(45,45,45)
				ToggleBoxInstance.TextColor3 = Color3.fromRGB(45,45,45)
				
				local toggleReturnTable = {}
				toggleReturnTable.Enabled = false
				toggleReturnTable.ToggleButton = function(Enabled)
					if Enabled then toggleReturnTable.Enabled = Enabled else toggleReturnTable.Enabled = not toggleReturnTable.Enabled end
					if Table.Function then Table.Function(toggleReturnTable.Enabled) end
					ToggleBoxInstance.BackgroundColor3 = toggleReturnTable.Enabled and GuiLibrary:DarkenColor(GuiLibrary.Theme.Color2,1.5) or Color3.fromRGB(45,45,45)
				end
				
				table.insert(connections,ToggleBoxInstance.MouseButton1Down:Connect(function()
					toggleReturnTable.ToggleButton()
				end))
			end
			
			returnTable.RegisterDropdown = function(Table)
				local ToggleInstance = Instance.new("TextButton", dropdownFrame)
				ToggleInstance.Position = UDim2.fromScale(0,0)
				ToggleInstance.Size = UDim2.fromScale(1, 0.028)
				ToggleInstance.BackgroundTransparency = 1
				ToggleInstance.TextColor3 = Color3.fromRGB(255,255,255)
				ToggleInstance.TextSize = 11
				ToggleInstance.Text = "  "..Table.Name..": "..Table.Options[1]
				ToggleInstance.TextXAlignment = Enum.TextXAlignment.Left

				local toggleReturnTable = {}
				toggleReturnTable.Option = Table.Options[1]
				
				local Index = 1
				toggleReturnTable.ToggleButton = function(Enabled)
					Index += 1
					
					if Index > #Table.Options then
						Index = 1
					end
					
					ToggleInstance.Text = "  "..Table.Name..": "..Table.Options[Index]
					toggleReturnTable.Option = Table.Options[Index]
				end
				
				table.insert(connections,ToggleInstance.MouseButton1Down:Connect(function()
					toggleReturnTable.ToggleButton()
				end))

				return toggleReturnTable
			end
			
			table.insert(connections,ButtonInstance.MouseButton1Down:Connect(function()
				returnTable.ToggleButton()
			end))
			
			table.insert(connections,ButtonInstance.MouseButton2Down:Connect(function()
				
				local isOpen = dropdownFrame.Visible
				
				if isOpen then
					TweenService:Create(
						dropdownFrame,
						TweenInfo.new(0.75),
						{
							Size = UDim2.fromScale(1,0)
						}
					):Play()
					
					task.delay(0.75,function()
						dropdownFrame.Visible = not dropdownFrame.Visible
					end)
				else
					dropdownFrame.Visible = not dropdownFrame.Visible
					TweenService:Create(
						dropdownFrame,
						TweenInfo.new(0.75),
						{
							Size = UDim2.fromScale(1,0.25)
						}
					):Play()
				end
				
				
			end))
			
			GuiLibrary.RegisteredModules[tab.Name] = {
				MainInstance = ButtonInstance,
			}
			
			return returnTable
		end,
	}
	WindowCount += 1
end

function GuiLibrary:GetWindow(name)
	return GuiLibrary.RegisteredWindows[name] or Instance.new("Frame")
end

function GuiLibrary:GetWindows()
	return GuiLibrary.RegisteredWindows
end

function GuiLibrary:GetButtonInstances()
	return GuiLibrary.RegisteredModules
end

function GuiLibrary:CleanUp()
	for i,v in pairs(connections) do
		v:Disconnect()
	end
	for i,v in pairs(GuiLibrary) do
		if type(v) == "table" then
			table.clear(v)
		end
	end
	
	table.clear(GuiLibrary)
	
	DamcWare:Destroy()
end

table.insert(connections,UserInputService.InputBegan:Connect(function(key, gpe)
	if gpe then return end
	if key.KeyCode == Enum.KeyCode.RightShift then
		for i,v in pairs(GuiLibrary:GetWindows()) do
			v.MainInstance.Visible = not v.MainInstance.Visible
		end
	end
end))

table.insert(connections,RunService.Heartbeat:Connect(function(delta)
	for i,v in pairs(GuiLibrary:GetWindows()) do
		v.ColorData.Color = ColorSequence.new(GuiLibrary.Theme.Color1,GuiLibrary.Theme.Color2)
	end
	for i,v in pairs(GuiLibrary:GetButtonInstances()) do
		--v.MainInstance.BackgroundColor3 = GuiLibrary.Theme.Color2
	end
end))

return GuiLibrary
