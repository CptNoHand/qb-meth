local QBCore = exports['qb-core']:GetCoreObject()

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local started = false
local progress = 0
local CurrentVehicle 
local pause = false
local quality = 0
local LastCar

RegisterNetEvent('qb-methcar:stop')
AddEventHandler('qb-methcar:stop', function()
	started = false
	QBCore.Functions.Notify("Produktion gestoppt...", "error")
	FreezeEntityPosition(LastCar, false)
end)

RegisterNetEvent('qb-methcar:stopfreeze')
AddEventHandler('qb-methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)

RegisterNetEvent('qb-methcar:notify')
AddEventHandler('qb-methcar:notify', function(message)
	QBCore.Functions.Notify(message)
end)

RegisterNetEvent('qb-methcar:startprod')
AddEventHandler('qb-methcar:startprod', function()
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	QBCore.Functions.Notify("Produktion gestartet", "success")	
	SetPedIntoVehicle((PlayerPedId()), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('qb-methcar:smoke')
AddEventHandler('qb-methcar:smoke', function(posx, posy, posz, bool)
	if bool == 'a' then
		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_bzgas_smoke", posx, posy, posz + 1.6, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.9)
		Citizen.Wait(60000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end
end)

-------------------------------------------------------EVENTS NEGATIVE
RegisterNetEvent('qb-methcar:boom', function()
	playerPed = (PlayerPedId())
	local pos = GetEntityCoords((PlayerPedId()))
	pause = false
	Citizen.Wait(500)
	started = false
	Citizen.Wait(500)
	CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
	TriggerServerEvent('qb-methcar:blow', pos.x, pos.y, pos.z)
	TriggerEvent('qb-methcar:stop')
	FreezeEntityPosition(LastCar,false)
end)

RegisterNetEvent('qb-methcar:blowup')
AddEventHandler('qb-methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2, 15, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)	
end)

RegisterNetEvent('qb-methcar:drugged')
AddEventHandler('qb-methcar:drugged', function()
	local pos = GetEntityCoords((PlayerPedId()))
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur((PlayerPedId()), true)
	SetPedMovementClipset((PlayerPedId()), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk((PlayerPedId()), true)
	quality = quality - 2
	pause = false
	Citizen.Wait(90000)
	ClearTimecycleModifier()
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:q-1police', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "error")
	quality = quality - 1
	pause = false
	local data = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'}, 
        coords = data.coords,
        title = '1-5 - Possible Drugs',
        message = 'A '..data.sex..' someone smells something strange '..data.street, 
        flash = 0,
        unique_id = tostring(math.random(0000000,9999999)),
        blip = {
            sprite = 431, 
            scale = 1.2, 
            colour = 3,
            flashes = false, 
            text = '911 - Possible Drugs',
            time = (5*60*1000),
            sound = 1,
        }
    })
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:q-1', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "error")
	quality = quality - 1
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:q-3', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "error")
	quality = quality - 2
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:q-5', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "error")
	quality = quality - 3
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

-------------------------------------------------------EVENTS POSITIVE
RegisterNetEvent('qb-methcar:q2', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "success")
	quality = quality + 1
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:q3', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "success")
	quality = quality + 2
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:q5', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "success")
	quality = quality + 3
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

RegisterNetEvent('qb-methcar:gasmask', function(data)
	local pos = GetEntityCoords((PlayerPedId()))
	QBCore.Functions.Notify(data.message, "success")
	SetPedPropIndex(playerPed, 1, 26, 7, true)
	quality = quality + 1
	pause = false
	TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
end)

-------------------------------------------------------THREAD
Citizen.CreateThread(function(data)
	while true do
		Citizen.Wait(3)		
		playerPed = (PlayerPedId())
		local pos = GetEntityCoords((PlayerPedId()))
		if IsPedInAnyVehicle(playerPed) then	
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())
			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)			
			if modelName == 'JOURNEY' and car then				
					if GetPedInVehicleSeat(car, -0) == playerPed then
							DrawText3D(pos.x, pos.y, pos.z, '~g~E~w~ zum (Kochen)')
							if IsControlJustReleased(0, Keys['E']) then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('qb-methcar:start')
									TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
									progress = 0
									pause = false
									quality = 0		
								else
									QBCore.Functions.Notify('Diese Küche wird bereits Benutzt..')
								end
							end
					end		
			end			
		else	
				if started then
					started = false
					TriggerEvent('qb-methcar:stop')
					FreezeEntityPosition(LastCar,false)
				end
		end		
		if started == true then			
			if progress < 96 then
				Citizen.Wait(500)
				-- TriggerServerEvent('qb-methcar:make', pos.x,pos.y,pos.z)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					quality = quality + 1
					QBCore.Functions.Notify('Meth Produktion: ' .. progress .. '%')
					Citizen.Wait(4000)
				end
				--
				--   EVENT 1
				--
				if progress > 9 and progress < 11 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Ein Rohr ist undicht ... was jetzt?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Mit Klebeband reparieren",
							params = {
								event = "qb-methcar:q-3",
								args = {
									message = "Ich denke, das sollte halten?!"
								}
							}
						},
						{
							header = "🔴 Lass es so!",
							params = {
								event = "qb-methcar:boom"
							}
						},
						{
							header = "🔴 Ersetzte das Rohr",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "Ersetzen war die beste Entscheidung!"
								}
							}
						},
					})
				end
				--
				--   EVENT 2
				--
				if progress > 19 and progress < 21 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Du hast etwas Aceton verschüttet .. was jetzt?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Öffne ein Fenster",
							params = {
								event = "qb-methcar:q-1police",
								args = {
									message = "Den Geruch bekommen viele Leute mit..."
								}
							}
						},
						{
							header = "🔴 Atme es weg..",
							params = {
								event = "qb-methcar:drugged"
							}
						},
						{
							header = "🔴 Setze eine Gasmaske auf! ",
							params = {
								event = "qb-methcar:gasmask",
								args = {
									message = "Eine Gute Entscheidung!"
								}
							}
						},
					})
				end
				--
				--   EVENT 3
				--
				if progress > 29 and progress < 31 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Meth verstopft zu schnell, was ist zu tun?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Erhöhe die Temperatur",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "Eine höhere Temperatur sorgt füre eine gute Ballance!"
								}
							}
						},
						{
							header = "🔴 Erhöhe den Druck",
							params = {
								event = "qb-methcar:q-3",
								args = {
									message = "Der Druck schwankt sehr.."
								}
							}
						},
						{
							header = "🔴 Verringere den Druck",
							params = {
								event = "qb-methcar:q-5",
								args = {
									message = "Das war das Schlimmste was du tun hättest können!"
								}
							}
						},
					})
				end
				--
				--   EVENT 4
				--
				if progress > 39 and progress < 41 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Du hast zuviel Aceton zugegeben, was ist zu tun?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Mache nix..",
							params = {
								event = "qb-methcar:q-5",
								args = {
									message = "Das Meth riecht nach purem Aceton!"
								}
							}
						},
						{
							header = "🔴 Benutze einen Strohhalm um es abzusaugen",
							params = {
								event = "qb-methcar:drugged"
							}
						},
						{
							header = "🔴Füge Lithium zum ausgleichen hinzu",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "Clevere Lösung"
								}
							}
						},
					})
				end
				--
				--   EVENT 5
				--
				if progress > 49 and progress < 51 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Oh das ist etwas Blauer Farbstoff, soll ich ihn Benutzen?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Füge es zum Mix hinzu!",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "Sehr gut, die Leute werden es LIeben!"
								}
							}
						},
						{
							header = "🔴 Pack es zur Seite",
							params = {
								event = "qb-methcar:q-1",
								args = {
									message = "Du bist nicht sehr Kreativ oder?"
								}
							}
						},
					})
				end
				--
				--   EVENT 6
				--
				if progress > 59 and progress < 61 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Der Filter ist voll, was nun?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Blase ihn mit dem Kompressor aus",
							params = {
								event = "qb-methcar:q-5",
								args = {
									message = "Du hast das Produkt Versaut!"
								}
							}
						},
						{
							header = "🔴 Ersetzte den Filter!",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "Ersetzen war die Beste Lösung!"
								}
							}
						},
						{
							header = "🔴 Säubere ihn mit einem Pinsel",
							params = {
								event = "qb-methcar:q-1",
								args = {
									message = "Es hilft aber nicht gerade viel"
								}
							}
						},
					})
				end
				--
				--   EVENT 7
				--
				if progress > 69 and progress < 71 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Du hast etwas Aceton verschüttet .. was jetzt?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Atme es weg..",
							params = {
								event = "qb-methcar:drugged"
							}
						},
						{
							header = "🔴 Setze eine Gasmaske auf",
							params = {
								event = "qb-methcar:gasmask",
								args = {
									message = "Gute Entscheidung!"
								}
							}
						},
						{
							header = "🔴 Öffne ein Fenster",
							params = {
								event = "qb-methcar:q-1police",
								args = {
									message = "Den Geruch bekommen viele Leute mit..."
								}
							}
						},
					})
				end
				--
				--   EVENT 8
				--
				if progress > 79 and progress < 81 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Ein Rohr ist undicht ... was jetzt?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Lass es so!",
							params = {
								event = "qb-methcar:boom"
							}
						},
						{
							header = "🔴 Mit Klebeband reparieren",
							params = {
								event = "qb-methcar:q-3",
								args = {
									message = "That kinda fixed it, i think?!"
								}
							}
						},
						{
							header = "🔴 Ersetzte das Rohr",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "Replacing was the best solution!"
								}
							}
						},
					})
				end
				--
				--   EVENT 9
				--
				if progress > 89 and progress < 91 then
					pause = true
					exports['qb-menu']:openMenu({
						{
							header = "Du musst wirklich scheißen! Was machst du jetzt?",
							txt = "Wähle deine Antwort. Fortschritt: " .. progress .. "%",
							isMenuHeader = true,
						},
						{
							header = "🔴 Einfach abkneifen!",
							params = {
								event = "qb-methcar:q5",
								args = {
									message = "SUPER JOB, ich bin Stolz!"
								}
							}
						},
						{
							header = "🔴 Geh raus zum scheißen!",
							params = {
								event = "qb-methcar:q-1police",
								args = {
									message = "Jemand hat Ihre verdächtige Arbeit entdeckt!"
								}
							}
						},
						{
							header = "🔴 Scheiße drinnen!",
							params = {
								event = "qb-methcar:q-5",
								args = {
									message = "Garnicht Gut! Alles riecht nach Scheiße!"
								}
							}
						},
					})
				end
			else
				TriggerEvent('qb-methcar:stop')
				progress = 100
				QBCore.Functions.Notify('Meth Produktion: ' .. progress .. '%')
				QBCore.Functions.Notify("Fertig!!", "success")
				TriggerServerEvent('qb-methcar:finish', quality)
				SetPedPropIndex(playerPed, 1, 0, 0, true)
				FreezeEntityPosition(LastCar, false)
			end				
		end		
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle((PlayerPedId())) then
			else
				if started then
					started = false
					TriggerEvent('qb-methcar:stop')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end
end)




