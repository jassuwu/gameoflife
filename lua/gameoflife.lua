local ALIVE = "■"
local DEAD = " "
local TICK_GAP = 0 -- seconds

-- Trying to fit the game to the terminal window :')
local function getConsoleDimensions()
  local rows, cols = io.popen('stty size'):read('*a'):match('(%d+)%s+(%d+)')
  return tonumber(rows), tonumber(cols)
end

local function initializeGrid(rows, cols)
  local grid = {}
  for r = 1, rows do
    grid[r] = {}
    for c = 1, cols do
      grid[r][c] = math.random() > 0.8 and ALIVE or DEAD
    end
  end
  return grid
end

local function countAliveNeighbors(grid, r, c)
  local neighbors = {
    {-1, -1}, {-1, 0}, {-1, 1},
    {0, -1}, {0, 1},
    {1, -1}, {1, 0}, {1, 1},
  }
  local count = 0
  for _, neighbor in ipairs(neighbors) do
    local row, col = r + neighbor[1], c + neighbor[2]
    if row >= 1 and row <= #grid and col >= 1 and col <= #grid[1] and grid[row][col] == ALIVE then
      count = count + 1
    end
  end
  return count
end

local function findNextGeneration(grid)
  local newGrid = {}
  for r = 1, #grid do
    newGrid[r] = {}
    for c = 1, #grid[1] do
      local state, aliveNeighborCount = grid[r][c], countAliveNeighbors(grid, r, c)
      if state == ALIVE and aliveNeighborCount < 2 then
        newGrid[r][c] = DEAD
      elseif state == ALIVE and aliveNeighborCount >= 2 and aliveNeighborCount < 4 then
        newGrid[r][c] = ALIVE
      elseif state == ALIVE and aliveNeighborCount > 3 then
        newGrid[r][c] = DEAD
      elseif state == DEAD and aliveNeighborCount == 3 then
        newGrid[r][c] = ALIVE
      else
        newGrid[r][c] = state
      end
    end
  end
  return newGrid
end

local function cloneGrid(grid)
  local clonedGrid = {}
  for r = 1, #grid do
    clonedGrid[r] = {}
    for c = 1, #grid[1] do
      clonedGrid[r][c] = grid[r][c]
    end
  end
  return clonedGrid
end

local function gridIsStable(oldGrid, newGrid)
  for r = 1, #oldGrid do
    for c = 1, #oldGrid[1] do
      if newGrid[r][c] ~= oldGrid[r][c] then
        return false
      end
    end
  end
  return true
end

local function displayGrid(grid)
  for r = 1, #grid do
    for c = 1, #grid[1] do
      io.write(grid[r][c])
    end
    print()
  end
end

local function main()
  local rows, cols = getConsoleDimensions()
  -- Adjust the columns to make the game a square, otherwise fullscreen 😎
  -- cols = math.floor(cols / 2)
  local grid = initializeGrid(rows, cols)

  os.execute("clear")
  io.write("\27[?25l") -- Hide cursor
  while true do
    local oldGrid = cloneGrid(grid)
    grid = findNextGeneration(grid)
    os.execute("sleep " .. tonumber(TICK_GAP))
    os.execute("clear")
    displayGrid(grid)

    -- can sometimes stop the grid, other times there're alternating states
    if gridIsStable(oldGrid, grid) then
      print("The grid is stable. Stopping...")
      break
    end

  end
  io.write("\27[?25h") -- Show cursor
end

main()
