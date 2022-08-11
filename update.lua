function get(file)
shell.run("rm", file)
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/main/"..file)
end

if turtle == nil then 
    if pocket then
        get("tablet.lua") --Tablet
    else
        get("server.lua") --Server
    end
else 
    get("miner.lua") --Turtle 
end

os.reboot()