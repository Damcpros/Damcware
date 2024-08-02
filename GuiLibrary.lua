--[[
	Damcware development by Damc
	All code written by Damc
--]]

local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local getExecEnv = function()
	return getgenv and getgenv() or {
		writefile = function() end,
		readfile = function() end,
		loadfile = function() end,
		makefolder = function() end,
		isfile = function() end,
	}
end

local env = getExecEnv()

local isfile = env.isfile
local writefile = env.writefile
local readfile = env.readfile
local delfile = env.delfile
local makefolder = env.makefolder

local config = {
	["Buttons"] = {},
	["Sliders"] = {},
	["Toggles"] = {},
	["Keybinds"] = {},
	["Pickers"] = {}
}

lplr = PlayerService.LocalPlayer

if not isfile("DamcWare") then
	makefolder("DamcWare")
	makefolder("DamcWare/Configs")
end

local saveConfig = function()
	if isfile("DamcWare/Configs/"..game.PlaceId..".json") then
		delfile("DamcWare/Configs/"..game.PlaceId..".json")
	end
	writefile("DamcWare/Configs/"..game.PlaceId..".json",HttpService:JSONEncode(config))
end
local loadConfig = function()
	if isfile("DamcWare/Configs/"..game.PlaceId..".json") then
		config = HttpService:JSONDecode(readfile("DamcWare/Configs/"..game.PlaceId..".json"))
	end
end

loadConfig()
task.wait(0.5)

local parentToCoreGui = function(v)
	local suc, val = pcall(function()
		v.Parent = CoreGui
	end)

	if not suc then
		v.Parent = lplr.PlayerGui
	end
end

local getRemote = function(remote)
	if type(remote) ~= "string" then return end
	for i,v in pairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower() == remote:lower() then
			return v
		end
	end

	return Instance.new("RemoteEvent")
end

local darkenColor = function(color,value)
	local R = color.R * value
	local G = color.G * value
	local B = color.B * value

	return Color3.new(R,G,B)
end

local getSize = function(text,font,fontsize)
	return TextService:GetTextSize(text,fontsize,font,Vector2.new(0,0))
end

local DamcwareVersion = "1.0.0"
local DamcwareReleaseType = env.DamcwarePrivate and "Private" or "Release"

env.DamcWareLoaded = tick()

local Connections = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

parentToCoreGui(ScreenGui)

local GuiLibrary = {
	Windows = {},
	Functions = {},
	Settings = {
		Scale = 1,
		ClickGui = {
			Top = {
				BackgroundColor = Color3.fromRGB(30, 30, 30),
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Center,
				Prefix = "",
			},
			Buttons = {
				BackgroundColor = Color3.fromRGB(30, 30, 30),
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				Prefix = "  ",
			}
		},
		MainColor = Color3.fromRGB(0, 159, 74)
	}
}

local Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 = GuiLibrary.Settings.MainColor
Watermark.TextStrokeTransparency = 0
Watermark.RichText = true
Watermark.Text = 'Damc-Ware'
Watermark.Size = UDim2.fromScale(0.1, 0.05)
Watermark.Position = UDim2.fromScale(0.85, 0.1)
Watermark.TextSize = 20
Watermark.BorderSizePixel = 0
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local Arraylist = Instance.new("Frame", ScreenGui)
Arraylist.Position = UDim2.fromScale(0.9, 0.15)
Arraylist.Size = UDim2.fromScale(0.1, 0.8)
Arraylist.BackgroundTransparency = 1

local arraySort = Instance.new("UIListLayout", Arraylist)
arraySort.SortOrder = Enum.SortOrder.LayoutOrder
--arraySort.Padding = UDim.new(0.01, 0)
arraySort.HorizontalAlignment = Enum.HorizontalAlignment.Right

local arrayItems = {}

