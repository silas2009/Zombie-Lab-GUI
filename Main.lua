local oldGui = game.CoreGui:FindFirstChild("Zombie Lab GUI")
if oldGui then
	oldGui:Destroy()
end
local gui = game:GetService("InsertService"):LoadLocalAsset("rbxassetid://12727847442")
gui.Parent = game:GetService("CoreGui")
gui.Main.Active = true
gui.Main.Draggable = true
gui.Main.Topbar.Container:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
	gui:Destroy()
end)
---------------------------------------------------------
script = gui:FindFirstChildOfClass("LocalScript")

local lplr = game:GetService("Players").LocalPlayer
local usernameInput = script.Parent.Main.Container.PlayerOptions.ScrollingFrame.Username.TextBox
local icon = script.Parent.Main.Container.PlayerOptions.icon
local hovering = {}

local Hint = gui.Hint

function FindFirstDescendantOfClassAndName(object,ClassName,Name)
	for _,v in pairs(object:GetDescendants()) do
		if v.Name == Name and v.ClassName == ClassName then
			return v
		end
	end
end

function alignPosition(plr1,plr2)
	local rightHand = plr1.Character.RightHand
	local alignPos = Instance.new("AlignPosition",rightHand)
	local attachment0 = Instance.new("Attachment",rightHand)
	local attachment1 = Instance.new("Attachment",plr2.Character.PrimaryPart)
	attachment1.Position = Vector3.new(0,0,1)
	alignPos.Attachment0 = attachment0
	alignPos.Attachment1 = attachment1
	alignPos.RigidityEnabled = true
	local alignOrientation = Instance.new("AlignOrientation",plr1.Character.PrimaryPart)
	attachment0 = Instance.new("Attachment",plr1.Character.PrimaryPart)
	alignOrientation.Attachment0 = attachment0
	alignOrientation.Attachment1 = attachment1
	alignOrientation.RigidityEnabled = true

	return alignPos,alignOrientation
end

