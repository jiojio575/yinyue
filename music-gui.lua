local p = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Parent = p.PlayerGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- 主窗口
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 300, 0, 280)
f.Position = UDim2.new(0, 10, 0, 10)
f.BackgroundColor3 = Color3.new(.2, .2, .2)
f.Active = true
f.Draggable = true

local top = Instance.new("Frame", f)
top.Size = UDim2.new(1, 0, 0, 30)
top.BackgroundColor3 = Color3.new(.3, .3, .3)

local c = Instance.new("Frame", f)
c.Size = UDim2.new(1, 0, 1, -30)
c.Position = UDim2.new(0, 0, 0, 30)
c.BackgroundTransparency = 1

-- 输入框
local tb = Instance.new("TextBox", c)
tb.Size = UDim2.new(0, 280, 0, 30)
tb.Position = UDim2.new(0, 10, 0, 10)
tb.PlaceholderText = "请输入音乐ID"

-- 播放、停止、加歌单
local play = Instance.new("TextButton", c)
play.Size = UDim2.new(0, 85, 0, 30)
play.Position = UDim2.new(0, 10, 0, 50)
play.Text = "播放"

local stop = Instance.new("TextButton", c)
stop.Size = UDim2.new(0, 85, 0, 30)
stop.Position = UDim2.new(0, 100, 0, 50)
stop.Text = "停止"

local addBtn = Instance.new("TextButton", c)
addBtn.Size = UDim2.new(0, 85, 0, 30)
addBtn.Position = UDim2.new(0, 190, 0, 50)
addBtn.Text = "加歌单"

-- 保存、加载、编号输入
local saveSlotInput = Instance.new("TextBox", c)
saveSlotInput.Size = UDim2.new(0, 50, 0, 30)
saveSlotInput.Position = UDim2.new(0, 10, 0, 90)
saveSlotInput.PlaceholderText = "编号"

local saveBtn = Instance.new("TextButton", c)
saveBtn.Size = UDim2.new(0, 105, 0, 30)
saveBtn.Position = UDim2.new(0, 65, 0, 90)
saveBtn.Text = "保存歌单"

local loadBtn = Instance.new("TextButton", c)
loadBtn.Size = UDim2.new(0, 105, 0, 30)
loadBtn.Position = UDim2.new(0, 175, 0, 90)
loadBtn.Text = "加载歌单"

-- 提示
local tip = Instance.new("TextLabel", c)
tip.Size = UDim2.new(0, 280, 0, 20)
tip.Position = UDim2.new(0, 10, 0, 130)
tip.BackgroundTransparency = 1
tip.TextColor3 = Color3.new(1,1,1)
tip.TextSize = 12
tip.Text = "提示：输入1~99数字编号"

-- 歌单列表
local listFrame = Instance.new("ScrollingFrame", c)
listFrame.Size = UDim2.new(0, 280, 0, 120)
listFrame.Position = UDim2.new(0, 10, 0, 155)
listFrame.BackgroundColor3 = Color3.new(0.15,0.15,0.15)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 6
listFrame.CanvasSize = UDim2.new(0,0,0,0)

local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)

-- 最小化、展开、拖动UI（完全原样）
local mini = Instance.new("TextButton", top)
mini.Size = UDim2.fromOffset(30, 24)
mini.Position = UDim2.new(1, -70, 0.5, -12)
mini.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
mini.Text = "—"
mini.TextColor3 = Color3.new(1,1,1)
mini.TextSize = 16
Instance.new("UICorner", mini).CornerRadius = UDim.new(0,6)

local exp = Instance.new("TextButton", gui)
exp.Name = "ExpandBtn"
exp.Size = UDim2.fromOffset(40,40)
exp.Position = f.Position
exp.BackgroundColor3 = Color3.new(.8,0,0)
exp.Visible = false
Instance.new("UICorner", exp).CornerRadius = UDim.new(0,20)

local dragL = Instance.new("TextLabel", top)
dragL.Size = UDim2.fromOffset(50,24)
dragL.Position = UDim2.new(1,-190,0.5,-12)
dragL.BackgroundTransparency = 1
dragL.Text = "拖动:"
dragL.TextColor3 = Color3.new(1,1,1)
dragL.TextSize = 12

local dragS = Instance.new("TextButton", top)
dragS.Size = UDim2.fromOffset(36,20)
dragS.Position = UDim2.new(1,-150,0.5,-10)
dragS.BackgroundColor3 = Color3.fromRGB(80,200,80)
dragS.Text = "开"
dragS.TextColor3 = Color3.new(1,1,1)
dragS.TextSize = 12
Instance.new("UICorner", dragS).CornerRadius = UDim.new(0,10)