function GuiLibrary:AddToArray(module)
	local size = getSize(module, Enum.Font.SourceSans, 13)
	local item = Instance.new("TextLabel", Arraylist)
	item.BackgroundTransparency = 1
	item.Size = UDim2.fromOffset(size.X * 2, size.Y * 2)
	item.Text = module
	item.TextColor3 = GuiLibrary.Settings.MainColor
	item.TextStrokeTransparency = 0
	item.Name = module:lower()
	item.TextSize = 13
	item.BorderSizePixel = 0
	item.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

	table.insert(arrayItems, item)
	table.sort(arrayItems, function(a, b)
		return getSize(a.Text, Enum.Font.SourceSans, 13).X > getSize(b.Text, Enum.Font.SourceSans, 13).X
	end)

	for i, v in ipairs(arrayItems) do
		v.LayoutOrder = i
	end
end

function GuiLibrary:RemoveFromArray(module)
	for i,v in pairs(arrayItems) do
		if v.Name == module:lower() then
			table.remove(arrayItems,i)
			v:Destroy()
		end
	end

	table.sort(arrayItems,function(a,b)
		return getSize(a.Text,Enum.Font.SourceSans,13).X > getSize(b.Text,Enum.Font.SourceSans,13).X
	end)

	for i,v in pairs(arrayItems) do
		v.LayoutOrder = i
	end
end

task.spawn(function()
	local sparkleSwitchTicks = 0
	local sparkle = false
	local totalTicks = 0

	local getColorWave = function(ticks, index)
		local frequency = ArraylistRainbowSpeed.Value / 1000
		local phaseShift = index * 0.3
		local red = math.sin(frequency * ticks + phaseShift) * 127 + 128
		local green = math.sin(frequency * ticks + phaseShift + 2) * 127 + 128
		local blue = math.sin(frequency * ticks + phaseShift + 4) * 127 + 128
		return Color3.fromRGB(math.floor(red), math.floor(green), math.floor(blue))
	end

	repeat
		if sparkleSwitchTicks > 60 then
			sparkle = true
			sparkleSwitchTicks = 0
		else
			sparkle = false
		end

		for i, v in pairs(arrayItems) do
			totalTicks += 1
			pcall(function()
				if ArraylistMode.Value == "Static" then
					v.TextColor3 = GuiLibrary.Settings.MainColor
				elseif ArraylistMode.Value == "Sparkle" and sparkle then
					if math.random(1, 10 - ArraylistSparkleRate.Value) == 1 then
						TweenService:Create(v, TweenInfo.new(1), {
							TextColor3 = darkenColor(GuiLibrary.Settings.MainColor, 0.6)
						}):Play()
					else
						TweenService:Create(v, TweenInfo.new(1), {
							TextColor3 = GuiLibrary.Settings.MainColor
						}):Play()
					end
				elseif ArraylistMode.Value == "Rainbow" then
					local waveColor = getColorWave(totalTicks, i)
					TweenService:Create(v, TweenInfo.new(0.1), {
						TextColor3 = waveColor
					}):Play()
				end
			end)
		end

		pcall(function()
			if WatermarkMode.Value == "Normal" then
				Watermark.TextColor3 = GuiLibrary.Settings.MainColor
			else
				Watermark.TextColor3 = getColorWave(totalTicks, 1)
			end
		end)


		sparkleSwitchTicks += 1
		task.wait()
	until false
end)

function GuiLibrary.Functions:Uninject()

	ScreenGui:Destroy()
	env.DamcWareLoaded = nil

	for i,v in pairs(Connections) do
		v:Disconnect()
	end

	for i,v in pairs(GuiLibrary) do
		if type(v) == "table" then
			table.clear(v)
		else
			GuiLibrary[i] = nil
		end
	end

	table.clear(GuiLibrary)
	table.clear(Connections)
