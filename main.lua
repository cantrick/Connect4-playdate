-- Set to false to allow scales that will have uneven pixels
local intScaling = true
local board = require 'board'
local player = require 'player'
local computer = require 'computer'
local gamestate = require 'gamestate'
local gui = require 'gui'
local cursor = require 'cursor'

local canvas
local light = {0.694118, 0.682353, 0.658824}
local dark = {0.195313,0.183594,0.160156}
local w = 400
local h = 240
local scale = 3
local winner  = 0

loadBoard = false

function love.load()
  -- set rescaling filter
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Black for pillars
  love.graphics.setBackgroundColor(0,0,0)

  -- white for all drawing
  love.graphics.setColor(255,255,255)

  -- Create canvas
	canvas = love.graphics.newCanvas(w, h)

  gamestate.setState('menu', true)
  --board.create()
end

function love.draw()

  love.graphics.setCanvas(canvas)
    -- Do all your drawing here

    -- Dark colour for everything by default
    love.graphics.clear(light)

    if gamestate.getCurrentState() == 'game' then
      board.draw()
      player.draw()
      computer.draw()
    elseif gamestate.getCurrentState() == 'gameOver' then
      board.draw()
      player.draw()
      computer.draw()
      if player.isWin then
        gui.drawGameOverScreen('P1')
        cursor.draw()
      else
        gui.drawGameOverScreen('Comp')
        cursor.draw()
      end
    elseif gamestate.getCurrentState() == 'menu' then
      gui.drawTitleMenu()
      cursor.draw()
    end
    -- End of drawing
	love.graphics.setCanvas()

  -- Center the cavas
  local xpos = math.floor( (love.graphics.getWidth() - w*scale)/2 )
  local ypos = math.floor( (love.graphics.getHeight() - h*scale)/2 )
  love.graphics.draw(canvas, xpos, ypos, 0, scale, scale)

end

function love.resize(width, height)

  -- Recalculate what to scale the game at
  scale = math.min(width/w, height/h)

  if intScaling then
    scale = math.floor(scale)
  end

end

function love.update(dt)

  if gamestate.getCurrentState() == 'game' then
    if loadBoard == false then
      board.create()
      player.reset()
      computer.reset()
      loadBoard = true
    end

    if board.turn == 1 then
      player.update(dt)
    elseif board.turn == 2 then 
      computer.update(dt)
    end
  elseif gamestate.getCurrentState() == 'gameOver' then
    cursor.initialize(130,90)
    loadBoard = false
    board.turn = 1
  elseif gamestate.getCurrentState() == 'menu' then
    cursor.initialize(90,130)
    loadBoard = false
    board.turn = 1
  end

end

function love.keyreleased( key, code )
    if  key == 'escape' then
       love.event.quit()
    end    
 end