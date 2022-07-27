function get(file)
shell.run("rm", file..".lua")
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/main/"..file)
end

get("miner.lua")