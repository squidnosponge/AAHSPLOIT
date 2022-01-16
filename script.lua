local versione = "04"

local mode = 1

wait(2)

local v1 = string.sub(versione,1,1)
local v2 = string.sub(versione,2,2)


local gui = {}

if mode == 1 then
	local id = "rbxassetid://8530199464"
	gui = game:GetObjects(id)[1]

	gui.Admin.version.Text = "v."..v1.."."..v2
	gui.Parent=game:GetService("CoreGui")

else
	gui = script.Parent
	gui.Admin.version.Text = "v."..v1.."."..v2
end




local commands = {}

local settingstocreate = {"Anti TP"}

local plrserv = game:GetService("Players")
local RunServ = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")





------------------------------------------------UI FUNCTIONS
local pages = gui.Admin.Pages
local cntrlpnl = gui.Admin.cntrlpnl


local exmpl1 = pages.Commands.exmpl
local exmpl = exmpl1:Clone()
exmpl1:Destroy()

exmpl1 = pages.Settings.exmpl
local setexmpl = exmpl1:Clone()
exmpl1:Destroy()



local cpage = 1
local pagesval = {pages.Commands,pages.Settings,pages.Credits}

local Settings = pages.Settings

local settingchanges = {}

do

	function listpages()
		local pagecount = 0
		for i,page in pairs(pages:GetChildren()) do
			table.insert(pagesval,page)
			pagecount = pagecount+1
		end	
		return pagecount
	end

	local pagecount = listpages()

	function setpage(num)
		for i,v in pairs(pages:GetChildren()) do
			v.Visible = false
		end

		if num == 1 then
			cntrlpnl.back.Visible = false
			cntrlpnl.forw.Visible = true
		elseif num == pagecount then
			cntrlpnl.back.Visible = true
			cntrlpnl.forw.Visible = false
		else
			cntrlpnl.forw.Visible = true
			cntrlpnl.back.Visible = true
		end
		pagesval[num].Visible = true
		cntrlpnl.pagename.Text = pagesval[num].Name
	end


	setpage(1)

	cntrlpnl.back.MouseButton1Down:Connect(function()
		if cpage < 2 then
		else
			setpage(cpage-1)
			cpage = cpage-1
		end
	end)


	cntrlpnl.forw.MouseButton1Down:Connect(function()
		if cpage > pagecount-1 then
		else
			setpage(cpage+1)
			cpage = cpage+1
		end
	end)

end

------------------------------------------------Command FUNCTIONS


do

	function chat(msg)
		if mode == 1 then
			plrserv:Chat(tostring(msg))
		else
			print(tostring(msg))
		end
	end



	function list(cmdname)

		local b = exmpl:Clone()

		b.Name = cmdname
		b.Text = cmdname
		b.Parent = pages.Commands

	end

	function findCmd(cmd_name)
		local found = false

		for i,v in pairs(commands)do
			if string.lower(v.Command)==string.lower(cmd_name) then
				found = v
			end
		end

		return found
	end

	function findPlayer(name)
		local found = {}

		if name == nil then
			table.insert(found, plrserv.LocalPlayer)
		else
			name = string.lower(name)
			if name == "all" then
				for i, plr in pairs(plrserv:GetChildren()) do
					table.insert(found, plr)
				end
			elseif name == "others" then
				for i, plr in pairs(plrserv:GetChildren()) do
					if plr ~= plrserv.LocalPlayer then
						table.insert(found, plr)
					end
				end
			elseif name == "me" then
				table.insert(found, plrserv.LocalPlayer)
			else
				for i, plr in pairs(plrserv:GetChildren()) do
					if string.sub(string.lower(plr.Name), 1, string.len(name)) == string.lower(name) then
						table.insert(found, plr)
					end
				end
			end
		end
		
		print(found)
		return found
	end

	function run(runcmd)
		local sp = {}

		for v in runcmd:gmatch("%w+") do table.insert(sp, v) end



		local command = findCmd(sp[1])
		table.remove(sp,1)
		if command ~= false then
			spawn(function()
				command.Func(sp)
			end)
		else
			return
		end
	end
end

