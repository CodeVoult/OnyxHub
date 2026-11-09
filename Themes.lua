--[[
    OnyxHub Themes Module - Halloween con efectos Vegas (corregido)
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Themes = {
    purple = {
        Name = "purple",
        MainColor = Color3.fromRGB(150, 100, 255),
        MainColorLight = Color3.fromRGB(200, 150, 255),
        BgDeep = Color3.fromRGB(25, 15, 35),
        BgMain = Color3.fromRGB(30, 20, 40),
        BgPanel = Color3.fromRGB(40, 30, 55),
        BgItem = Color3.fromRGB(35, 25, 45),
        BgHover = Color3.fromRGB(45, 35, 55),
        BgTabOff = Color3.fromRGB(50, 40, 65),
        BgTabOn = Color3.fromRGB(80, 60, 100),
        BgToggleOff = Color3.fromRGB(60, 50, 70),
        BgIcon = Color3.fromRGB(60, 45, 80),
        BgIconHover = Color3.fromRGB(80, 65, 100),
        BgOpenCloseOff = Color3.fromRGB(50, 35, 65),
        BgScrollbar = Color3.fromRGB(120, 100, 150),
        BgGradientStart = Color3.fromRGB(50, 40, 70),
        BgGradientEnd = Color3.fromRGB(35, 25, 50),
        BgTaskHover = Color3.fromRGB(50, 40, 75),
        TextMain = Color3.fromRGB(245, 235, 255),
        TextBright = Color3.fromRGB(250, 240, 255),
        TextSub = Color3.fromRGB(220, 210, 230),
        TextDim = Color3.fromRGB(200, 200, 200),
        TextLabel = Color3.fromRGB(240, 230, 250),
    },

    negro = {
        Name = "negro",
        MainColor = Color3.fromRGB(160, 160, 160),
        MainColorLight = Color3.fromRGB(210, 210, 210),
        BgDeep = Color3.fromRGB(15, 15, 15),
        BgMain = Color3.fromRGB(20, 20, 20),
        BgPanel = Color3.fromRGB(32, 32, 32),
        BgItem = Color3.fromRGB(28, 28, 28),
        BgHover = Color3.fromRGB(42, 42, 42),
        BgTabOff = Color3.fromRGB(42, 42, 42),
        BgTabOn = Color3.fromRGB(85, 85, 85),
        BgToggleOff = Color3.fromRGB(55, 55, 55),
        BgIcon = Color3.fromRGB(55, 55, 55),
        BgIconHover = Color3.fromRGB(75, 75, 75),
        BgOpenCloseOff = Color3.fromRGB(45, 45, 45),
        BgScrollbar = Color3.fromRGB(100, 100, 100),
        BgGradientStart = Color3.fromRGB(45, 45, 45),
        BgGradientEnd = Color3.fromRGB(25, 25, 25),
        BgTaskHover = Color3.fromRGB(55, 55, 55),
        TextMain = Color3.fromRGB(240, 240, 240),
        TextBright = Color3.fromRGB(255, 255, 255),
        TextSub = Color3.fromRGB(200, 200, 200),
        TextDim = Color3.fromRGB(180, 180, 180),
        TextLabel = Color3.fromRGB(230, 230, 230),
    },

    halloween = {
        Name = "halloween",
        MainColor = Color3.fromRGB(255, 140, 30),
        MainColorLight = Color3.fromRGB(255, 190, 70),
        BgDeep = Color3.fromRGB(18, 8, 6),
        BgMain = Color3.fromRGB(28, 14, 10),
        BgPanel = Color3.fromRGB(48, 24, 16),
        BgItem = Color3.fromRGB(42, 20, 14),
        BgHover = Color3.fromRGB(62, 32, 20),
        BgTabOff = Color3.fromRGB(55, 28, 18),
        BgTabOn = Color3.fromRGB(120, 55, 25),
        BgToggleOff = Color3.fromRGB(70, 40, 28),
        BgIcon = Color3.fromRGB(70, 38, 22),
        BgIconHover = Color3.fromRGB(100, 55, 30),
        BgOpenCloseOff = Color3.fromRGB(50, 25, 15),
        BgScrollbar = Color3.fromRGB(180, 90, 40),
        BgGradientStart = Color3.fromRGB(78, 34, 14),
        BgGradientEnd = Color3.fromRGB(36, 16, 14),
        BgTaskHover = Color3.fromRGB(90, 45, 25),
        TextMain = Color3.fromRGB(255, 240, 220),
        TextBright = Color3.fromRGB(255, 255, 255),
        TextSub = Color3.fromRGB(220, 180, 140),
        TextDim = Color3.fromRGB(190, 150, 120),
        TextLabel = Color3.fromRGB(255, 220, 180),
    },
}

local Aliases = {
    purple = "purple", morado = "purple", default = "purple", violeta = "purple",
    ["púrpura"] = "purple", purplee = "purple",
    negro = "negro", black = "negro", dark = "negro", oscuro = "negro",
    gray = "negro", grey = "negro", gris = "negro", night = "negro",
    halloween = "halloween", naranja = "halloween", orange = "halloween",
    pumpkin = "halloween", spooky = "halloween", vegas = "halloween",
}

local function GetTheme(name)
    local key = Aliases[string.lower(tostring(name or "purple"))] or "purple"
    return Themes[key] or Themes.purple
end

local activeEffects = {
    connections = {},
    instances = {},
    loopingTweens = {},
}

local function clearEffects()
    for _, c in ipairs(activeEffects.connections) do
        pcall(function() c:Disconnect() end)
    end
    for _, tw in ipairs(activeEffects.loopingTweens) do
        pcall(function() tw:Cancel() end)
    end
    for _, inst in ipairs(activeEffects.instances) do
        pcall(function() if inst and inst.Parent then inst:Destroy() end end)
    end
    activeEffects.connections = {}
    activeEffects.loopingTweens = {}
    activeEffects.instances = {}
end

local function loopTween(obj, duration, props, style, reverses)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(duration, style or Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, reverses or false),
        props
    )
    tw:Play()
    table.insert(activeEffects.loopingTweens, tw)
    return tw
end

local function ApplyThemeEffects(theme, mainFrame)
    clearEffects()
    if not mainFrame or not mainFrame.Parent then return end
    if not theme or theme.Name ~= "halloween" then return end

    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local C = {
        Orange = theme.MainColor,
        Red = Color3.fromRGB(205, 35, 45),
        White = Color3.fromRGB(255, 255, 255),
    }

    -------------------------------------------------
    -- FRAME DE FONDO COMPLETO (detrás de TODO)
    -------------------------------------------------
    local bgLayer = Instance.new("Frame")
    bgLayer.Name = "ThemeBackground"
    bgLayer.Size = UDim2.new(1, 0, 1, 0)
    bgLayer.Position = UDim2.new(0, 0, 0, 0)
    bgLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bgLayer.BackgroundTransparency = 0
    bgLayer.BorderSizePixel = 0
    bgLayer.ZIndex = 0
    bgLayer.ClipsDescendants = true
    bgLayer.Parent = mainFrame
    table.insert(activeEffects.instances, bgLayer)

    -- Hacer el MainFrame transparente para que se vea el bgLayer
    mainFrame.BackgroundTransparency = 1

    -- Gradiente exacto de Vegas
    local bgGrad = Instance.new("UIGradient")
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 34, 14)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(36, 16, 14)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 38, 12)),
    })
    bgGrad.Parent = bgLayer

    -------------------------------------------------
    -- Borde animado (en el MainFrame)
    -------------------------------------------------
    local border = Instance.new("UIStroke")
    border.Thickness = 2.8
    border.Color = C.White
    border.Parent = mainFrame
    table.insert(activeEffects.instances, border)

    local borderGrad = Instance.new("UIGradient")
    borderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Orange),
        ColorSequenceKeypoint.new(0.5, C.Red),
        ColorSequenceKeypoint.new(1, C.Orange),
    })
    borderGrad.Parent = border
    loopTween(borderGrad, 6, { Rotation = 360 })

    -------------------------------------------------
    -- Glow inferior
    -------------------------------------------------
    local glow = Instance.new("Frame")
    glow.Name = "ThemeGlow"
    glow.Size = UDim2.new(1, 0, 0, 120)
    glow.Position = UDim2.new(0, 0, 1, -120)
    glow.BackgroundColor3 = C.Orange
    glow.BorderSizePixel = 0
    glow.ZIndex = 1
    glow.Parent = bgLayer
    table.insert(activeEffects.instances, glow)

    local gCorner = Instance.new("UICorner")
    gCorner.CornerRadius = UDim.new(0, 5)
    gCorner.Parent = glow

    local glowGrad = Instance.new("UIGradient")
    glowGrad.Rotation = 90
    glowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.5),
    })
    glowGrad.Parent = glow

    -------------------------------------------------
    -- Luz superior
    -------------------------------------------------
    local topLight = Instance.new("Frame")
    topLight.Name = "ThemeTopLight"
    topLight.Size = UDim2.new(1, 0, 0, 90)
    topLight.BackgroundColor3 = Color3.fromRGB(255, 190, 50)
    topLight.BorderSizePixel = 0
    topLight.ZIndex = 1
    topLight.Parent = bgLayer
    table.insert(activeEffects.instances, topLight)

    local tlCorner = Instance.new("UICorner")
    tlCorner.CornerRadius = UDim.new(0, 5)
    tlCorner.Parent = topLight

    local tlGrad = Instance.new("UIGradient")
    tlGrad.Rotation = 90
    tlGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 1),
    })
    tlGrad.Parent = topLight

    -------------------------------------------------
    -- Partículas (embers + pumpkins)
    -------------------------------------------------
    local dots = Instance.new("Frame")
    dots.Name = "ThemeParticles"
    dots.Size = UDim2.new(1, 0, 1, 0)
    dots.BackgroundTransparency = 1
    dots.ZIndex = 2
    dots.ClipsDescendants = true
    dots.Parent = bgLayer
    table.insert(activeEffects.instances, dots)

    local rng = Random.new()
    local SINE = Enum.EasingStyle.Sine
    local EMBER_COLORS = { C.Orange, Color3.fromRGB(255, 208, 70), C.Red }

    local function randomFlow()
        local roll = rng:NextNumber()
        local side = roll < 0.4 and 1 or (roll < 0.6 and 2 or (roll < 0.8 and 3 or 4))
        local t0 = rng:NextNumber(0.05, 0.95)
        local t1 = math.clamp(t0 + rng:NextNumber(-0.3, 0.3), 0.05, 0.95)
        if side == 1 then
            return UDim2.fromScale(t0, 1.08), UDim2.fromScale(t1, -0.08)
        elseif side == 2 then
            return UDim2.fromScale(t0, -0.08), UDim2.fromScale(t1, 1.08)
        elseif side == 3 then
            return UDim2.fromScale(-0.08, t0), UDim2.fromScale(1.08, t1)
        else
            return UDim2.fromScale(1.08, t0), UDim2.fromScale(-0.08, t1)
        end
    end

    -- Embers
    local emberCount = isMobile and 28 or 60
    for i = 1, emberCount do
        local size = rng:NextInteger(3, 7)
        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Size = UDim2.fromOffset(size, size)
        dot.BackgroundColor3 = EMBER_COLORS[(i % 3) + 1]
        dot.BackgroundTransparency = 1
        dot.BorderSizePixel = 0
        dot.ZIndex = 2
        dot.Parent = dots

        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(1, 0)
        dc.Parent = dot

        task.spawn(function()
            task.wait(rng:NextNumber(0, 4))
            while dot and dot.Parent do
                local from, to = randomFlow()
                local dur = rng:NextNumber(7, 13)
                dot.Position = from
                dot.BackgroundTransparency = 1
                TweenService:Create(dot, TweenInfo.new(dur, SINE, Enum.EasingDirection.InOut), { Position = to }):Play()
                TweenService:Create(dot, TweenInfo.new(dur * 0.18, SINE), { BackgroundTransparency = 0.25 }):Play()
                task.wait(dur * 0.7)
                if not dot.Parent then break end
                TweenService:Create(dot, TweenInfo.new(dur * 0.3, SINE), { BackgroundTransparency = 1 }):Play()
                task.wait(dur * 0.3)
            end
        end)
    end

    -- Pumpkins
    local pumpkinCount = isMobile and 5 or 10
    for i = 1, pumpkinCount do
        local pumpkin = Instance.new("TextLabel")
        pumpkin.AnchorPoint = Vector2.new(0.5, 0.5)
        pumpkin.Size = UDim2.fromOffset(32, 32)
        pumpkin.BackgroundTransparency = 1
        pumpkin.Text = "🎃"
        pumpkin.TextSize = rng:NextInteger(16, 26)
        pumpkin.TextTransparency = 1
        pumpkin.ZIndex = 2
        pumpkin.Parent = dots

        local sway = rng:NextNumber(10, 18)
        pumpkin.Rotation = -sway
        loopTween(pumpkin, rng:NextNumber(2.4, 3.6), { Rotation = sway }, SINE, true)

        task.spawn(function()
            task.wait(rng:NextNumber(0, 6))
            while pumpkin and pumpkin.Parent do
                local from, to = randomFlow()
                local dur = rng:NextNumber(12, 18)
                pumpkin.Position = from
                pumpkin.TextTransparency = 1
                TweenService:Create(pumpkin, TweenInfo.new(dur, SINE, Enum.EasingDirection.InOut), { Position = to }):Play()
                TweenService:Create(pumpkin, TweenInfo.new(dur * 0.15, SINE), { TextTransparency = 0.25 }):Play()
                task.wait(dur * 0.8)
                if not pumpkin.Parent then break end
                TweenService:Create(pumpkin, TweenInfo.new(dur * 0.2, SINE), { TextTransparency = 1 }):Play()
                task.wait(dur * 0.2)
            end
        end)
    end

    -------------------------------------------------
    -- TELARAÑAS (más visibles)
    -------------------------------------------------
    local function addLine(parent, x1, y1, x2, y2, thickness)
        local dx, dy = x2 - x1, y2 - y1
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
        line.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + thickness, thickness)
        line.Rotation = math.deg(math.atan2(dy, dx))
        line.BackgroundColor3 = Color3.new(0, 0, 0)
        line.BackgroundTransparency = 0.15
        line.BorderSizePixel = 0
        line.ZIndex = 3
        line.Parent = parent

        local lc = Instance.new("UICorner")
        lc.CornerRadius = UDim.new(1, 0)
        lc.Parent = line
    end

    local function makeWeb(anchorX, anchorY, size)
        local holder = Instance.new("Frame")
        holder.Name = "ThemeWeb"
        holder.AnchorPoint = Vector2.new(anchorX, anchorY)
        holder.Position = UDim2.fromScale(anchorX, anchorY)
        holder.Size = UDim2.fromOffset(size, size)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 3
        holder.Parent = bgLayer
        table.insert(activeEffects.instances, holder)

        local sx = anchorX == 0 and 1 or -1
        local sy = anchorY == 0 and 1 or -1
        local ox = (anchorX == 0 and 0 or size) + sx * 6
        local oy = (anchorY == 0 and 0 or size) + sy * 6
        local R = size - 14

        local function pt(angle, radius)
            return ox + sx * math.cos(angle) * radius, oy + sy * math.sin(angle) * radius
        end

        local angles = {}
        for i = 0, 4 do
            angles[#angles + 1] = math.rad(i * 22.5)
        end

        for _, a in ipairs(angles) do
            local x, y = pt(a, R)
            addLine(holder, ox, oy, x, y, 2.6)
        end

        for _, f in ipairs({ 0.32, 0.62, 0.95 }) do
            for i = 1, #angles - 1 do
                local x1, y1 = pt(angles[i], R * f)
                local x2, y2 = pt(angles[i + 1], R * f)
                local mx, my = (x1 + x2) / 2, (y1 + y2) / 2
                local cx = mx + (ox - mx) * 0.32
                local cy = my + (oy - my) * 0.32

                local px, py = x1, y1
                for k = 1, 5 do
                    local t = k / 5
                    local nx = (1 - t)^2 * x1 + 2 * (1 - t) * t * cx + t^2 * x2
                    local ny = (1 - t)^2 * y1 + 2 * (1 - t) * t * cy + t^2 * y2
                    addLine(holder, px, py, nx, ny, 2.6)
                    px, py = nx, ny
                end
            end
        end
    end

    makeWeb(0, 0, 130)
    makeWeb(1, 1, 115)
end

return {
    Themes = Themes,
    GetTheme = GetTheme,
    ApplyThemeEffects = ApplyThemeEffects,
    ClearEffects = clearEffects,
}