end
local WindowCount = 0
function GuiLibrary.Functions:CreateWindow(name)
	local WindowTop = Instance.new("TextLabel",ScreenGui)
	WindowTop.Size = UDim2.fromScale(0.12 * GuiLibrary.Settings.Scale,0.04)
	WindowTop.Position = UDim2.fromScale((0.05 + (0.13 * WindowCount)) * GuiLibrary.Settings.Scale,0.15)
	WindowTop.BorderSizePixel = 0
	WindowTop.TextColor3 = Color3.fromRGB(255,255,255)
	WindowTop.BackgroundColor3 = GuiLibrary.Settings.ClickGui.Top.BackgroundColor
	WindowTop.TextSize = GuiLibrary.Settings.ClickGui.Top.TextSize
	WindowTop.Text = GuiLibrary.Settings.ClickGui.Top.Prefix..name
	WindowTop.TextXAlignment = GuiLibrary.Settings.ClickGui.Top.TextXAlignment

	UserInputService.InputBegan:Connect(function(key, gpe)
		if gpe then return end

		if key.KeyCode == Enum.KeyCode.RightShift then
			WindowTop.Visible = not WindowTop.Visible
		end
	end)

	local ModuleFrame = Instance.new("Frame",WindowTop)
	ModuleFrame.BackgroundTransparency = 1
	ModuleFrame.Size = UDim2.fromScale(1,15)
	ModuleFrame.Position = UDim2.fromScale(0,1)

	local listlayout = Instance.new("UIListLayout",ModuleFrame)
	listlayout.SortOrder = Enum.SortOrder.LayoutOrder

	GuiLibrary.Windows[name] = {
		CreateButtonWithOptions = function(tab)

			local optionsDarken = 1

			local button = Instance.new("TextButton",ModuleFrame)
			button.Size = UDim2.fromScale(1,0.067)
			button.BorderSizePixel = 0
			button.TextColor3 = Color3.fromRGB(255,255,255)
			button.BackgroundColor3 = GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor
			button.TextSize = 11
			button.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix..tab.Name
			button.TextXAlignment = GuiLibrary.Settings.ClickGui.Buttons.TextXAlignment
			button.LayoutOrder = #ModuleFrame:GetChildren() + 1

			local buttonData = config.Buttons[tab.Name] or {Enabled = false}

			local ButtonOptions
			ButtonOptions = {
				Enabled = false,
				ToggleButton = function(state)
					if state then
						GuiLibrary:AddToArray(tab.Name)
						ButtonOptions.Enabled = true
						button.BackgroundColor3 = GuiLibrary.Settings.MainColor
						tab.Function(true)

						task.spawn(function()
							repeat
								button.BackgroundColor3 = GuiLibrary.Settings.MainColor
								task.wait()
							until not ButtonOptions.Enabled
						end)
					else
						GuiLibrary:RemoveFromArray(tab.Name)
						ButtonOptions.Enabled = false
						button.BackgroundColor3 = GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor
						tab.Function(false)
					end

					buttonData.Enabled = ButtonOptions.Enabled
					config.Buttons[tab.Name] = buttonData
					task.delay(0.5,function()
						saveConfig()
					end)
				end,
			}

			if buttonData.Enabled then
				ButtonOptions.Enabled = true
				ButtonOptions.ToggleButton(true)
			end

			local settingsFrame = Instance.new("ScrollingFrame",ModuleFrame)
			settingsFrame.BackgroundColor3 = darkenColor(GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor,0.75)
			settingsFrame.BorderSizePixel = 0
			settingsFrame.Size = UDim2.fromScale(1,0.4)
			settingsFrame.Visible = false
			settingsFrame.ScrollBarThickness = 0.1
			settingsFrame.LayoutOrder = button.LayoutOrder + 1

			local Keybind = Enum.KeyCode.Unknown
			local KeybindButton = Instance.new("TextButton", settingsFrame)
			KeybindButton.Size = UDim2.fromScale(1, 0.03)
			KeybindButton.BorderSizePixel = 0
			KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindButton.BackgroundColor3 = darkenColor(GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor,0.75)
			KeybindButton.TextSize = 11
			KeybindButton.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. "Bind: NONE"
			KeybindButton.TextXAlignment = GuiLibrary.Settings.ClickGui.Buttons.TextXAlignment

			local keybindData = config.Keybinds[tab.Name] or {Keybind = "Unknown"}

			local listlayout2 = Instance.new("UIListLayout",settingsFrame)
			listlayout2.SortOrder = Enum.SortOrder.LayoutOrder

			function ButtonOptions:MakeToggle(tab2)

				local toggleData = config.Toggles[tab.Name.."_"..tab2.Name] or {Enabled = false}

				local Toggle = Instance.new("TextButton", settingsFrame)
				Toggle.Size = UDim2.fromScale(1, 0.03)
				Toggle.BorderSizePixel = 0
				Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundColor3 = darkenColor(GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor,0.75)
				Toggle.TextSize = 11
				Toggle.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. tab2.Name
				Toggle.TextXAlignment = GuiLibrary.Settings.ClickGui.Buttons.TextXAlignment

				local ToggleOptions
				ToggleOptions = {
					Enabled = false,
					ToggleButton = function(state)
						if state then
							ToggleOptions.Enabled = true
							Toggle.BackgroundColor3 = GuiLibrary.Settings.MainColor
							tab2.Function(true)
							task.spawn(function()
								repeat
									Toggle.BackgroundColor3 = GuiLibrary.Settings.MainColor
									task.wait()
								until not ToggleOptions.Enabled
							end)
						else
							ToggleOptions.Enabled = false
							Toggle.BackgroundColor3 = GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor
							tab2.Function(false)
						end

						toggleData.Enabled = ToggleOptions.Enabled
						config.Toggles[tab.Name.."_"..tab2.Name] = toggleData
						task.delay(0.5,function()
							saveConfig()
						end)
					end,
				}

				if toggleData.Enabled then
					ToggleOptions.ToggleButton(true)
					print("LOADED TOGGLE")
				end

				Toggle.MouseButton1Down:Connect(function()
					ToggleOptions.ToggleButton(not ToggleOptions.Enabled)
				end)

				return ToggleOptions
			end

			function ButtonOptions:MakePicker(tab2)

				local pickerData = config.Pickers[tab.Name.."_"..tab2.Name] or {Option = tab2.Options[1]}

				local Picker = Instance.new("TextButton", settingsFrame)
				Picker.Size = UDim2.fromScale(1, 0.03)
				Picker.BorderSizePixel = 0
				Picker.TextColor3 = Color3.fromRGB(255, 255, 255)
				Picker.BackgroundColor3 = darkenColor(GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor,0.75)
				Picker.TextSize = 11
				Picker.TextXAlignment = GuiLibrary.Settings.ClickGui.Buttons.TextXAlignment

				local options = tab2.Options
				local option = options[1] or ""

				local index = 2

				Picker.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. tab2.Name .. ": " .. option

				local PickerOptions
				PickerOptions = {
					Value = option,
					NextValue = function()
						if index > #options then
							index = 1
						end

						option = options[index] or ""
						PickerOptions.Value = option
						Picker.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. tab2.Name .. ": " .. option
						tab2.Function(option)

						pickerData.Option = PickerOptions.Value
						config.Pickers[tab.Name.."_"..tab2.Name] = pickerData
						task.delay(0.5,function()
							saveConfig()
						end)

						index += 1
					end,
					PrevValue = function()
						if index < 1 then
							index = #options
						end

						option = options[index] or ""
						PickerOptions.Value = option
						Picker.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. tab2.Name .. ": " .. option
						tab2.Function(option)

						pickerData.Option = PickerOptions.Value
						config.Pickers[tab.Name.."_"..tab2.Name] = pickerData
						task.delay(0.5,function()
							saveConfig()
						end)

						index -= 1
					end,
					NextValueNoSavey = function()
						if index > #options then
							index = 1
						end

						option = options[index] or ""
						PickerOptions.Value = option
						Picker.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. tab2.Name .. ": " .. option
						tab2.Function(option)

						index += 1
					end,
				}
				while PickerOptions.Value ~= pickerData.Option do
					PickerOptions.NextValueNoSavey()
				end	

				Picker.MouseButton1Down:Connect(function()
					PickerOptions.NextValue()
				end)

				Picker.MouseButton2Down:Connect(function()
					PickerOptions.PrevValue()
				end)

				return PickerOptions
			end

			function ButtonOptions:MakeSlider(tab2)

				local sliderData = config.Sliders[tab.Name.."_"..tab2.Name] or {Value = tab2.Default}

				local Slider = Instance.new("Frame", settingsFrame)
				Slider.Size = UDim2.fromScale(1, 0.03)
				Slider.BorderSizePixel = 0
				Slider.BackgroundColor3 = GuiLibrary.Settings.ClickGui.Buttons.BackgroundColor
				Slider.BackgroundTransparency = 0.1

				local SliderBar = Instance.new("Frame", Slider)
				SliderBar.Size = UDim2.fromScale(0.95, 0.7)
				SliderBar.Position = UDim2.fromScale(0.025, 0.5)
				SliderBar.AnchorPoint = Vector2.new(0, 0.5)
				SliderBar.BorderSizePixel = 0
				SliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				SliderBar.BackgroundTransparency = 0.2

				local SliderButton = Instance.new("Frame", SliderBar)
				SliderButton.Size = UDim2.fromScale(0, 1)
				SliderButton.BorderSizePixel = 0
				SliderButton.BackgroundColor3 = GuiLibrary.Settings.MainColor

				local SliderLabel = Instance.new("TextLabel", Slider)
				SliderLabel.Size = UDim2.fromScale(0.95, 1)
				SliderLabel.Position = UDim2.fromScale(0.025, 0)
				SliderLabel.BorderSizePixel = 0
				SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderLabel.BackgroundTransparency = 1
				SliderLabel.TextSize = 16
				SliderLabel.Font = Enum.Font.SourceSans
				SliderLabel.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. tab2.Name
				SliderLabel.TextXAlignment = GuiLibrary.Settings.ClickGui.Buttons.TextXAlignment or Enum.TextXAlignment.Left

				local ValueLabel = Instance.new("TextLabel", Slider)
				ValueLabel.Size = UDim2.fromScale(0.2, 1)
				ValueLabel.Position = UDim2.fromScale(0.75, 0)
				ValueLabel.BorderSizePixel = 0
				ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.TextSize = 16
				ValueLabel.Font = Enum.Font.SourceSans
				ValueLabel.TextXAlignment = Enum.TextXAlignment.Center

				local SliderOptions
				SliderOptions = {
					Value = tab2.Default,
					Min = tab2.Min,
					Max = tab2.Max,
					Step = tab2.Step,
					UpdateValue = function(value)
						value = math.clamp(value, SliderOptions.Min, SliderOptions.Max)
						value = math.floor(value / SliderOptions.Step + 0.5) * SliderOptions.Step
						SliderOptions.Value = value
						ValueLabel.Text = tostring(value)
						local relativePosition = (value - SliderOptions.Min) / (SliderOptions.Max - SliderOptions.Min)
						SliderButton.Size = UDim2.fromScale(relativePosition, 1)
						tab2.Function(value)

						sliderData.Value = value
						config.Sliders[tab.Name.."_"..tab2.Name] = sliderData
						task.delay(0.5,function()
							saveConfig()
						end)
					end
				}

				local function updateSlider(input)
					local relativePosition = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					local newValue = SliderOptions.Min + relativePosition * (SliderOptions.Max - SliderOptions.Min)
					SliderOptions.UpdateValue(newValue)
				end

				local dragging = false

				SliderButton.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end)

				SliderButton.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						updateSlider(input)
					end
				end)

				SliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						updateSlider(input)
						dragging = true
					end
				end)

				SliderBar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				SliderOptions.UpdateValue(sliderData.Value)

				task.spawn(function()
					repeat task.wait()
						SliderButton.BackgroundColor3 = GuiLibrary.Settings.MainColor
					until false
				end)

				return SliderOptions
			end

			button.MouseButton1Down:Connect(function()
				ButtonOptions.ToggleButton(not ButtonOptions.Enabled)
			end)

			button.MouseButton2Down:Connect(function()
				settingsFrame.Visible = not settingsFrame.Visible
			end)

			KeybindButton.MouseButton1Down:Connect(function()
				KeybindButton.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. "Press any key!"
			end)

			pcall(function()
				UserInputService.InputBegan:Connect(function(key, gpe)
					if gpe then return end

					if key.KeyCode == Keybind and Keybind ~= Enum.KeyCode.Unknown then
						ButtonOptions.ToggleButton(not ButtonOptions.Enabled)
					end

					if KeybindButton.Text:lower():find("press any key") and key.KeyCode ~= Enum.KeyCode.Unknown and key.KeyCode ~= Enum.KeyCode.Space and key.KeyCode ~= Enum.KeyCode.W and key.KeyCode ~= Enum.KeyCode.A and key.KeyCode ~= Enum.KeyCode.S and key.KeyCode ~= Enum.KeyCode.D then
						Keybind = key.KeyCode
						keybindData.Keybind = tostring(Keybind):split(".")[3]:upper()
						KeybindButton.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. "Bind: "..tostring(key.KeyCode):split(".")[3]:upper()
						config.Keybinds[tab.Name] = keybindData
						saveConfig()
					end

				end)
			end)

			pcall(function()
				Keybind = Enum.KeyCode[keybindData.Keybind]
			end)
			KeybindButton.Text = GuiLibrary.Settings.ClickGui.Buttons.Prefix .. "Bind: "..tostring(Keybind):split(".")[3]:upper()

			return ButtonOptions
		end,
	}

	WindowCount += 1
