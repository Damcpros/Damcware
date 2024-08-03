--[[
	Damcware development by Damc & Xethrantic
	All code written by Damc & Xethrantic
--]]

local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Damcpros/Damcware/main/GuiLibrary.lua", true))()

lplr = lplr

Flight = GuiLibrary.Windows.Movement.CreateButtonWithOptions({
	Name = "Flight",
	Function = function(callback)
		if callback then
			local startY = lplr.Character.PrimaryPart.Position.Y
			local ticks = 0
			local flop = false
			task.spawn(function()
				repeat task.wait()
					local velo = lplr.Character.PrimaryPart.Velocity

					if FlightMode.Value == "Normal" then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(velo.X,FlightGlide.Value,velo.Z)
					else
						lplr.Character.PrimaryPart.Velocity = Vector3.new(velo.X,flop and FlightGlide.Value + 0.25 or -FlightGlide.Value,velo.Z)
					end

					if FlightVertical.Enabled then
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							lplr.Character.PrimaryPart.Velocity = Vector3.new(velo.X,FlightVerticalSpeed.Value,velo.Z)
						elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
							lplr.Character.PrimaryPart.Velocity = Vector3.new(velo.X,-FlightVerticalSpeed.Value,velo.Z)
						end
					end
					ticks += 1

					if ticks % 50 == 0 then
						ticks = 0
						flop = not flop
					end
				until not Flight.Enabled
			end)
		end
	end,
})
FlightMode = Flight:MakePicker({
	Name = "Mode",
	Options = {"Normal","Bounce"},
	Function = function() end,
})
FlightVertical = Flight:MakeToggle({
	Name = "Vertical",
	Function = function() end,
})
FlightVerticalSpeed = Flight:MakeSlider({
	Name = "VerticalSpeed",
	Min = 0,
	Max = 150,
	Default = 50,
	Step = 1,
	Function = function(val)

	end,
})
FlightGlide = Flight:MakeSlider({
	Name = "Glide",
	Min = -10,
	Max = 10,
	Default = 0.1,
	Step = 0.1,
	Function = function(val)

	end,
})

Speed = GuiLibrary.Windows.Movement.CreateButtonWithOptions({
	Name = "Speed",
	Function = function(callback)
		if callback then
			task.spawn(function()
				repeat task.wait()
					local direction = lplr.Character.Humanoid.MoveDirection
					local speed = SpeedValue.Value
					local velo = lplr.Character.PrimaryPart.Velocity

					lplr.Character.PrimaryPart.Velocity = Vector3.new(direction.X * speed,velo.Y,direction.Z * speed)

					if lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and SpeedJump.Enabled then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(velo.X,SpeedJumpValue.Value,velo.Z)
					end

				until not Speed.Enabled
			end)
		end
	end,
})

SpeedJump = Speed:MakeToggle({
	Name = "Jump",
	Function = function() end,
})

SpeedJumpValue = Speed:MakeSlider({
	Name = "JumpVelocity",
	Min = 0,
	Max = 100,
	Default = 0,
	Step = 1,
	Function = function(val)

	end,
})

SpeedValue = Speed:MakeSlider({
	Name = "Speed",
	Min = 0,
	Max = 100,
	Default = 0,
	Step = 0.1,
	Function = function(val)

	end,
})

Gravity = GuiLibrary.Windows.World.CreateButtonWithOptions({
	Name = "Gravity",
	Function = function(callback)
		if callback then
			workspace.Gravity = GravityValue.Value
		else
			workspace.Gravity = 196.2
		end
	end,
})

GravityValue = Gravity:MakeSlider({
	Name = "Gravity",
	Min = 0,
	Max = 196,
	Default = 196,
	Step = 1,
	Function = function(val)
		if Gravity.Enabled then
			workspace.Gravity = val
		end
	end,
})

local Connection
local Connection2
local Connection3

local mouse = lplr:GetMouse()

local whitelistedUsers = {
	["the_kidkidpros"] = true,
	["BluescreenOdeath4"] = true,
	["AnticheatO_nTop"] = true,
	["imgrantd77s_alt"] = true,
	["il9e9"] = true,
	["Iamtheforen"] = true,
	["Rush_S"] = true,
	["Pro77833_Yt"] = true,
	["Penguino7777777"] = true,
}

local function getNearestPlayerToMouse()
	local mousePos = lplr.Character.PrimaryPart.Position

	local nDist = math.huge
	local n = nil

	for i, v in pairs(PlayerService:GetPlayers()) do
		if v ~= lplr and v.Character and v.Character.PrimaryPart and whitelistedUsers[v.Name] ~= true then
			local dist = (v.Character.PrimaryPart.Position - mousePos).Magnitude
			if dist < nDist and v.Character.Humanoid.Health > 0 then
				nDist = dist
				n = v
			end
		end
	end

	return n
end

