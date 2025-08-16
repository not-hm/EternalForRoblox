--Gay Auto Grind Season Shit
repeat task.wait() until game:IsLoaded() task.wait(5)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local OriginalPlayer = nil

if queue_on_teleport then queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/not-hm/EternalForRoblox/refs/heads/main/piggy.lua"))()') end
task.spawn(function()
	while task.wait(5) do
		if #Players:GetPlayers() == 1 then
			TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Good Game, Leaving..")
			game:Shutdown()
		end
	end
end)

for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
	if v:IsA("RemoteEvent") and v.Name == "DeathEvent" then
		v:Destroy()
	end
end

for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
	if v:IsA("RemoteEvent") and v.Name == "DeathEvent" then
		v:Destroy()
	elseif v:IsA("Frame") and v.Name == "Fade" then
		v:Destroy()
	end
end

for _, v in ipairs(getconnections(LocalPlayer.PlayerGui.MainMenu.MainScreen.CenterFrame.CenterButtons.Play.MouseButton1Click)) do
	if v.Function then
		v:Fire()
		ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("JoinGame"):InvokeServer(true)
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Started...")
	end
end

task.wait(3)
local Maps = {"House", "Station", "Gallery", "Forest", "School", "Hospital", "Metro", "Carnival", "City", "Mall", "Outpost", "Plant", "DistortedMemory"}
local Map = nil
local TimeCheck = 300
local Timed = 0

repeat
	for _, name in ipairs(Maps) do
		Map = workspace:FindFirstChild(name)
		if Map then break end
	end
	task.wait(1)
	Timed += 1
until Map or Timed >= TimeCheck

if Map then
	TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Map chosen, " .. Map.Name:lower())
	task.wait(3)
	if #Players:GetPlayers() > 2 then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Reset, waiting...")
		LocalPlayer.CharacterAdded:Wait()
		task.spawn(function()
			while task.wait(1) do
				for _, v in ipairs(Players:GetPlayers()) do
					if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Enemy") then
						if v.Character.Enemy.Value == true and v.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
							local time = LocalPlayer.PlayerGui:WaitForChild("MainMenu"):WaitForChild("Timer").Text
							if time:match("%d%d:%d%d") then
								local min, sec = time:match("(%d%d):(%d%d)")
								if tonumber(min) < 9 or (tonumber(min) == 9 and tonumber(sec) < 30) then
									if not OriginalPlayer then
										OriginalPlayer = v
										TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Getting ready to teleport to " .. v.Name .. " position")
									end
									task.wait(2)
									LocalPlayer.Character.HumanoidRootPart.CFrame = OriginalPlayer.Character.HumanoidRootPart.CFrame
									TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Started...")
									return
								end
							end
						end
					end
				end
			end
		end)
		while task.wait(2) do
			if LocalPlayer.PlayerGui:WaitForChild("MainMenu"):WaitForChild("Timer").Text == "00:00" then
				TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Success, rejoining...")
				task.wait(3)
				TeleportService:Teleport(game.PlaceId, LocalPlayer)
			end
		end
	else
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Need one more person")
		repeat task.wait() until #Players:GetPlayers() == 3
		TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Three players joined, rejoining...")
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end
else
	TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync("Invalid map, rejoining...")
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end