end

GuiLibrary.Functions:CreateWindow("Combat")
GuiLibrary.Functions:CreateWindow("Movement")
GuiLibrary.Functions:CreateWindow("Render")
GuiLibrary.Functions:CreateWindow("World")
GuiLibrary.Functions:CreateWindow("Other")

ClientColor = GuiLibrary.Windows.Render.CreateButtonWithOptions({
	Name = "ClientColor",
	Function = function(callback)
		task.spawn(function()
			repeat task.wait()
				GuiLibrary.Settings.MainColor = Color3.fromRGB(ClientColorR.Value,ClientColorG.Value,ClientColorB.Value)
			until not ClientColor.Enabled
		end)
	end,
})
--0, 159, 74
ClientColorR = ClientColor:MakeSlider({
	Name = "R",
	Min = 0,
	Max = 255,
	Default = 0,
	Step = 1,
	Function = function(val)

	end,
})

ClientColorG = ClientColor:MakeSlider({
	Name = "G",
	Min = 0,
	Max = 255,
	Default = 159,
	Step = 1,
	Function = function(val)

	end,
})

ClientColorB = ClientColor:MakeSlider({
	Name = "B",
	Min = 0,
	Max = 255,
	Default = 74,
	Step = 1,
	Function = function(val)

	end,
})

