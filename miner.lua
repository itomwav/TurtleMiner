local params = {...}
xh = tonumber(params[1])
yh = tonumber(params[2])

function goFarm(x, y)
	if y == 0 then
	for i=1, 16 * (x - 1) + 15 do
	forward("go")
	end
	turtle.down()
	forward("safe")
	else
	for i=1, 16 * x do
	forward("go")
	end
	end
	
	if y < 0 then
	turtle.turnLeft()
	for i=1, 16 * (math.abs(y)-1) do
	forward("go")
	print(i)
	end
	turtle.down()
	forward("safe")
	elseif y > 0 then
	for i=1, 15 do
	forward("go")
	end
	turtle.turnRight()
	for i=1, 16 * math.abs(y) - 1 do
	forward("go")
	end
	turtle.down()
	forward("safe")
	end
	
end

function returnFarm(x,y)
	if y == 0 then
	turtle.turnLeft()
	for i=1, 15 do
	forward("go")
	end
	turtle.turnRight()
	for i=1, 16 * (x-1) + 15 do
	forward("go")
	end	
	elseif y < 0 then
	for i=1, 16 * math.abs(y) - 1 do
	forward("go")
	print(i)
	end
	turtle.turnRight()
	elseif y > 0 then
	for i=1, 16 * (math.abs(y) - 1) do
	forward("go")
	end
	turtle.turnLeft()
	for i=1, 15 do
	forward("go")
	end
	end
	if y ~= 0 then
	for i=1, 16 * x do
	forward("go")
	end
	end
end

function startFarm()
	
	turtle.select(1)
	turtle.turnRight()
	turtle.turnRight()
	turtle.place()
	turtle.turnLeft()
	turtle.turnLeft()
	
end

function endFarm()
	
	turtle.turnRight()
	forward("mine")
	for i=1,14 do
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
	
for i=1,3 do
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
	
for i=1,15 do --eigentliche länge 15
	forward("mine")
end

	turtle.turnRight()
	forward("mine")
	turtle.turnRight()

for i=1,15 do
	forward("mine")
end

end

function farmLineTorch(invert)
	
if invert then
for i=1,15 do --eigentliche länge 15
	if i == 4 or i == 8 or i == 12 or i == 16 then
	forward("torch")
	else 
	forward("mine")
	end
end
else
for i=1,15 do --eigentliche länge 15
	if i == 1 or i == 5 or i == 9 or i == 13 then
	forward("torch")
	else 
	forward("mine")
	end
end
end

	turtle.turnRight()
	forward("mine")
	turtle.turnRight()

for i=1,15 do
	forward("mine")
end
	

end

function endLine()
	print("endLine")
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
for i=3,16 do
	turtle.select(i)
	turtle.drop()
end
	turtle.select(1)
end

function forward(mode) --safe, mine, torch
 going = true
 if mode == mine or mode == torch then
 turtle.digUp()
 turtle.digDown()
 if mode == torch then
	turtle.select(2)
	turtle.placeDown()
	turtle.select(1)
 end
end
 while going do
  if turtle.forward() then
   going = false
  else 
   if mode == safe or mode == mine or mode == torch then
	turtle.dig()
   end
  end
 end
end
				
goFarm(xh,yh)
startFarm()
farm(yh < 0)
endFarm()
returnFarm(xh,yh)