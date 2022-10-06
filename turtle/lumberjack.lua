function checkBlock()
local success,data = turtle.inspectDown()
	if data.name == "minecraft:bone_block" then
         --baum erkennen
		turtle.turnRight()
        local success,data = turtle.inspect()
            if data.name == "minecraft:log" then
            turtle.dig()
            turtle.forward()
            tree = true
            height = 0
            while tree do
                if turtle.detectUp() then
                    turtle.digUp()
                    turtle.up()
                    height = height + 1
                else
                    tree = false
                end
            end
            for i=0,height do
                turtle.down()
            end
            turtle.back()
            turtle.place()
        end
        turtle.turnLeft()
        turtle.forward()
        dis = dis + 1 
	elseif data.name == "minecraft:wool" then
		turtle.turnLeft()
        turtle.turnLeft()
        for i=0,dis - 1 do
            turtle.forward()
        end
        turtle.turnLeft()
        turtle.forward()
        line = false
	else
		turtle.forward()
        dis = dis + 1  
    end
end

function changeLine()
while searching do
local success,data = turtle.inspectDown()
	if data.name == "minecraft:stained_hardened_clay" then
        turtle.turnLeft()
        searching = false
    elseif data.name == "minecraft:wool" then
        turtle.turnLeft()
        turtle.turnLeft()
        for i=0,dis2 + 1 do
            turtle.forward()
        end
        turtle.turnRight()
        farming = false
        searching = false
    else
        turtle.forward()
        dis2 = dis2 + 1
    end
end
end

function farmLine()
    line = true
    while line do
        checkBlock()
    end
end

-- Code --

while true do

while not redstone.getInput("back") or turtle.getFuelLevel()<1000 do
    os.sleep(1)
end

turtle.select(1)
turtle.suckDown()

dis2 = 0

farming = true
while farming do
dis = 0
farmLine()
searching = true
changeLine()
end


os.sleep(1)

end