ArraylistModule = GuiLibrary.Windows.Render.CreateButtonWithOptions({
	Name = "Arraylist",
	Function = function(callback)
		Arraylist.Visible = callback

		task.spawn(function()
			repeat task.wait()
				for i,v in pairs(arrayItems) do
					v.BackgroundTransparency = ArraylistBackground.Value
				end
			until not ArraylistModule.Enabled
		end)
	end,
})

ArraylistPosX = ArraylistModule:MakeSlider({
	Name = "X",
	Min = 0,
	Max = 1,
	Default = 0.9,
	Step = 0.0001,
	Function = function(val)
		Arraylist.Position = UDim2.fromScale(val,Arraylist.Position.Y.Scale)
	end,
})

ArraylistPosY = ArraylistModule:MakeSlider({
	Name = "Y",
	Min = 0,
	Max = 1,
	Default = 0.05,
	Step = 0.05,
	Function = function(val)
		Arraylist.Position = UDim2.fromScale(Arraylist.Position.X.Scale,val)
	end,
})

ArraylistBackground = ArraylistModule:MakeSlider({
	Name = "Background",
	Min = 0,
	Max = 1,
	Default = 1,
	Step = 0.1,
	Function = function(val)
		for i,v in pairs(arrayItems) do
			v.BackgroundTransparency = val
		end
	end,
})

