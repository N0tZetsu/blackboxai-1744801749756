-- Variable global para controlar el estado de la eliminación de NPCs
local npcRemovalEnabled = true

-- Función para actualizar la UI
local function updateUI()
    SendNUIMessage({
        type = "updateStatus",
        active = npcRemovalEnabled
    })
end

-- Bucle principal para remover NPCs
Citizen.CreateThread(function()
    while true do
        if npcRemovalEnabled then
            -- Desactivar la generación de NPCs
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            
            -- Desactivar la generación de vehículos
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            
            -- Eliminar NPCs y vehículos cercanos (opcional)
            local playerPed = PlayerPedId()
            if DoesEntityExist(playerPed) then
                local pos = GetEntityCoords(playerPed)
                ClearAreaOfPeds(pos.x, pos.y, pos.z, 1000.0, 1)
                ClearAreaOfVehicles(pos.x, pos.y, pos.z, 1000.0, false, false, false, false, false)
            end
        end
        Citizen.Wait(0) -- Ejecutar cada frame
    end
end)

-- Registrar comando para alternar la eliminación de NPCs
RegisterCommand('toggleNPC', function()
    npcRemovalEnabled = not npcRemovalEnabled
    local status = npcRemovalEnabled and "activada" or "desactivada"
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        multiline = false,
        args = {"Sistema", "Eliminación de NPCs " .. status}
    })
    updateUI()
end, false)

-- Inicializar UI cuando el recurso se inicia
Citizen.CreateThread(function()
    updateUI()
end)
