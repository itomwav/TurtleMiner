while true do

while not redstone.getInput("back") do
    os.sleep(1)
end

dis = 0

farming = true
while farming do
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
        end
        turtle.turnLeft()
        turtle.forward()
        dis = dis + 1 
	elseif data.name == "minecraft:wool" then
		turtle.turnRight()
        turtle.turnRight()
        for i=0,dis do
            turtle.forward()
        end
        turtle.turnRight()
        turtle.turnRight()
        farming = false
	else
		turtle.forward()
        dis = dis + 1  
    end
    end
end