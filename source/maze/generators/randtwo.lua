local random = math.random
local Maze = require "maze"
_ENV = nil

local function randtwo(maze)
  maze:ResetDoors(true)
  local remaining = maze:width() * maze:height() - 1
  
  local x, y = random(maze:width()), random(maze:height())
  maze[y][x].visited = true

  while remaining ~= 0 do
    local directions = maze:DirectionsFrom(x, y)
    local dirn = directions[random(#directions)]
    
    if random(10) < 6 then
        if not maze[dirn.y][dirn.x].visited then
            maze[dirn.y][dirn.x].visited = true
            maze[y][x][dirn.name]:Open()
            remaining = remaining - 1
        end
    end
    
    x, y = dirn.x, dirn.y
  end
  
  maze:ResetVisited()
end

return randtwo
