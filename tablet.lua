rednet.open("back")

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
		
if status == "nil" then
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
	
	term.clear()
	for i=2,25 do
	for j=3,19 do
	
		drawPixel(i,j)
		
	end
	end

end

function drawMap()

mode = "map"
	
updateScreen()

end

drawMap()


while true do 

	local event,button,x,y = os.pullEvent("mouse_click")
	
	if mode == "map" then 
		
		if x>=2 and x<=25 and y>=3 and y<=19 then
			
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

os.sleep(20)