-- ====================== 数据与修复核心 ======================
local sound = nil
local dragEnable = true
local playlist = {}

-- 修复：使用 game:GetService("Players").LocalPlayer 稳定保存位置
local SaveData = Instance.new("Folder")
SaveData.Name = "MusicSaveData"
SaveData.Parent = p

local function showMsg(text)
    tip.Text = text
    task.delay(2, function() tip.Text = "提示：输入1~99数字编号" end)
end

local function isValidSlot(n)
    return type(n) == "number" and n >= 1 and n <= 99 and math.floor(n) == n
end

local function isIdInList(id)
    for _, v in ipairs(playlist) do
        if v == id then return true end
    end
    return false
end

local function refreshList()
    for _, ch in ipairs(listFrame:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end
    for i, id in ipairs(playlist) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1,0,0,22)
        item.BackgroundColor3 = Color3.new(0.25,0.25,0.25)
        item.Text = "["..i.."] "..id
        item.TextSize = 12
        item.TextColor3 = Color3.new(1,1,1)
        item.Parent = listFrame

        item.MouseButton1Click:Connect(function()
            if sound then sound:Destroy() end
            sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://"..id
            sound.Volume = 0.5
            sound.Looped = true
            sound.Parent = p.Character or workspace
            sound:Play()
            showMsg("播放："..id)
        end)

        item.MouseButton2Click:Connect(function()
            table.remove(playlist, i)
            refreshList()
            showMsg("删除："..id)
        end)
    end
    listFrame.CanvasSize = UDim2.new(0,0,0,#playlist*24)
end

-- 拖动开关
dragS.MouseButton1Click:Connect(function()
    dragEnable = not dragEnable
    f.Draggable = dragEnable
    dragS.Text = dragEnable and "开" or "关"
    dragS.BackgroundColor3 = dragEnable and Color3.fromRGB(80,200,80) or Color3.fromRGB(200,80,80)
end)

-- 最小化
mini.MouseButton1Click:Connect(function()
    f.Visible = false
    exp.Visible = true
    exp.Position = f.Position
end)
exp.MouseButton1Click:Connect(function()
    f.Visible = true
    exp.Visible = false
end)

-- 添加歌单（防重复）
addBtn.MouseButton1Click:Connect(function()
    local raw = tb.Text:match("%d+")
    if not raw then
        showMsg("❌ 无效ID")
        return
    end
    if isIdInList(raw) then
        showMsg("❌ 已存在")
        return
    end
    table.insert(playlist, raw)
    refreshList()
    tb.Text = ""
    showMsg("✅ 已加入歌单")
end)

-- 播放
play.MouseButton1Click:Connect(function()
    local id = tb.Text:match("%d+")
    if not id then showMsg("❌ 请输入ID") return end
    if sound then sound:Destroy() end
    sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://"..id
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = p.Character or workspace
    sound:Play()
    showMsg("▶️ 播放："..id)
end)

stop.MouseButton1Click:Connect(function()
    if sound then sound:Destroy() sound = nil end
    showMsg("⏹️ 已停止")
end)

-- ====================== 修复：保存（必存成功） ======================
saveBtn.MouseButton1Click:Connect(function()
    local slotTxt = saveSlotInput.Text:gsub("%D", "")
    local slot = tonumber(slotTxt)

    if not slot or not isValidSlot(slot) then
        showMsg("❌ 编号必须1~99")
        return
    end

    local key = "Slot_" .. slot
    local val = table.concat(playlist, "|")

    local sv = SaveData:FindFirstChild(key) or Instance.new("StringValue")
    sv.Name = key
    sv.Value = val
    sv.Parent = SaveData

    showMsg("✅ 编号"..slot.." 保存成功！")
end)

-- ====================== 修复：加载（必读成功） ======================
loadBtn.MouseButton1Click:Connect(function()
    local slotTxt = saveSlotInput.Text:gsub("%D", "")
    local slot = tonumber(slotTxt)

    if not slot or not isValidSlot(slot) then
        showMsg("❌ 编号必须1~99")
        return
    end

    local key = "Slot_" .. slot
    local sv = SaveData:FindFirstChild(key)

    if not sv or sv.Value == "" then
        showMsg("❌ 编号"..slot.." 无存档")
        return
    end

    local arr = string.split(sv.Value, "|")
    local clean = {}
    local dup = {}
    for _, id in ipairs(arr) do
        local t = id:gsub("%s", "")
        if t ~= "" and not dup[t] then
            dup[t] = true
            table.insert(clean, t)
        end
    end

    playlist = clean
    refreshList()
    showMsg("✅ 编号"..slot.." 加载成功！")
end)

refreshList()
showMsg("✅ 面板加载完成，保存加载已修复")
