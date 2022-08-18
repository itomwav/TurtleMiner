rednet.open("back")

function printHeading()
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.setCursorPos(2,2)
term.clearLine()
paintutils.drawLine(2,2,23,2,colors.white)
term.setCursorPos(3,2)
print(" "..mode.." ")
term.setCursorPos(25,2)
term.setBackgroundColor(colors.red)
term.setTextColor(colors.white)
print("X")

end

function customButton(content,y)
term.setCursorPos(2,y)
term.setBackgroundColor(colors.gray)
term.setTextColor(colors.white)
term.clearLine()
term.setCursorPos(2,y)
print(content)
buttons[y] = content
end

function drawPixel(xx,yy)


if xx-1 > #map then
	status = nil
else -- wenn es im möglichen Bereich ist:
	if yy-11 == 0 then
		if string.find(tostring(map[xx-1]),"table") then
		status = "mined"
		else
		status = map[xx-1]
		end
	else
		status = map[xx-1][yy-11]
	end
end
		
if status == nil then
	paintutils.drawPixel(xx,yy,colors.gray)
end
if status == "mining" then
	paintutils.drawPixel(xx,yy,colors.orange)
end
if status == "mined" then
	paintutils.drawPixel(xx,yy,colors.green)
end	
end

function updateScreen()

	rednet.send(4,"complete","info")
	id,map,protocol = rednet.receive("infoBack")
	
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	for i=2,25 do
	for j=4,19 do
	
		drawPixel(i,j)
		
	end
	end

end

mode = "menu"
loop = true
buttons = {}

while true do

while loop do 

	buttons = {}
	printHeading()

	if mode == "menu" then
		customButton("map",4)
		customButton("table",6)
	end

	if mode == "map" then
	updateScreen()
	end

	local event,button,x,y = os.pullEvent("mouse_click")

	-- Allgemeine Drücker:
	if x==25 and y==2 then
	mode = menu
	loop = false
	end
	if buttons[y] then
	mode = buttons[y]
	end

	-- Bestimmte Drücker:

	if mode == "map" then 
		
		if x>=2 and x<=25 and y>=4 and y<=19 then
			
			if button == 1 then
			    rednet.send(4,(x-1).." "..(y-11),"req")
			    os.sleep(0.5)
			    updateScreen()
			elseif button == 2 then
			    rednet.send(4,(x-1).." "..(y-11),"mined")
			    os.sleep(0.5)
			    updateScreen()
			end
				
		end
			
	end
	
end

end

os.sleep(20)