local require = require
_ENV = nil

local namespace = {}
namespace.wallblocker = require "maze.solvers.wallblocker"
namespace.astar = require "maze.solvers.astar"
namespace.deadmen = require "maze.solvers.deadmen"

return namespace
