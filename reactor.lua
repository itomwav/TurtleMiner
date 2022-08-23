reactor = peripheral.wrap("right")
reactor.setActive(true)
rednet.open("back")

mode = "basic"

function receive()	
while true do
	id,message,protocol = rednet.receive()
	
	if string.find(message,"setReactorPower") then
	    content = string.sub(message,string.find(message," ")+1,string.len(message))
	    power = content
	end
		
	if string.find(message,"getReactorEnergy") then
	    rednet.send(4,energy2,protocol)
	end
		
	if string.find(message,"getReactorStats") then		
	    produced = 0
	    stop = 0
		while produced == 0 or stop > 5 do
		produced = math.floor(20*reactor.getEnergyProducedLastTick())
		stop = stop+1
		os.sleep(0.01)
		end
	    energy1 = reactor.getEnergyStored()

	    os.sleep(1)

	    energy2 = reactor.getEnergyStored()

	    energyProduced = math.floor(produced)
	    energyChanged = math.floor(energy2-energy1)
	    energyOutputted = math.floor(produced-energyChanged)
			
	    rednet.send(4,energyProduced.." "..energyChanged.." "..energyOutputted,protocol)

	end
		
end
end

function actions()

while true do
		
produced = 0
stop = 0
while produced == 0 or stop > 5 do
produced = math.floor(20*reactor.getEnergyProducedLastTick())
stop = stop+1
os.sleep(0.01)
end
energy1 = reactor.getEnergyStored()

os.sleep(1)

energy2 = reactor.getEnergyStored()

energyProduced = produced
energyChanged = energy2-energy1
energyOutputted = produced-energyChanged

if mode == "pulsing" then
    if energy2 < 3000000 and energy2 > 2000000 then
    	reactor.setAllControlRodLevels(50)	
    end
    if energy2 < 1000000 then
    	reactor.setAllControlRodLevels(100)	
    end
    if energy2 > 9900000 then
    	reactor.setAllControlRodLevels(100)
    end
    if energy2 < 9000000 and energy2 > 3500000 then 
    	if 	reactor.getFuelTemperature() >= 200 then
    		reactor.setAllControlRodLevels(reactor.getControlRodLevel(1)+1)
    	end
    	if 	reactor.getFuelTemperature() < 190 then
    		reactor.setAllControlRodLevels(reactor.getControlRodLevel(1)-1)
    	end
    end
end
		
if mode == "basic" then
    if energy2 < 2000000 then
    	reactor.setAllControlRodLevels(0)	
    end
    if energy2 > 8000000 then
    	reactor.setAllControlRodLevels(99)
    end
    if energy2 < 5500000 and energy2 > 4500000 then 
    	reactor.setAllControlRodLevels(96)	
    end
end

end
end

parallel.waitForAll(receive,actions)