-- Constants
GAME = {}
NEW_GAME = {}
SIZE = 16
ALIVE = "▇" -- U+2587 baby
ALIVE = "#" -- comment out to use ^
DEAD = " "

local countAliveNeighbors = function(r, c)
  local neighbors = {
    {-1, -1}, {-1, 0}, {-1, 1},
    {0, -1}, {0, 1},
    {1, -1}, {1, 0}, {1, 1},
  }
  local count = 0
  for _, neighbor in ipairs(neighbors) do
    local row, col = r + neighbor[1], c + neighbor[2]
    if row >= 1 and row <= SIZE and col >= 1 and col <= 2 * SIZE and GAME[row][col] == ALIVE then
      count = count + 1
    end
  end
  return count
end

local initializeGrid = function()
  for r = 1, SIZE do
    GAME[r] = {}
    NEW_GAME[r] = {}
    for c = 1, 2 * SIZE do
      GAME[r][c] = math.random() > 0.8 and ALIVE or DEAD
      NEW_GAME[r][c] = DEAD
    end
  end
end

local displayGrid = function()
  for r = 1, SIZE do
    for c = 1, 2 * SIZE do
      io.write(GAME[r][c])
    end
    print()
  end
end

local findNextGenerationAndSetGame = function()
  for r = 1, SIZE do
    for c = 1, 2 * SIZE do
      local state, aliveNeighborCount = GAME[r][c], countAliveNeighbors(r, c)
      if state == ALIVE and aliveNeighborCount < 2 then
        NEW_GAME[r][c] = DEAD
      elseif state == ALIVE and aliveNeighborCount >= 2 and aliveNeighborCount < 4 then
        NEW_GAME[r][c] = ALIVE
      elseif state == ALIVE and aliveNeighborCount > 3 then
        NEW_GAME[r][c] = DEAD
      elseif state == DEAD and aliveNeighborCount == 3 then
        NEW_GAME[r][c] = ALIVE
      else
        NEW_GAME[r][c] = state
      end
    end
  end
  -- Swap GAME and NEW_GAME
  GAME, NEW_GAME = NEW_GAME, GAME
end

local cloneGrid = function (game)
  local clonedGrid = {}
  for r = 1, SIZE do
    clonedGrid[r] = {}
    for c = 1, 2 * SIZE do
      clonedGrid[r][c] = game[r][c]
    end
  end
  return clonedGrid
end

local gridIsStable = function (oldGame, newGame)
  local isStable = true
  for r = 1, SIZE do
    for c = 1, 2 * SIZE do
      if newGame[r][c] ~= oldGame[r][c] then
        isStable = false
        break
      end
    end
    if not isStable then break end
  end
end

initializeGrid()
while true do
  os.execute("sleep " .. tonumber(0.01))
  os.execute("clear")
  displayGrid()
  local oldGame = cloneGrid(GAME)
  findNextGenerationAndSetGame()
  -- Check if the grid is stable
  if gridIsStable(oldGame, GAME) then
    print("The grid is stable. Stopping...")
    break
  end
end
