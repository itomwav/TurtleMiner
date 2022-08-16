lengthX = 16
lengthY = 16

local params = {...}
if params[1] == "custom" then
	if math.abs(tonumber(params[2])) % 4 ~= 0 then
	lengthX = math.abs(tonumber(params[2]))+(4-math.abs(tonumber(params[2])) % 4)
	else 
	lengthX = math.abs(tonumber(params[2]))
	end
	if math.abs(tonumber(params[3])) % 4 ~= 0 then
	lengthY = math.abs(tonumber(params[3]))+(4-math.abs(tonumber(params[3])) % 4)
	else 
	lengthY = math.abs(tonumber(params[3]))
	end
	print("Mining: X="..lengthX)
	print("        Y="..lengthY)
	print("Fuel: "..turtle.getFuelLevel())

elseif params[1] == "remote" then
	rednet.open("right")
else
	xh = tonumber(params[1])
	yh = tonumber(params[2])
	print("Mining Chunk: "..xh.." "..yh)
	print("Fuel: "..turtle.getFuelLevel())
end

function returnTurtle(c,s,r) -- cobble, stone, rest

turtle.turnRight()
for i=1,c do
forward(go)
end
empty("stone")
for i=1,s-c do
forward("go")
end
turtle.turnRight()
empty("cobble")
turtle.turnLeft()
for i=1,r-s do
forward("go")
end
empty()
for i=1,lengthY-1-r do
forward("go")
end
turtle.turnRight()
end

function empty(type)

for i=1,14 do
	turtle.select(i)
	
	if type == "cobble" then
		local data = turtle.getItemDetail()
		if data then
		if data.name == "minecraft:cobblestone" then
		turtle.drop()
		end
		end
	else if type == "stone" then
		data = turtle.getItemDetail()
		if data then
		if data.name == "minecraft:stone" then
		turtle.dropDown()
		end
		end
	else 
		turtle.dropDown()
	end
end
end
end

function goFarm(x, y)
	if y == 0 then
	for i=1, lengthX * (x - 1) + (lengthX-1) do
	forward("go")
	end
	turtle.down()
	forward("safe")
	else
	for i=1, lengthX * x do
	forward("go")
	end
	end
	
	if y < 0 then
	turtle.turnLeft()
	for i=1, lengthY * (math.abs(y)-1) do
	forward("go")
	end
	turtle.down()
	forward("safe")
	elseif y > 0 then
	for i=1, lengthX-1 do
	forward("go")
	end
	turtle.turnRight()
	for i=1, lengthY * math.abs(y) - 1 do
	forward("go")
	end
	turtle.down()
	forward("safe")
	end
	
end

function returnFarm(x,y)
	if y == 0 then
	turtle.turnLeft()
	for i=1, lengthY-1 do
	forward("go")
	end
	turtle.turnRight()
	for i=1, lengthX * (x-1) + (lengthX-1) do
	forward("go")
	end	
	elseif y < 0 then
	turtle.turnLeft()
	forward("go")
	turtle.turnRight()
	for i=1, lengthY * math.abs(y) - 1 do
	forward("go")
	end
	turtle.turnRight()
	forward("go")
	elseif y > 0 then
	for i=1, lengthY * (math.abs(y) - 1) do
	forward("go")
	end
	turtle.turnLeft()
	for i=1, lengthX-1 do
	forward("go")
	end
	end
	if y ~= 0 then
	for i=1, lengthX * x do
	forward("go")
	end
	end
end

function startFarm()
	
	turtle.turnRight()
	turtle.turnRight()
	turtle.select(15)
	turtle.place()
	turtle.select(1)
	turtle.turnLeft()
	turtle.turnLeft()
	
end

function endFarm()
	
	turtle.turnRight()
	forward("mine")
	for i=1,lengthY-2 do
	forward("go")
	end
	turtle.turnLeft()
	fillChest()

--	turtle.dig()
--	forward("go")
--	turtle.up()

turtle.up()
forward("go")

end


function farm(invert)

	k=0
	
for i=1,lengthY/4-1 do
	farmLineTorch(invert)
	endLine()
	farmLine()
	endLine()
end

	farmLineTorch(invert)
	endLine()
	farmLine()
	
end

function farmLine()
	
for i=1,lengthX-1 do --eigentliche länge 15
	forward("mine")
end

	turtle.turnRight()
	forward("mine")
	turtle.turnRight()

for i=1,lengthX-1 do
	forward("mine")
end

end

function farmLineTorch(invert)
	
if invert then
for i=1,lengthX-1 do --eigentliche länge 15
	if i % 4 == 0 then -- i == 4 or i == 8 or i == 12 or i == 16
	forward("torch")
	else 
	forward("mine")
	end
end
else
for i=1,lengthX-1 do --eigentliche länge 15
	if (i+3) % 4 == 0 then -- i == 1 or i == 5 or i == 9 or i == 13
	forward("torch")
	else 
	forward("mine")
	end
end
end

	turtle.turnRight()
	forward("mine")
	turtle.turnRight()

for i=1,lengthX-1 do
	forward("mine")
end
	

end

function endLine()
	k = k + 2
	turtle.turnRight()
for i=1,k - 1 do
	forward("go")	
end
	turtle.turnLeft()
		
fillChest()
		
	turtle.turnLeft()
for i=1,k - 1 do
	forward("go")
end
	forward("mine")
	turtle.turnLeft()
end

function fillChest()
for i=1,14 do
	turtle.select(i)
	turtle.drop()
end
	turtle.select(1)
end

function forward(mode) --safe, mine, torch
 going = true
 if mode == "mine" or mode == "torch" then
 turtle.digUp()
 turtle.digDown()
 if mode == "torch" then
	turtle.select(16)
	turtle.placeDown()
	turtle.select(1)
 end
end
 while going do
  if turtle.forward() then
   going = false
  else 
   if mode == "safe" or mode == "mine" or mode == "torch" then
	turtle.dig()
   end
  end
 end
end

if params[1] == "remote" then
while true do 

	id,message,protocol = rednet.receive("miner")

    xh = tonumber(string.sub(message,0,string.find(message," ")-1))
    yh = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))

	rednet.send(4,(xh+1).." "..(yh),"mining")

	goFarm(xh,yh)
	startFarm()
	farm(yh < 0)
	endFarm()
	returnFarm(xh,yh)
	returnTurtle(1,11,13)

	rednet.send(4,(xh+1).." "..(yh),"mined")
	
	os.sleep(1)

end
end

if params[1] == "custom" then

	startFarm()
	farm(false)
	endFarm()

else 

	goFarm(xh,yh)
	startFarm()
	farm(yh < 0)
	endFarm()
	returnFarm(xh,yh)
	returnTurtle(1,11,13)

end