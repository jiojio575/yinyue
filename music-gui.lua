local p=game:GetService("Players").LocalPlayer
local UIS=game:GetService("UserInputService")
local gui=Instance.new("ScreenGui")
gui.Parent=p.PlayerGui
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn=false
gui.IgnoreGuiInset = true

local f=Instance.new("Frame",gui)
f.Size=UDim2.new(0,300,0,130)
f.Position=UDim2.new(0,10,0,10)
f.BackgroundColor3=Color3.new(.2,.2,.2)
f.Active=true

local top=Instance.new("Frame",f)
top.Size=UDim2.new(1,0,0,30)
top.BackgroundColor3=Color3.new(.3,.3,.3)

local c=Instance.new("Frame",f)
c.Size=UDim2.new(1,0,1,-30)
c.Position=UDim2.new(0,0,0,30)
c.BackgroundTransparency=1

local tb=Instance.new("TextBox",c)
tb.Size=UDim2.new(0,280,0,30)
tb.Position=UDim2.new(0,10,0,10)
tb.PlaceholderText="请输入音乐ID"

local play=Instance.new("TextButton",c)
play.Size=UDim2.new(0,135,0,30)
play.Position=UDim2.new(0,10,0,50)
play.Text="播放"

local stop=Instance.new("TextButton",c)
stop.Size=UDim2.new(0,135,0,30)
stop.Position=UDim2.new(0,155,0,50)
stop.Text="停止"

local mini=Instance.new("TextButton",top)
mini.Size=UDim2.fromOffset(30,24)
mini.Position=UDim2.new(1,-70,0.5,-12)
mini.BackgroundColor3=Color3.fromRGB(50,50,70)
mini.Text="—"
mini.TextColor3=Color3.new(1,1,1)
mini.TextSize=16
Instance.new("UICorner",mini).CornerRadius=UDim.new(0,6)

local exp=Instance.new("TextButton",gui)
exp.Name="ExpandBtn"
exp.Size=UDim2.fromOffset(40,40)
exp.Position=f.Position
exp.BackgroundColor3=Color3.new(.8,0,0)
exp.Visible=false
Instance.new("UICorner",exp).CornerRadius=UDim.new(0,20)

local dragL=Instance.new("TextLabel",top)
dragL.Size=UDim2.fromOffset(50,24)
dragL.Position=UDim2.new(1,-190,0.5,-12)
dragL.BackgroundTransparency=1
dragL.Text="拖动:"
dragL.TextColor3=Color3.new(1,1,1)
dragL.TextSize=12

local dragS=Instance.new("TextButton",top)
dragS.Size=UDim2.fromOffset(36,20)
dragS.Position=UDim2.new(1,-150,0.5,-10)
dragS.BackgroundColor3=Color3.fromRGB(80,200,80)
dragS.Text="开"
dragS.TextColor3=Color3.new(1,1,1)
dragS.TextSize=12
Instance.new("UICorner",dragS).CornerRadius=UDim.new(0,10)

-- 只改这里！纯原生拖动，UI完全不变
f.Draggable = true
local dragEnable = true

dragS.MouseButton1Click:Connect(function()
	dragEnable = not dragEnable
	f.Draggable = dragEnable
	dragS.Text = dragEnable and "开" or "关"
	dragS.BackgroundColor3 = dragEnable and Color3.fromRGB(80,200,80) or Color3.fromRGB(200,80,80)
end)

mini.MouseButton1Click:Connect(function()
	f.Visible=false
	exp.Visible=true
	exp.Position=f.Position
end)

exp.MouseButton1Click:Connect(function()
	f.Visible=true
	exp.Visible=false
end)

local s
play.MouseButton1Click:Connect(function()
	local id=tb.Text:match("%d+")
	if not id then warn("无效ID")return end
	if s then s:Stop()s:Destroy()end
	s=Instance.new("Sound")
	s.SoundId="rbxassetid://"..id
	s.Volume=.5
	s.Looped=true
	s.Parent=p.Character or workspace
	s:Play()
end)

stop.MouseButton1Click:Connect(function()
	if s then s:Stop()s:Destroy()s=nil end
end)
