local Maze = require "maze"
_ENV = nil

function WallBlocker(maze, xc, yc)
  if yc > maze:width() or xc > maze:height() then return end
  if yc == maze:width() and xc == maze:height() then assert(maze[xc][yc].south:IsExit()) maze[xc][yc].visited = true return end
  io.write('scanning -> ')
  io.write(xc..','..yc..'\n')
  node = maze[xc][yc]
  directions = maze.directions
  walls = maze.getWalls(node)

  for direction, wall in pairs(walls) do
    new_x = xc+directions[direction]['y']
    new_y = yc+directions[direction]['x']
    io.write('node'..xc..','..yc..' ['..direction..'] -> ')
    io.write(new_x..','..new_y..'\n')
    print(wall:IsOpened())
    if wall:IsOpened() and not wall:IsBlocked() then
      if wall:IsVisited() then
        wall:SetBlocked()
        WallBlocker(maze, new_x, new_y)
      end
      wall:SetVisited()
      node.visited = true
      WallBlocker(maze, new_x, new_y)
    end
  end
end

return WallBlocker
