function get(file)
shell.run("rm", file)
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/main/"..file)
end

if turtle then 
    get("miner.lua") --Turtle 
elseif pocket then
    get("tablet.lua") --Tablet
else 
    get("server.lua") --Server
end

os.reboot()