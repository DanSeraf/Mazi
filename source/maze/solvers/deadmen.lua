local Maze = require "maze"
_ENV = nil

-- keep track of visited nodes
-- so you can check if the next node was readed by another path finder
-- TODO have to sync the two tables of available paths

getCopy = function(orig) 
  copy = { }
  for _, el in pairs(orig) do
    table.insert(copy, el)
  end

  return copy
end

pathprint = function(maze, path)
  io.write('analyzing ')
  print(path)
  io.write('\navailable paths:\n')
  for _, pat in pairs(path) do
    io.write('id: ')
    print(pat)
    for _, node in pairs(pat) do
      print(maze:GetCoord(node))
    end
  end
end

-- return possible directions 
possibleDirections = function(walls)
  onedir = nil
  len = 0
  for dir, wall in pairs(walls) do
    if wall:IsOpened() then  
      len = len + 1
      onedir = dir
    end
  end
  
  if len == 1 then return len, onedir end

  return len, onedir
end

removePaths = function(toremove, avail)
  for path_id, path in pairs(avail) do
    for _, apath in pairs(toremove) do
      if path == apath then table.remove(available_paths, path_id) end
    end
  end
end

outMaze = function(x, y)
  if x ~= 0 and y ~= 0 and x < 20 and y < 18 then return true end
  return false
end

-- update the path if only one move is possible otherwise generate a new clone of the
-- current path and insert it in the available_paths table 
moveit = function(maze, path_id, avail_copy)
  path = avail_copy[path_id]
  io.write('analyzing path: ')
  print(path)
  node = path[#path]
  directions = maze.directions
  walls = maze.walls(node)
  y, x = maze:GetCoord(node)
  moved = false 
  len, dir= possibleDirections(walls, x, y)
  
  -- if only one direction is possible then update the current path
  if len == 1 then 
    io.write('updating\n')
    newx = x + directions[dir]['y']
    newy = y + directions[dir]['x']
    print(newx)
    print(newy)
    print('----------------')
    if newx == 0 or newy == 0 then return false end

    if not maze[newx][newy].visited and outMaze(newx, newy) then
      maze[newx][newy].visited = true
      table.insert(available_paths[path_id], maze[newx][newy])
      moved = true
    end
  else
    -- scan all the possible directions
    for direction, wall in pairs(walls) do
      newx = x + directions[direction]['y']
      newy = y + directions[direction]['x']

      io.write('-new coordinate ['..direction..'] -> (')
      io.write(newx..','..newy..') ')
      print(wall:IsOpened())

      -- if wall is opened and the new node is not discovered yet, generate a clone 
      -- of the path and insert it in the available paths
      if wall:IsOpened() and outMaze(newx, newy) and not maze[newx][newy].visited then 
        maze[newx][newy].visited = true
        -- generate a clone of the current path and insert the new coordinate
        new_path = getCopy(path)
        -- add node discovered to end of the current path cloned 
        table.insert(new_path, maze[newx][newy])
        -- add the new path to the available_paths 
        table.insert(available_paths, new_path)
        moved = true
      end
    end
  end
  print(moved) 
  return moved 
end

-- return true if shortest path is found
readAvailable = function(maze, available_paths)
  exit = true
  correct_path_id = 0

  while true and exit do
    -- first_path = available_paths[1]
    -- if first_path[#first_path].south:IsExit() then goto continue end
    avail_copy = getCopy(available_paths)
    toremove = { }    
    for path_id, path in pairs(avail_copy) do
      if not moveit(maze, path_id, avail_copy) then
        if path[#path].south:IsExit() then correct_path_id = path_id goto continue end
        print('toeuhn')
        print(path[#path].south:IsExit())
        io.write('removing path :')
        print(path)
        --table.remove(available_paths, path_id)
        table.insert(toremove, path)
        io.write('SITUATION \n')
      end
    end
    removePaths(toremove, available_paths)
    if #available_paths == 0 then return available_paths, false end
  end
  ::continue::
  
  return available_paths[correct_path_id], true
end

local function deadmen(maze, x, y)
  available_paths = { }
  maze:SetupVisited()
  -- initialize available_paths if empty
  if #available_paths == 0 then
    maze[x][y].visited = true
    table.insert(available_paths, { maze[x][y] })
  end
   
  -- if a solution is found then generate the current path
  path, res = readAvailable(maze, available_paths)
 
  print(path)
  print(res)

  if not res then maze:ResetVisited() print("there is no Exit!") end

  if res then 
    io.write("Exit found!") 
    maze:ResetVisited()
    for _, node in pairs(path) do
      node.visited = true
    end
  end

end

return deadmen
