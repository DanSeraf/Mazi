local Maze = require "maze"
_ENV = nil

function sleep(n)
    os.execute("sleep " .. tonumber(n))
end

function WallBlocker(maze, xc, yc)
  print("scanning node: { "..xc..","..yc.." }")
  if xc == maze:width() 
    and yc == maze:height() 
    and maze[xc][yc].south:IsExit() then
    return 
  end

  if maze[xc][yc].east:IsOpened() and maze[xc][yc].east:IsBlocked() == false then
    if maze[xc][yc].east:IsVisited() then
      maze[xc][yc].east:SetBlocked()
      print('blocking: ('..xc..','..yc..')')
    end
    print( 'East node found: { '..xc..','..yc..' }' )
    maze[xc][yc].east:SetVisited()
    maze[xc][yc].visited = true
    WallBlocker(maze, xc, yc+1)
  end

  if maze[xc][yc].south:IsOpened() and maze[xc][yc].south:IsBlocked() == false then
    if maze[xc][yc].south:IsExit() then 
      maze[xc][yc].visited = true
      return 
    end
    if maze[xc][yc].south:IsVisited() then
      maze[xc][yc].south:SetBlocked()
    end
    print( 'South node found: { '..xc..','..yc..' }' )
    maze[xc][yc].south:SetVisited()
    maze[xc][yc].visited = true
    WallBlocker(maze, xc+1, yc)
  end

  if maze[xc][yc].west:IsOpened() and maze[xc][yc].west:IsBlocked() == false then
    if maze[xc][yc].west:IsVisited() then
      maze[xc][yc].west:SetBlocked()
    end
    print( 'West node found: { '..xc..','..yc..' }' )
    maze[xc][yc].west:SetVisited()
    maze[xc][yc].visited = true
    WallBlocker(maze, xc, yc-1)
  end

  if maze[xc][yc].north:IsOpened() and maze[xc][yc].north:IsBlocked() == false then
    if maze[xc][yc].north:IsVisited() then
      maze[xc][yc].north:SetBlocked()
    end
    print( 'North node found: { '..xc..','..yc..' }' )
    maze[xc][yc].north:SetVisited()
    maze[xc][yc].visited = true
    WallBlocker(maze, xc-1, yc)
  end
end

return WallBlocker
