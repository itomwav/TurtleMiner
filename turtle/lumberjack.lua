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
        for i=0,dis do
            turtle.forward()
        end
        turtle.turnLeft()
        turtle.turnLeft()
        line = false
	else
		turtle.forward()
        dis = dis + 1  
    end
end

function changeLine()
local success,data = turtle.inspectDown()
	if data.name == "minecraft:stained_hardened_clay" then
        turtle.turnLeft()
    elseif data.name == "minecraft:wool" then
        turtle.turnLeft()
        turtle.turnLeft()
        for i=0,dis2 do
            turtle.forward()
        end
        turtle.turnRight()
        farming = false
    else
        turtle.forward()
        dis2 = dis2 + 1
    end
end

function farmLine()
    line = true
    while line do
        checkBlock()
    end

    for dis do 
        checkBlock()
    end
    turtle.turnLeft()
    turtle.forward()
end

-- Code --

while true do

while not redstone.getInput("back") do
    os.sleep(1)
end

dis = 0

farming = true
while farming do
farmLine()
changeLine()
end


os.sleep(1)

end