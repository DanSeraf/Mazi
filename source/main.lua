local Maze = require "maze"
local generators = require "maze.generators"
local loveframes = require "LoveFrames.loveframes"
local wallblocker = require "maze.solvers.wallblocker"
local solvers = require "maze.solvers"

local maze;
local text;

local generators_aliases =
{
  aldous_broder         = "Aldous - Broder",
  binary_tree           = "Binary Tree",
  eller                 = "Eller's algorithm",
  growing_tree          = "Growing Tree",
  hunt_and_kill         = "Hunt and Kill",
  kruskal               = "Kruskal's algorithm",
  prim                  = "Prim's algorithm",
  recursive_backtracker = "Recursive Backtracker",
  recursive_division    = "Recursive Division",
  sidewinder            = "Sidewinder",
  wilson                = "Wilson's algorithm"
}

local solvers_aliases = 
{
  wallblocker = "Wall Blocker",
  astar = "A Star"
}

local generators_aliases_rev;

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  generators_aliases_rev = {}
  for key, value in pairs(generators_aliases) do
    generators_aliases_rev[value] = key
  end
  
  -- Interface
  local margin = 10
  local width_franction = 0.3
 
  --[[ Maze generators frame ]]--
  local mframe = loveframes.Create("frame")
  mframe:SetName("Maze generators")
  mframe.width = love.graphics.getWidth() * width_franction
  mframe.height = love.graphics.getHeight() - margin * 8
  mframe.x = love.graphics.getWidth() - mframe.width - margin
  mframe.y = margin
  mframe:SetDraggable(false):ShowCloseButton(false)
  
  local generators_list = loveframes.Create("list", mframe)
  generators_list:SetPos(margin, 25 + margin):SetSize(mframe.width - margin * 2, mframe.height * 0.475)
  for name, generator in pairs(generators) do
    local button = loveframes.Create("button")
    button:SetText(generators_aliases[name])
    button.OnClick = function(obj)
        local time = love.timer.getTime()
        maze:ResetVisited()
        generators[name](maze)
        time = love.timer.getTime() - time
        text:SetText(string.format("Algorithm: %s\nTime: %.4fs", obj:GetText(), time))
      end
    
    generators_list:AddItem(button)
  end
  
  text = loveframes.Create("text", mframe)
  text:SetPos(margin, generators_list.y + generators_list.height + 50)
  text:SetSize(mframe.width - margin * 2, mframe.height * 0.3)
  --[[ end of frame ]]--
  
  --[[ Solvers frame ]]--
  local sframe = loveframes.Create("frame")
  sframe:SetName("Solvers")
  sframe.width = 50
  sframe.height = love.graphics.getHeight() - margin * 2
  sframe.x = love.graphics.getWidth() - sframe.width - margin
  sframe.y = margin
  sframe:SetDraggable(false):ShowCloseButton(false)

  local solvers_list = loveframes.Create("list", sframe)
  solvers_list:SetPos(margin, 300 + margin):SetSize(sframe.width - margin * 2, sframe.height * 0.125)
  for algo, name in pairs(solvers_aliases) do
    local button = loveframes.Create("button")
    button:SetText(name)
    button.OnClick = function(obj)
      maze:ResetVisited()
      maze:OpenDoors()
      solvers[algo](maze, 1, 1)      
    end

    solvers_list:AddItem(button)
  end
  --[[ end of frame]]--
  
  -- Maze creation and misc
  maze = Maze:new(17, 19, true)
  math.randomseed(os.time())
end

function love.update(dt)
  loveframes.update(dt) 
end

function love.draw()
  love.graphics.setBackgroundColor(100/255, 100/255, 200/255)
  cell_color = { 150/255, 150/255, 200/255 }
  wall_color = { 20/255, 20/255, 100/255 }
  point_col = { 0/255, 100/255, 0/255 }
  draw_maze(maze, 10, 10, 20, 10, cell_color, wall_color, point_col)
  love.graphics.setColor(255, 255, 255)
  
  loveframes.draw()
end
 
function love.mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end
 
function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button) 
end
 
function love.keypressed(key, unicode)
  loveframes.keypressed(key, unicode) 
end
 
function love.keyreleased(key)
  loveframes.keyreleased(key) 
end

function draw_maze(maze, x, y, cell_dim, wall_dim, cell_col, wall_col, point_col)
  walls = 
  {
    north = function(current) if current.north:IsOpened() then love.graphics.rectangle("fill", pos_x, pos_y - wall_dim, cell_dim, wall_dim) end end,
    east = function(current) if current.east:IsOpened() then love.graphics.rectangle("fill", pos_x + cell_dim, pos_y, wall_dim, cell_dim) end end,
    south = function(current) if current.south:IsOpened() then love.graphics.rectangle("fill", pos_x, pos_y + cell_dim, cell_dim, wall_dim) end end,
    west = function(current) if current.west:IsOpened() then love.graphics.rectangle("fill", pos_x - wall_dim, pos_y, wall_dim, cell_dim) end end
  }

  love.graphics.setColor(wall_col)
  local maze_width = (cell_dim + wall_dim) * #maze[1] + wall_dim
  local maze_height = (cell_dim + wall_dim) * #maze + wall_dim
  love.graphics.rectangle("fill", x, y, maze_width, maze_height)
  love.graphics.setColor(cell_col)
  
  for yi = 1, #maze do
    for xi = 1, #maze[1] do
      current = maze[yi][xi]
      doors = { south = current.south, north = current.north, east = current.east, west = current.west}
      pos_x = x + (cell_dim + wall_dim) * (xi - 1) + wall_dim
      pos_y = y + (cell_dim + wall_dim) * (yi - 1) + wall_dim
      love.graphics.rectangle("fill", pos_x, pos_y, cell_dim, cell_dim)
      if maze[yi][xi].visited == true then
        love.graphics.setColor(point_col)
        love.graphics.rectangle("fill", pos_x, pos_y, cell_dim, cell_dim)
        love.graphics.setColor(cell_col)
      end
      
      for dir, draw_wall in pairs(walls) do
        draw_wall(current)
      end

    end
  end 
end