local RMBheld, raycastParams = false, RaycastParams.new()
raycastParams.FilterDescendantsInstances = {lplr.Character}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local doAim = function()
	pcall(function()
		if RMBheld then
			local nearest = getNearestPlayerToMouse()
			if nearest and nearest.Character and nearest.Character.PrimaryPart then
				local camera = workspace.CurrentCamera
				local rayOrigin = Vector3.new(camera.CFrame)
				local targetPos = nearest.Character.Head.Position

				local rayDirection = (targetPos - rayOrigin).Unit * 1000

				local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

			--[[if config.Raycast then
				if raycastResult then
					if raycastResult.Instance:IsDescendantOf(nearest.Character) then
						camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
					end
				end
			else
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
			end]]
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
			end
		end
	end)
end

SilentAim = GuiLibrary.Windows.Combat.CreateButtonWithOptions({
	Name = "Aimbot",
	Function = function(callback)  end,
})
Connection = game:GetService("RunService").Heartbeat:Connect(function(delta)
	if SilentAim.Enabled then
		pcall(doAim)
	end
end)
Connection2 = mouse.Button2Down:Connect(function()
	RMBheld = true
end)	
Connection3 = mouse.Button2Up:Connect(function()
	RMBheld = false
end)

local ESPConnection

local addESP = function(char,plr)
	pcall(function()
		local ui = Instance.new("BillboardGui",char)
		ui.Size = UDim2.fromScale(1,1)
		ui.AlwaysOnTop = true
		ui.ResetOnSpawn = true
		ui.Name = "MoonESP"
		local frame = Instance.new("Frame",ui)
		frame.Size = UDim2.fromScale(6,6)
		frame.AnchorPoint = Vector2.new(0.5,0.5)
		frame.Transparency = 0.5
		frame.BackgroundColor3 = whitelistedUsers[plr.Name] == true and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
	end)
end

ESP = GuiLibrary.Windows.Render.CreateButtonWithOptions({
	Name = "ESP",
	Function = function(callback)
		if callback then
			local playerAdded = {}

			ESPConnection = PlayerService.PlayerAdded:Connect(function(plr)
				plr.CharacterAdded:Connect(function(char)
					task.spawn(function()
						repeat task.wait() until char ~= nil
						if plr ~= lplr then
							addESP(char,plr)
						end
					end)
				end)
			end)

			for i,v in pairs(PlayerService:GetPlayers()) do
				pcall(function()
					if v ~= lplr then
						addESP(v.Character,v)
					end
				end)
			end

			task.spawn(function()
				repeat task.wait(1)
					for i,v in pairs(PlayerService:GetPlayers()) do
						pcall(function()
							if v ~= lplr and not v.Character:FindFirstChild("MoonESP") then
								addESP(v.Character,v)
							end
						end)
					end
				until not ESP.Enabled
			end)
		else
			ESPConnection:Disconnect()
		end
	end,
})

local noclip
Noclip = GuiLibrary.Windows.Movement.CreateButtonWithOptions({
	Name = "Noclip",
	Function = function(callback) 
		if callback then
			task.spawn(function()
				for i, v in pairs(game.Workspace:GetDescendants()) do
					if v:IsA("Part") or v:IsA("Meshpart") and v.Name ~= "FallFixInst" and not v:IsDescendantOf(lplr.Character)  then 
						v.CanCollide = false
					end
				end
				
				noclip = workspace.DescendantAdded:Connect(function(v)
					if v:IsA("Part") or v:IsA("Meshpart") and v.Name ~= "FallFixInst" and not v:IsDescendantOf(lplr.Character) then 
						v.CanCollide = false
					end
				end)
			end)
		else
			noclip:Disconnect()
			for i, v in pairs(game.Workspace:GetDescendants()) do
				if v:IsA("Part") or v:IsA("Meshpart") and v.Parent ~= lplr.Character then 
					v.CanCollide = true
				end
			end
		end
	end,
})

local startY = 0

local FallFixInst
FallFix = GuiLibrary.Windows.Movement.CreateButtonWithOptions({
	Name = "FallFix",
	Function = function(callback) 
		if callback then
			FallFixInst = Instance.new("Part",workspace)
			FallFixInst.Position = Vector3.new(0,3990,0)
			FallFixInst.Size = Vector3.new(20000,0.1,20000)
			FallFixInst.Transparency = 0.5
			FallFixInst.Name = "FallFixInst"
			FallFixInst.Anchored = true
			task.spawn(function()
				repeat task.wait()
					print(lplr.Character.PrimaryPart.Position.Y)
					FallFixInst.Position = Vector3.new(lplr.Character.PrimaryPart.Position.X,startY,lplr.Character.PrimaryPart.Position.Z)
					FallFixInst.CanCollide = true
				until not FallFix.Enabled
			end)
		else
			pcall(function()
				FallFixInst:Destroy()
			end)
		end
	end,
})

lplr.CharacterAdded:Connect(function(char)
	repeat task.wait() until char ~= nil
	startY = char.PrimaryPart.Position.Y - 3
end)