ArraylistDirection = ArraylistModule:MakePicker({
	Name = "Direction",
	Options = {"Left","Center","Right"},
	Function = function(val)
		if val:lower() == "left" then
			arraySort.HorizontalAlignment = Enum.HorizontalAlignment.Left
		end
		if val:lower() == "center" then
			arraySort.HorizontalAlignment = Enum.HorizontalAlignment.Center
		end
		if val:lower() == "right" then
			arraySort.HorizontalAlignment = Enum.HorizontalAlignment.Right
		end
	end,
})

ArraylistMode = ArraylistModule:MakePicker({
	Name = "Mode",
	Options = {"Static","Sparkle","Rainbow"},
	Function = function(val)

	end,
})

ArraylistSparkleRate = ArraylistModule:MakeSlider({
	Name = "SparkleRate",
	Min = 0,
	Max = 10,
	Default = 6,
	Step = 1,
	Function = function(val)

	end,
})

ArraylistRainbowSpeed = ArraylistModule:MakeSlider({
	Name = "RainbowSpeed",
	Min = 0,
	Max = 20,
	Default = 1,
	Step = 0.1,
	Function = function(val)

	end,
})

Watermark.Visible = false
WatermarkModule = GuiLibrary.Windows.Render.CreateButtonWithOptions({
	Name = "Watermark",
	Function = function(callback)
		Watermark.Visible = callback
	end,
})

