-- Função para criar um "Box" em volta de um objeto com cor
function CreateESPBox(obj, color)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = obj
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.Parent = obj
end

-- Função para criar um "Label" de nome em cima do objeto
function CreateNameLabel(obj, nameText)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = obj
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0) -- Eleva o nome um pouco acima do objeto
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = nameText
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1) -- Cor branca para o texto
    textLabel.TextScaled = true

    billboard.Parent = obj
end

-- Função para verificar a distância entre dois objetos
function GetDistance(part1, part2)
    if part1 and part2 then
        return (part1.Position - part2.Position).Magnitude
    end
    return math.huge
end

-- Função para aplicar ESP e Labels em todas as entidades, itens e portas
function ApplyESP()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    for _, obj in pairs(game.Workspace:GetChildren()) do
        -- ESP e Label para todas as entidades (monstros, por exemplo)
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            CreateESPBox(obj, Color3.new(1, 0, 0)) -- Cor vermelha para entidades
            CreateNameLabel(obj, obj.Name) -- Nome da entidade
        end
        
        -- ESP e Label para todos os itens
        if obj:IsA("Tool") or obj:IsA("Part") and obj:FindFirstChild("TouchInterest") then
            CreateESPBox(obj, Color3.new(1, 1, 0)) -- Cor amarela para itens
            CreateNameLabel(obj, obj.Name) -- Nome do item
        end

        -- ESP e Label para portas, mas somente se estiverem próximas (menos de 30 unidades)
        if obj:IsA("Model") and obj:FindFirstChild("Door") then
            local distance = GetDistance(rootPart, obj:FindFirstChild("Door").Position)
            if distance < 30 then -- Distância de 30 unidades
                CreateESPBox(obj, Color3.new(0, 1, 0)) -- Cor verde para portas próximas
                CreateNameLabel(obj, "Porta") -- Nome da porta
            end
        end
    end
end

-- Chamando a função de ESP repetidamente para novos objetos
while true do
    ApplyESP()
    wait(1) -- Intervalo de 1 segundo entre as atualizações
end
