local Maze = require "maze"
_ENV = nil

function WallBlocker(maze, x, y)
    wasHere = { }
    path = { }
    if recSolve(maze, x, y, path) then
      io.write('Exit found!\n') 
      return reversePath(path,maze), true
    else print('Exit not found!') return path, false end
end

function reversePath(path, maze)
  new_path = { }
  for i = #path, 1, -1 do
    table.insert(new_path, path[i])
  end
      print(#path)

  return new_path
end

function wasThere(what)
  for _, v in pairs(wasHere) do
    if v == what then return true
    end
  end
  return false
end

function recSolve(maze, xc, yc, path)
  node = maze[xc][yc]
  directions = maze.directions
  walls = maze.walls(node)

  if wasThere(node) then return false end 

  if yc == maze:width() and xc == maze:height() then 
      assert(node.south:IsExit()) 
      table.insert(path, node)
      return true 
  end
  
  table.insert(wasHere, node)

  for direction, wall in pairs(walls) do
    new_x = xc+directions[direction]['y']
    new_y = yc+directions[direction]['x']

    if wall:IsOpened() and recSolve(maze, new_x, new_y, path) then 
      table.insert(path, maze[xc][yc])
      return true
    end
  end
end

return WallBlocker