WatermarkBackground = WatermarkModule:MakeSlider({
	Name = "Background",
	Min = 0,
	Max = 1,
	Default = 1,
	Step = 0.1,
	Function = function(val)
		Watermark.BackgroundTransparency = val
	end,
})

WatermarkBackground = WatermarkModule:MakeToggle({
	Name = "Background",
	Function = function(val)
		Watermark.BackgroundTransparency = val and 0.5 or 1
	end,
})

WatermarkSize = WatermarkModule:MakeSlider({
	Name = "Size",
	Min = 0,
	Max = 50,
	Default = 20,
	Step = 1,
	Function = function(val)
		Watermark.TextSize = val
	end,
})

WatermarkSize = WatermarkModule:MakeSlider({
	Name = "StrokeTransparency",
	Min = 0,
	Max = 1,
	Default = 0,
	Step = 0.1,
	Function = function(val)
		Watermark.TextStrokeTransparency = val
	end,
})

WatermarkPosX = WatermarkModule:MakeSlider({
	Name = "X",
	Min = 0,
	Max = 1,
	Default = 0.9,
	Step = 0.05,
	Function = function(val)
		Watermark.Position = UDim2.fromScale(val,Watermark.Position.Y.Scale)
	end,
})

WatermarkPosY = WatermarkModule:MakeSlider({
	Name = "Y",
	Min = 0,
	Max = 1,
	Default = 0,
	Step = 0.05,
	Function = function(val)
		Watermark.Position = UDim2.fromScale(Watermark.Position.X.Scale,val)
	end,
})

WatermarkMode = WatermarkModule:MakePicker({
	Name = "Mode",
	Options = {"Normal","Rainbow"},
	Function = function(val)

	end,
})

return GuiLibrary																												
