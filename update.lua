function get(file)
shell.run("rm", file)
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/main/"..file)
end

get("miner.lua")