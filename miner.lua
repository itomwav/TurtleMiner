xh,yh = 0,0

function goFarm(x, y)
	if y == 0 then
	for i=1, 16 * (x - 1) + 15 do
	turtle.forward()
	end
	turtle.down()
	digStraight(true)
	else
	for i=1, 16 * x do
	turtle.forward()
	end
	end
	
	if y < 0 then
	turtle.turnLeft()
	for i=1, 16 * (math.abs(y)-1) do
	turtle.forward()
	print(i)
	end
	turtle.down()
	digStraight(true)
	elseif y > 0 then
	for i=1, 15 do
	turtle.forward()
	end
	turtle.turnRight()
	for i=1, 16 * math.abs(y) - 1 do
	turtle.forward()
	end
	turtle.down()
	digStraight(true)
	end
	
end

function returnFarm(x,y)
	if y == 0 then
	turtle.turnLeft()
	for i=1, 15 do
	turtle.forward()
	end
	turtle.turnRight()
	for i=1, 16 * (x-1) + 15 do
	turtle.forward()
	end	
	elseif y < 0 then
	for i=1, 16 * math.abs(y) - 1 do
	turtle.forward()
	print(i)
	end
	turtle.turnRight()
	elseif y > 0 then
	for i=1, 16 * (math.abs(y) - 1) do
	turtle.forward()
	end
	turtle.turnLeft()
	for i=1, 15 do
	turtle.forward()
	end
	end
	if y ~= 0 then
	for i=1, 16 * x do
	turtle.forward()
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
	digStraight()
	for i=1,14 do
	turtle.forward()
	end
	turtle.turnLeft()
	fillChest()
	turtle.dig()
	turtle.forward()
	turtle.up()
	
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


------------------------------------------------------
function farmLine()
	
for i=1,15 do --eigentliche länge 15
	digStraight()
end

	turtle.turnRight()
	digStraight()
	turtle.turnRight()

for i=1,15 do
	digStraight()
end
	

end

function farmLineTorch(invert)

	
if invert then
for i=1,15 do --eigentliche länge 15
	if i == 4 or i == 8 or i == 12 or i == 16 then
	digStraightTorch()
	else 
	digStraight()
	end
end
else
for i=1,15 do --eigentliche länge 15
	if i == 1 or i == 5 or i == 9 or i == 13 then
	digStraightTorch()
	else 
	digStraight()
	end
end
end

	turtle.turnRight()
	digStraight()
	turtle.turnRight()

for i=1,15 do
	digStraight()
end
	

end

function endLine()
	print("endLine")
	k = k + 2
	turtle.turnRight()
for i=1,k - 1 do
	turtle.forward()	
end
	turtle.turnLeft()
		
fillChest()
		
	turtle.turnLeft()
for i=1,k - 1 do
	turtle.forward()
end
	digStraight()
	turtle.turnLeft()
end

function fillChest()
for i=3,16 do
	turtle.select(i)
	turtle.drop()
end
	turtle.select(1)
end

function digStraight(safe)
 going = true
 if not safe then
 turtle.digUp()
 turtle.digDown()
 end
 while going do
  if turtle.forward() then
   going = false
  else 
   turtle.dig()
  end
 end
end
				
function digStraightTorch()
 going = true
 turtle.digUp()
 turtle.digDown()
 turtle.select(2)
 turtle.placeDown()
 turtle.select(1)
 while going do
  if turtle.forward() then
   going = false
  else 
   turtle.dig()
  end
 end
end

goFarm(xh,yh)
startFarm()
farm(yh < 0)
endFarm()
returnFarm(xh,yh)