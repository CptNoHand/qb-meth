local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-methcar:start')
AddEventHandler('qb-methcar:start', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(source)
	local ItemAcetone = Player.Functions.GetItemByName("acetone")
    local ItemLithium = Player.Functions.GetItemByName("lithium")
	local ItemMethlab = Player.Functions.GetItemByName("methlab")
	if ItemAcetone ~= nil and ItemLithium ~= nil and ItemMethlab ~= nil then
		if ItemAcetone.amount >= 5 and ItemLithium.amount >= 2 and ItemMethlab.amount >= 1 then	
			TriggerClientEvent("qb-methcar:startprod", _source)
			Player.Functions.RemoveItem("acetone", 5, false)
			Player.Functions.RemoveItem("lithium", 2, false)
		else
		TriggerClientEvent('QBCore:Notify', source, "Du hast nicht alle Zutaten um zu Kochen!", 'error')
		end	
	else
	TriggerClientEvent('QBCore:Notify', source, "Dir fehlen essenzielle Zutaten!", 'error')
	end	
end)

RegisterServerEvent('qb-methcar:stopf')
AddEventHandler('qb-methcar:stopf', function(id)
local _source = source
	local xPlayers = QBCore.Functions.GetPlayers()
	local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('qb-methcar:stopfreeze', xPlayers[i], id)
	end	
end)

RegisterServerEvent('qb-methcar:make')
AddEventHandler('qb-methcar:make', function(posx,posy,posz)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
	if xPlayer.Functions.GetItemByName('methlab') ~= nil then
		if xPlayer.Functions.GetItemByName('methlab').amount >= 1 then	
			local xPlayers = QBCore.Functions.GetPlayers()
			for i=1, #xPlayers, 1 do
				TriggerClientEvent('qb-methcar:smoke',xPlayers[i],posx,posy,posz, 'a') 
			end		
		else
			TriggerClientEvent('qb-methcar:stop', _source)
		end
	else
	TriggerClientEvent('QBCore:Notify', source, "Dir fehlt ein Labor!", 'error')
	end	
end)

RegisterServerEvent('qb-methcar:finish')
AddEventHandler('qb-methcar:finish', function(qualtiy)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
	local rnd = math.random(-5, 5)
	xPlayer.Functions.AddItem('Meth', math.floor(qualtiy / 2) + rnd)	
end)

RegisterServerEvent('qb-methcar:blow')
AddEventHandler('qb-methcar:blow', function(posx, posy, posz)
	local _source = source
	local xPlayers = QBCore.Functions.GetPlayers()
	local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('qb-methcar:blowup', xPlayers[i],posx, posy, posz)
	end
	xPlayer.Functions.RemoveItem('methlab', 1)
end)

