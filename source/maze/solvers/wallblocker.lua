local Maze = require "maze"
_ENV = nil

wasHere = { }
path = { }

function WallBlocker(maze, x, y)
    res = recSolve(maze, x, y)
    if not res then io.write('SOLUTION NOT POSSIBLE!')
    else 
      io.write('SOLUTION FOUND') 
      for _, node in pairs(path) do
        node.visited = true
      end
    end
end

function wasThere(what)
  for _, v in pairs(wasHere) do
    if v == what then return true
    end
  end
  return false
end

function recSolve(maze, xc, yc)
  io.write('scanning -> ')
  io.write(xc..','..yc..'\n')

  node = maze[xc][yc]
  directions = maze.directions
  walls = maze.walls(node)

  if wasThere(node) then return false end 

  if yc == maze:width() and xc == maze:height() then 
      assert(node.south:IsExit()) 
      node.visited = true 
      return true 
  end
  
  table.insert(wasHere, node)

  for direction, wall in pairs(walls) do
    new_x = xc+directions[direction]['y']
    new_y = yc+directions[direction]['x']

    io.write('node'..xc..','..yc..' ['..direction..'] -> ')
    io.write(new_x..','..new_y..'\n')

    if wall:IsOpened() and recSolve(maze, new_x, new_y) then 
      table.insert(path, maze[xc][yc])
      return true
    end
  end
end

return WallBlocker