function findPlr(search,keywords)
	if search then
		if typeof(search) == "Instance" and search:IsA("Player") then
			return search
		end
		if #search > 0 then
			local plrsList = game:GetService("Players"):GetPlayers()
			if keywords then
				if search:lower() == "all" then
					return plrsList
				elseif search:lower() == "others" then
					table.remove(plrsList,table.find(plrsList,lplr))
					return plrsList
				elseif search:lower() == "me" then
					return lplr
				end
			end
			for _,v in pairs(plrsList) do
				if v.Character then
					if string.sub(v.Name:lower(),0,#search) == search:lower() then
						return v
					end
				end
			end
			for _,v in pairs(plrsList) do
				if v.Character then
					if string.sub(v.DisplayName:lower(),0,#search) == search:lower() then
						return v
					end
				end
			end
		end
	end
end

local categories = {
	"General",
	"Self",
	"Zombie"
}

local injectionDebounce = false
local humanDoor = workspace:FindFirstChild("HumanOnlyDoor")

local commands = {
	{
		cmd = "Kill Zombie",
		category = "Zombie",
		description = "Kills the desired user by firing the gun event (Only works on Zombies)",
		requiredArgs = {"plr"},
		func = function(args)
			local foundRemote = FindFirstDescendantOfClassAndName(game,"RemoteEvent","InflictTarget")
			local plr = findPlr(args[1])
			if (plr and plr.Team == game.Teams.Zombie) and foundRemote then
				foundRemote:FireServer(
					plr.Character.Humanoid,
					plr.Character.HumanoidRootPart,
					100,
					Vector3.new(),
					2,
					0,
					false
				)
			end
		end,
	},
	{
		cmd = "Get Cure Tool",
		requiredArgs = {},
		description = "Gives you the Cure tool",
		category = "Self",
		func = function(args)
			game:GetService("ReplicatedStorage"):FindFirstChild("Events").GiveCure:FireServer()
		end,
	},
	{
		cmd = "Get Cookie",
		requiredArgs = {},
		description = "Gives you a Cookie",
		category = "Self",
		func = function(args)
			local cookieGiver = workspace.Lab.CookieGiver.CookieGiver
			local ogPos = lplr.Character.PrimaryPart.CFrame
			local ogCamCF = workspace.CurrentCamera.CFrame
			lplr.Character.PrimaryPart.CFrame = cookieGiver.CFrame * CFrame.new(0,2.5,0)
			task.wait()
			workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.Focus.Position,cookieGiver.Position)
			task.wait(0.2)
			cookieGiver.ProximityPrompt:InputHoldBegin()
			task.wait()
			cookieGiver.ProximityPrompt:InputHoldEnd()
			task.wait(0.2)
			workspace.CurrentCamera.CFrame = ogCamCF
			lplr.Character.PrimaryPart.CFrame = ogPos
		end,
	},
	{
		cmd = "Get Virus Tool",
		description = "Gives you the Virus tool",
		category = "Self",
		requiredArgs = {},
		func = function(args)
			game:GetService("ReplicatedStorage"):FindFirstChild("Events").GiveVirus:FireServer()
		end,
	},
	{
		cmd = "Toggle Human Door",
		description = "Removes the human door/zombie barrier",
		category = "General",
		requiredArgs = {},
		func = function(args)
			if humanDoor.Parent == nil then
				humanDoor.Parent = workspace
			else
				humanDoor:Remove()
			end
		end,
	},
	{
		cmd = "Remove Anti Weapon Zone",
		description = "Removes the anti weapon zone, you can use this to inject viruses inside the human room",
		category = "General",
		requiredArgs = {},
		func = function(args)
			local door = workspace:FindFirstChild("AntiWeaponZone")
			if door then
				door:Destroy()
			end
		end,
	},
	{
		cmd = "Virus",
		description = "Teleports you to the desired user and injects them with a Virus",
		category = "General",
		requiredArgs = {"plr"},
		func = function(args)
			local plr = findPlr(args[1])
			if plr and plr.Character and plr.Character.PrimaryPart and plr.Team ~= game.Teams.Zombie then
				if not injectionDebounce then
					injectionDebounce = true
					local injection = lplr.Backpack:FindFirstChild("Virus")
					if not injection then
						game:GetService("ReplicatedStorage"):FindFirstChild("Events").GiveVirus:FireServer()
						injection = lplr.Backpack:WaitForChild("Virus")
					end
					if plr == lplr then
						wait(0.1)
						lplr.Character:FindFirstChildOfClass("Humanoid"):EquipTool(injection)
						injection.UseSelf:FireServer()
					else
						local ogPos = lplr.Character.PrimaryPart.CFrame
						local alignPos,alignOrientation = alignPosition(lplr,plr)
						lplr.Character.PrimaryPart.CFrame = plr.Character.PrimaryPart.CFrame
						lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
						wait(0.1)
						lplr.Character:FindFirstChildOfClass("Humanoid"):EquipTool(injection)
						injection:Activate()
						wait(0.5)
						alignPos.Attachment0:Destroy()
						alignPos.attachment1:Destroy()
						alignPos:Destroy()
						alignOrientation:Destroy()
						lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.GettingUp)
						for i = 1,10 do
							wait()
							lplr.Character.PrimaryPart.CFrame = ogPos
						end
					end
					injectionDebounce = false
				end
			end
		end,
	},
	{
		cmd = "Cure",
		description = "Teleports you to the desired user and injects them with a Cure",
		category = "General",
		requiredArgs = {"plr"},
		func = function(args)
			local plr = findPlr(args[1])
			if plr and plr.Character and plr.Character.PrimaryPart and plr.Team == game.Teams.Zombie then
				if not injectionDebounce then
					injectionDebounce = true
					local injection = lplr.Backpack:FindFirstChild("Cure")
					if not injection then
						game:GetService("ReplicatedStorage"):FindFirstChild("Events").GiveCure:FireServer()
						injection = lplr.Backpack:WaitForChild("Cure")
					end
					if plr == lplr then
						wait(0.1)
						lplr.Character:FindFirstChildOfClass("Humanoid"):EquipTool(injection)
						wait(0.1)
						injection.UseSelf:FireServer()
						lplr.CharacterAdded:Wait()
					else
						local ogPos = lplr.Character.PrimaryPart.CFrame
						local alignPos,alignOrientation = alignPosition(lplr,plr)
						lplr.Character.PrimaryPart.CFrame = plr.Character.PrimaryPart.CFrame
						lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
						wait(0.1)
						lplr.Character:FindFirstChildOfClass("Humanoid"):EquipTool(injection)
						injection:Activate()
						wait(0.5)
						alignPos.Attachment0:Destroy()
						alignPos.attachment1:Destroy()
						alignPos:Destroy()
						alignOrientation:Destroy()
						lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.GettingUp)
						for i = 1,10 do
							wait()
							lplr.Character.PrimaryPart.CFrame = ogPos
						end
					end
					injectionDebounce = false
				end
			end
		end,
	},
	{
		cmd = "Toggle Shop",
		description = "Toggles the shop",
		category = "Self",
		requiredArgs = {},
		func = function(args)
			lplr.PlayerGui.ShopGui.MainFrame.Visible = not lplr.PlayerGui.ShopGui.MainFrame.Visible
		end,
	},
	{
		cmd = "Toggle Face Chooser",
		description = "Toggles the face chooser",
		category = "Self",
		requiredArgs = {},
		func = function(args)
			lplr.PlayerGui.PlayerGui.ChooseFaceFrame.Visible = not lplr.PlayerGui.PlayerGui.ChooseFaceFrame.Visible
		end,
	},
	{
		cmd = "Toggle Skin Chooser",
		description = "Toggles the skin chooser",
		category = "Self",
		requiredArgs = {},
		func = function(args)
			lplr.PlayerGui.PlayerGui.ChooseSkinFrame.Visible = not lplr.PlayerGui.PlayerGui.ChooseSkinFrame.Visible
		end,
	},
}
local categoryButtonTemplate = script:WaitForChild("Category")
local buttonTemplate = script:WaitForChild("Button")

