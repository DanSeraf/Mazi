local Maze = require "maze"
local Scanner = require "maze.solvers.astar"
local Queue = require "maze.solvers.Queue"
_ENV = nil

local available = Queue.new()

function read()
  
end

local function deadmen(maze, x, y)
  -- list of path available
  if not #available == 0 then 
    Queue.pushright(available, maze[arg[1]][arg[2]])
    if readAvailable() then io.write("Exit found!") 
    else io.write("There is no Exit!") end
  end
end

return deadmen