do
	function createsettingpage(name)
		local b = setexmpl:Clone()

		b.Label.Text = name
		b.Name = name
		b.Parent = pages.Settings
	end

	function findsetting(setting)
		local found = false

		for i,v in pairs(settingchanges)do
			if string.lower(v.Name)==string.lower(setting) then
				found = v
			end
		end

		return found
	end

	function createsetting(name)
		local layout = {
			Name = name,
			value = false,
		}
		table.insert(settingchanges,layout)
	end

	function switchsettings(setting)
		local AutoRigCooldown = false

		if AutoRigCooldown == true then
			return
		end

		AutoRigCooldown = true





		if findsetting(setting).value == false then

			--SwitchRemote:FireServer(true, Falcon_SS.AutoR15, Falcon_SS.AutoR6)
			TweenService:Create(Settings[setting].Switch, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
			Settings[setting].Switch.Circle:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "InOut", "Sine", 0.2)
			--Settings.AutoR15.Description2.Visible = false
			--Settings.AutoR15.Description.Visible = true
			wait(0.2)

			repeat
				findsetting(setting).value = true
				RunService.Heartbeat:Wait()
			until findsetting(setting).value == true
		else

			--SwitchRemote:FireServer(false, Falcon_SS.AutoR15, Falcon_SS.AutoR6)
			TweenService:Create(Settings[setting].Switch, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
			Settings[setting].Switch.Circle:TweenPosition(UDim2.new(0, 0, 0.5, 0), "InOut", "Sine", 0.2)
			--Settings.AutoR15.Description.Visible = false
			--Settings.AutoR15.Description2.Visible = true

			wait(0.2)

			repeat
				findsetting(setting).value = false
				RunService.Heartbeat:Wait()
			until findsetting(setting).value == false
		end

		AutoRigCooldown = false
	end
end

------------------------------------------------CMDS FUNCTIONS


for i,set in pairs(settingstocreate) do
	createsettingpage(set)
end

for i,v in pairs(pages.Settings:GetChildren()) do
	if v.Name ~= "UIListLayout" then
		createsetting(v.Name)
		v.Switch.MouseButton1Down:Connect(function()
			switchsettings(v.Name)
		end)
	end
end




--Jail FUnctions

do
	local punished = {}

	function punish(plr,repet)
		if repet then
			table.insert(punished, plr)
		end
		
		if plr.Character.Parent == workspace then
			chat(":punish "..plr.Name)
		end
	end

	function unpunish(plr)
		if table.find(punished,plr) then
			for i,v in pairs(punished) do
				if v == plr then
					table.remove(punished, i)
				end
			end
		end

		chat(":unpunish "..plr.Name)
	end

	workspace.ChildAdded:Connect(function()
		
		for i, plr in pairs(punished) do			
			if plrserv:FindFirstChild(plr.Name) then

				punish(plr,false)

			end
		end
	end)
end

do
	local jailed = {}

	function jailplr(plr,repet)
		if repet then
			table.insert(jailed, plr)
		end

		if workspace:FindFirstChild(plr.Name.."_ADONISJAIL") then
		else
			chat(":jail "..plr.Name)
		end
	end

	function unjailplr(plr)
		if table.find(jailed,plr) then
			for i,v in pairs(jailed) do
				if v == plr then
					table.remove(jailed, i)
				end
			end
		end

		if workspace:FindFirstChild(plr.Name.."_ADONISJAIL") then
			chat(":unjail "..plr.Name)
		end
	end

	workspace.ChildRemoved:Connect(function()



		for i, plr in pairs(jailed) do			
			if plrserv:FindFirstChild(plr.Name) then

				jailplr(plr,false)

			end
		end
	end)
end

--F3X Functions
do
	function checkforf3x(arg)
		local found = false


		function checkf(prnt)
			if found == false then
				for i,v in pairs(prnt:GetChildren()) do
					if v.Name == "Building Tools" and v.ClassName == "Tool" then
						found = v
					end
				end
			end
		end

		if arg == false then
			checkf(plrserv.LocalPlayer.Character)
		end


		checkf(plrserv.LocalPlayer.Backpack)

		if arg == false then
			return found
		else
			found:Destroy()
		end
	end



	function equipf3x()
		local check = checkforf3x(false)
		if check ~= false then
			local f3x = check 
			if f3x.Parent.ClassName == "Backpack" then
				checkforf3x(true)
				return f3x
			end
		else
			chat(":f3x")
			local c = 0
			local found = false

			while found == false do
				if c > 9 then
					found = true
				end
				local check = checkforf3x(false)
				if check ~= false then
					equipf3x()
					found = true
				end
				wait(0.5)
				c = c+1
			end
		end
	end

	--[[local remote = game:GetService("Players").LocalPlayer.Backpack.Folder.SyncAPI.ServerEndpoint
	
	function deletepart(prt)
		equipf3x()
		local args = {
			[1] = "Remove",
			[2] = {
				[1] = prt
			}
		}

		remote:InvokeServer(unpack(args))

	end
	
	function movepart(prt,pos)
		local args = {
			[1] = "SyncMove",
			[2] = {
				[1] = {
					["Part"] = prt,
					["CFrame"] = CFrame.new(Vector3.new(pos), Vector3.new(-0, -0, -1))
				}
			}
		}

		remote:InvokeServer(unpack(args))
	end
	
	function paintpart()
		local args = {
			[1] = "RecolorHandle",
			[2] = BrickColor.new(1005)
		}

		remote:InvokeServer(unpack(args))
	end
	
	function createpart(pos)
		
		local args = {
			[1] = "CreatePart",
			[2] = "Normal",
			[3] = CFrame.new(Vector3.new(pos), Vector3.new(-0, -0, -1)),
			[4] = workspace
		}

		remote:InvokeServer(unpack(args))
		
	end]]
end

--AntiTp

do

	Check = false
	Boop = false

	RunServ.Heartbeat:Connect(function(step)
		if findsetting("Anti TP").value == true and plrserv.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if Check == false and Boop == false then	
				LastestPos = plrserv.LocalPlayer.Character.HumanoidRootPart.Position	
				Boop = true
				wait(.1)
				Check = true
				Boop = false
			else
				if Boop == false then	
					local NewPos = plrserv.LocalPlayer.Character.HumanoidRootPart.Position	
					if (LastestPos - NewPos).Magnitude > 35 and plrserv.LocalPlayer.Character:FindFirstChild("AESafe") == nil then
						plrserv.LocalPlayer.Character:MoveTo(LastestPos)
					end	
					Check = false
					Boop = false
				end
			end
		end
	end)


end

--MusicLock
do
	local musicsettings = {
		dafault = true,

		PlaybackSpeed = 0,
		SoundId = 0,
		Volume = 1,
	}

	function checkmusic()
		if workspace:FindFirstChild("ADONIS_SOUND") then
			local sound = workspace.ADONIS_SOUND

			if getsoundid(sound) == musicsettings.SoundId and sound.Volume == musicsettings.Volume and sound.PlaybackSpeed == musicsettings.PlaybackSpeed then
				return true
			else
				return false
			end
		else
			return false
		end
	end

	function getsoundid(sound)
		local id = sound.SoundId
		if string.match(id,"=") then
			id = string.split(id,"=")[2]
		elseif string.match(id,"rbxassetid") then
			id = string.split(id,"//")[2]
		end

		return id
	end

	function setmusic()
		if workspace:FindFirstChild("ADONIS_SOUND") then
			local sound = workspace.ADONIS_SOUND

			musicsettings.PlaybackSpeed = sound.PlaybackSpeed
			musicsettings.SoundId = getsoundid(sound)
			musicsettings.Volume = sound.Volume
			musicsettings.dafault = false



		end
	end

	function stopmusiclock()
		musicsettings = {
			dafault = true,

			PlaybackSpeed = 0,
			SoundId = 0,
			Volume = 1,
		}
	end


	function remusic()
		wait(1)
		chat(":music "..musicsettings.SoundId.." true "..musicsettings.PlaybackSpeed.." "..musicsettings.PlaybackSpeed)
	end

	function musiclock()
		if checkmusic() == true or musicsettings.dafault == true then

		else

			remusic()

		end
	end

	workspace.ChildRemoved:Connect(function(des)
		if des.Name == "ADONIS_SOUND" and getsoundid(des) == musicsettings.SoundId then
			musiclock()
		end
	end)


end

------------------------------------------------CMDS

--[[ EXAMPLE

cmds[#cmds+1]=
	{
		Name = "print",

		Func = function(args)
		print(args[1])
	end,

	}
	
]]

commands[#commands + 1] =
	{
		Name = "punish [plr]",

		Command = "punish",
		Func = function(arg)
			local plrs = findPlayer(arg[1])
			if plrs[1] then
			for i, plr in pairs(plrs) do
				print(plr)
				punish(plr,true)
			end 
		end
		end,

	}

commands[#commands + 1] =
	{
		Name = "unpunish [plr]",

		Command = "unpunish",
		Func = function(arg)
			local plrs = findPlayer(arg[1])
			if plrs[1] then
			for i, plr in pairs(plrs) do
				unpunish(plr)
			end 
		end
		end,

	}

commands[#commands + 1] =
	{
		Name = "jail [plr]",

		Command = "jail",
		Func = function(arg)
			local plrs = findPlayer(arg[1])
			if plrs[1] then
			for i, plr in pairs(plrs) do
				jailplr(plr,true)
			end 
		end
		end,

	}

commands[#commands + 1] =
	{
		Name = "unjail [plr]",

		Command = "unjail",
		Func = function(arg)

			local plrs = findPlayer(arg[1])
			if plrs[1] then
			for i, plr in pairs(plrs) do
				unjailplr(plr)
			end 
		end
		end,

	}

commands[#commands + 1] =
	{
		Name = "musiclock",

		Command = "musiclock",
		Func = function(arg)
			setmusic()
		end,

	}

commands[#commands + 1] =
	{
		Name = "unmusiclock",

		Command = "unmusiclock",
		Func = function(arg)
			stopmusiclock()
		end,

	}







for i, cmd in pairs(commands) do
	list(cmd.Name)
end


gui.Admin.TextBox.FocusLost:Connect(function()
	if gui.Admin.TextBox.Text ~= nil then
		run(gui.Admin.TextBox.Text)
	end
	gui.Admin.TextBox.Text = ""
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "AAHSPLOIT LOADED!";
	Text = "Made by gronk64";
	Icon = "";
	Duration = 3;
})
