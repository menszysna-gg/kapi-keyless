local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local BIND_NAME = "LeBrokekapiUE"

local Cyan = Color3.fromRGB(0, 180, 245)
local Black = Color3.fromRGB(5, 5, 5)
local Dark = Color3.fromRGB(13, 13, 13)
local White = Color3.fromRGB(240, 240, 240)

local OldGui = PlayerGui:FindFirstChild("LeBrokekapiTuff")
if OldGui then
    OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "LeBrokekapiTuff"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

local function Create(class, parent, properties)
    local object = Instance.new(class)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function Label(parent, text, size, position, textSize)
    return Create("TextLabel", parent, {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = White,
        TextSize = textSize or 16,
        Font = Enum.Font.Code
    })
end

local function Button(parent, text, size, position)
    return Create("TextButton", parent, {
        Size = size,
        Position = position,
        BackgroundColor3 = Dark,
        BorderColor3 = Color3.fromRGB(40, 40, 40),
        Text = text,
        TextColor3 = White,
        TextSize = 16,
        Font = Enum.Font.Code,
        AutoButtonColor = false
    })
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local Main = Create("Frame", Gui, {
    Size = UDim2.fromOffset(520, 310),
    Position = UDim2.new(0.5, -260, 0.5, -155),
    BackgroundColor3 = Black,
    BorderColor3 = Color3.fromRGB(40, 40, 40),
    BorderSizePixel = 2,
    Visible = true
})

local MainHeader = Label(Main, "Le Brokekapi Tuff", UDim2.new(1, -50, 0, 38), UDim2.fromOffset(10, 2), 19)

Create("Frame", Main, {
    Size = UDim2.new(1, -24, 0, 2),
    Position = UDim2.fromOffset(12, 39),
    BackgroundColor3 = Cyan,
    BorderSizePixel = 0
})

local HideButton = Button(Main, "—", UDim2.fromOffset(28, 25), UDim2.new(1, -38, 0, 7))
HideButton.TextColor3 = Cyan

local Tab = Button(Main, "main", UDim2.fromOffset(76, 32), UDim2.fromOffset(12, 50))
Tab.BorderColor3 = Cyan
Tab.TextColor3 = Cyan

local Content = Create("Frame", Main, {
    Size = UDim2.new(1, -24, 1, -105),
    Position = UDim2.fromOffset(12, 94),
    BackgroundColor3 = Black,
    BorderColor3 = Color3.fromRGB(40, 40, 40)
})

Create("Frame", Content, {
    Size = UDim2.new(1, -4, 0, 2),
    Position = UDim2.fromOffset(2, 2),
    BackgroundColor3 = Cyan,
    BorderSizePixel = 0
})

Label(Content, "Main", UDim2.new(1, -20, 0, 30), UDim2.fromOffset(12, 12), 18)

local UEButton = Button(Content, "UE Counter: OFF", UDim2.new(1, -28, 0, 40), UDim2.fromOffset(14, 52))
UEButton.TextXAlignment = Enum.TextXAlignment.Left

local Status = Label(Content, "Status: Disabled", UDim2.new(1, -28, 0, 24), UDim2.fromOffset(14, 100), 14)
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextColor3 = Color3.fromRGB(150, 150, 150)

local OpenButton = Button(Gui, "OPEN MENU", UDim2.fromOffset(125, 35), UDim2.new(0, 18, 0.5, -17))
OpenButton.TextColor3 = Cyan
OpenButton.Visible = false

local CenterText = Label(Gui, "brokekapi ue counter", UDim2.new(1, 0, 0, 45), UDim2.new(0, 0, 0.5, -22), 24)
CenterText.TextColor3 = Cyan
CenterText.Visible = false

MakeDraggable(Main, MainHeader)

HideButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenButton.Visible = false
end)

local UEEnabled = false
local OldCameraType
local OldCameraSubject

local function SetUE(state)
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    UEEnabled = state

    if state then
        OldCameraType = Camera.CameraType
        OldCameraSubject = Camera.CameraSubject
        Camera.CameraType = Enum.CameraType.Scriptable

        RunService:BindToRenderStep(BIND_NAME, Enum.RenderPriority.Camera.Value + 1, function()
            local CurrentCamera = workspace.CurrentCamera
            if CurrentCamera then
                local position = CurrentCamera.CFrame.Position
                CurrentCamera.CFrame = CFrame.lookAt(
                    position,
                    position + Vector3.new(0, 1, 0),
                    Vector3.new(0, 0, -1)
                )
            end
        end)

        CenterText.Visible = true
        UEButton.Text = "UE Counter: ON"
        UEButton.TextColor3 = Cyan
        UEButton.BorderColor3 = Cyan
        Status.Text = "Status: Enabled"
        Status.TextColor3 = Cyan
    else
        RunService:UnbindFromRenderStep(BIND_NAME)
        Camera.CameraType = OldCameraType or Enum.CameraType.Custom
        if OldCameraSubject then
            Camera.CameraSubject = OldCameraSubject
        end

        CenterText.Visible = false
        UEButton.Text = "UE Counter: OFF"
        UEButton.TextColor3 = White
        UEButton.BorderColor3 = Color3.fromRGB(40, 40, 40)
        Status.Text = "Status: Disabled"
        Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

UEButton.MouseButton1Click:Connect(function()
    SetUE(not UEEnabled)
end)

Player.CharacterAdded:Connect(function()
    if UEEnabled then
        SetUE(false)
    end
end)
