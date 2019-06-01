local Maze = require "maze"
local priorityqueue = require "maze.solvers.PriorityQueue"
_ENV = nil

local function heuristics(mode)
  if mode == 'manhattan' then return manhattanDistance
  elseif mode == 'diagonal' then return diagonalDistance
  end
end

--[[ scan to search adjacent nodes ]]--
function nodeScan(maze, node)
  local neighbornodes = {}
  local directions = maze.directions
  x, y = maze:GetCoord(node)
  walls = maze.getWalls(node)
  
  for direction, wall in pairs(walls) do
    if wall:IsOpened() then
      print('door found: ' .. direction)
      table.insert(neighbornodes, maze[y + directions[direction]['y']][x + directions[direction]['x']])
    end
  end

  print("-------neighbornodes---------")
  for _, n in pairs(neighbornodes) do
    print(maze:GetCoord(n))
  end
  print("-----------------------------")
  
  return neighbornodes
end

--[[ diagonal heuristic ]]--
function diagonalDistance(...)
  local arg = {...}

  assert(#arg == 2)

  x = arg[1]
  y = arg[2]
  
  return 100 - math.sqrt(((x-17)^2)+((y-19)^2))
end

function manhattanDistance(...)
  local arg = {...}

  assert(#arg == 2)

  x = arg[1]
  y = arg[2]

  return 100 - math.abs(x-17) + math.abs(y-19)
end

function nodeInside(set, node)
  for _, el in pairs(set) do
    if el == node then return true end
  end

  return false
end

function generateFullPath(cameFrom, maze)
  for _, n in pairs(cameFrom) do
    n.visited = true
  end

  return maze
end

function astar(maze, x, y, mode)
  heuristic = heuristics(mode)
  run(maze, x, y, heuristic)
end

function run(maze, x, y, heuristic)
  local open = priorityqueue.new()
  local closed = {}
  local cameFrom = {}
  local gScore = {}
  local fScore = {}
  
  maze[x][y].visited = true
  gScore[maze[x][y]] = 0
  fScore[maze[x][y]] = heuristic(x, y)
  open:Add(maze[x][y], heuristic(x, y))
  
  while not open:Empty() do
    current, _ = open:Pop()
    print('analyzing node: ')
    print(maze:GetCoord(current)) 

    if current.south:IsExit() then current.visited = true return generateFullPath(cameFrom, maze) end

    table.insert(closed, current)
    
    for _, node in pairs(nodeScan(maze, current)) do
      
      if nodeInside(closed, node) then goto continue end

      gScore_att = gScore[current] + 1
      
      if not open:Search(node) then open:Add(node, heuristic(maze:GetCoord(node))) 
      elseif gScore_att >= gScore[node] then goto continue
      end
      
      cameFrom[node] = current
      gScore[node] = gScore[current]
      fScore[node] = gScore[node] + heuristic(maze:GetCoord(node))

      ::continue::
    end
  end

end

return astar