local buttonsContainer = script.Parent.Main.Container.Buttons.ScrollingFrame
local categoriesContainer = script.Parent.Main.Container.Categories.ScrollingFrame

function loadButtons(category)
	for _,v in pairs(buttonsContainer:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
	for _,command in pairs(commands) do
		if command.category == category then
			local button = buttonTemplate:Clone()
			local text
			if #command.requiredArgs > 0 then
				text = string.format("%s [%s]",command.cmd,table.concat(command.requiredArgs,","))
			else
				text = command.cmd
			end
			button.Text = text
			button.MouseButton1Click:Connect(function()
				if table.find(command.requiredArgs,"plr") then
					if usernameInput.Text:lower() == "all" then
						for _,v in pairs(findPlr("all",true)) do
							local success,err = pcall(function()
								command.func({v})
							end)
							if not success then
								injectionDebounce = false
							end
							warn(err)
						end
					elseif usernameInput.Text:lower() == "others" then
						for _,v in pairs(findPlr("others",true)) do
							local success,err = pcall(function()
								command.func({v})
							end)
							if not success then
								injectionDebounce = false
							end
							warn(err)
						end
					else
						local success,err = pcall(function()
							command.func({usernameInput.Text})
						end)
						if not success then
							injectionDebounce = false
						end
						warn(err)
					end
				else
					pcall(command.func)
				end
			end)
			button.MouseEnter:Connect(function()
				table.insert(hovering,button)
				Hint.Visible = #hovering > 0
				Hint.Text = command.description
			end)
			button.MouseLeave:Connect(function()
				table.remove(hovering,table.find(hovering,button))
				Hint.Visible = #hovering > 0
			end)
			button.InputChanged:Connect(function(input)
				if table.find(hovering,button) and input.UserInputType == Enum.UserInputType.MouseMovement then
					Hint.Position = UDim2.fromOffset(input.Position.X+10,input.Position.Y)
				end
			end)
			button.Parent = buttonsContainer
		end
	end
end
for _,v in pairs(categoriesContainer:GetChildren()) do
	if v:IsA("GuiObject") then
		v:Destroy()
	end
end
for _,category in pairs(categories) do
	local button = categoryButtonTemplate:Clone()
	button.Text = category
	button.MouseButton1Click:Connect(function()
		loadButtons(category)
	end)
	button.Parent = categoriesContainer
end
usernameInput:GetPropertyChangedSignal("Text"):Connect(function()
	local plr
	if usernameInput.Text:lower() == "me" then
		plr = findPlr(usernameInput.Text,true)
	else
		plr = findPlr(usernameInput.Text)
	end
	if plr then
		icon.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100",plr.UserId)
	else
		icon.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100",1)
	end
end)
usernameInput.FocusLost:Connect(function()
	local plr
	if usernameInput.Text:lower() == "me" then
		plr = findPlr(usernameInput.Text,true)
	else
		plr = findPlr(usernameInput.Text)
	end
	if plr and usernameInput.Text ~= "all" and usernameInput.Text ~= "others" then
		usernameInput.Text = plr.DisplayName
	end
end)
loadButtons("General")
