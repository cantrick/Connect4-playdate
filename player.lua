local board = require 'board'
local gamestate = require 'gamestate'
local gui = require 'gui'
local cursor = require 'cursor'
local player = {}
gfx = love.graphics

player.x = 168
player.y = 1
player.xBounds = {72,(32*7)+72}
player.xPad = 32
player.image = gfx.newImage('images/p1disc.png')
player.allDiscs = {}
player.currDiscCreated = false
player.turn = true
player.isWin = false
player.cursor = {}
player.newY = 0
player.inAnim = false
player.currDisc = {}
player.discPlaced = false

fallSpeed = 1

currDisc = {}

function player.draw()
    for _, disc in pairs(player.allDiscs) do
        player.drawAllDiscs(disc)
    end
end

function player.drawAllDiscs(disc)
    gfx.draw(
        player.image,
        disc.x,
        disc.y
    )
end

function player.update(dt)
    if player.inAnim == true then
        player.updateAnimation(dt)
    else
        if board.turn == 1 then
            player.turn = true
        end
    
        if player.currDiscCreated == false then
            currDisc = player.newDisc(player.x, player.y)
            table.insert(player.allDiscs, currDisc)
            player.currDiscCreated = true
        end

        if player.discPlaced then
            player.checkWin()
        end
    end
end

function player.newDisc(pX, pY)
    return({
        x = pX,
        y = pY,
        gridPos = {0,4},
        isPlaced = false
    })
end

function player.placeDisc(disc)
    player.newY = disc.gridPos[1] * 32 + 1
    player.currDisc = disc
    player.inAnim = true
end

function player.reset()
    player.allDiscs = {}
    player.currDiscCreated = false
end

function player.updateAnimation(dt)
    if player.newY ~= 0 and player.currDisc.y ~= player.newY then
        player.currDisc.y = player.currDisc.y + fallSpeed
        fallSpeed = fallSpeed + 1.1
        if player.currDisc.y > player.newY then
            player.currDisc.y = player.newY
        end
    end

    if player.newY ~= 0 and player.currDisc.y == player.newY then
        fallSpeed = 0
        player.inAnim = false
        player.newY = 0
    end
end

function player.checkWin()
    if board.checkWin() == 1 then
        print('p1 wins')
        player.isWin = true
        currDisc.isPlaced = true
        player.currDiscCreated = false
        board.turn = 2
        player.turn = false
        player.discPlaced = false
        gamestate.setState('gameOver',true)
        gamestate.setState('game',false)
    else
        player.discPlaced = false
        currDisc.isPlaced = true
        player.currDiscCreated = false
        board.turn = 2
        player.turn = false
    end
end

function love.keypressed(key)
    if gamestate.getCurrentState() == 'game' then
        if player.turn then
            currDisc = player.allDiscs[#player.allDiscs]

            if currDisc.isPlaced ~= true and player.discPlaced ~= true then
                if key == 'right' and currDisc.x < player.xBounds[2] then
                    currDisc.x = currDisc.x + player.xPad
                    currDisc.gridPos[2] = currDisc.gridPos[2] + 1
                elseif key == 'left' and currDisc.x > player.xBounds[1] then
                    currDisc.x = currDisc.x - player.xPad
                    currDisc.gridPos[2] = currDisc.gridPos[2] - 1
                end

                if key == 'z' then
                    if board.checkCell(currDisc,currDisc.gridPos[2]) then
                        currDisc.gridPos[1] = board.drop(1,currDisc.gridPos[2])
                        player.placeDisc(currDisc)
                        player.discPlaced = true
                    end
                end
            end
        end
    elseif gamestate.getCurrentState() == 'menu' then
        if key == 'down' and cursor.y == 180 then
            cursor.x = cursor.x + 177
            cursor.y = cursor.y + 10
            cursor.quit = true
            cursor.rematch = false
            cursor.menu = false
        elseif key == 'up' and cursor.y == 190 then
            cursor.y = 180
            cursor.x = cursor.x - 177
            cursor.quit = false
            cursor.menu = true
        elseif key == 'up' and cursor.y > 130 then
            cursor.y = cursor.y - 50 
            cursor.rematch = true
            cursor.menu = false
        elseif key == 'down' and cursor.y == 130 then
            cursor.y = cursor.y + 50 
            cursor.rematch = false
            cursor.menu = true
        end

        if key == 'z' then
            if cursor.menu == true then
                gamestate.setState('menu', true)
                gamestate.setState('gameOver', false)
            elseif cursor.rematch == true then
                player.isWin = false
                gamestate.setState('game', true)
                gamestate.setState('menu', false)
                cursor.reset()
            elseif cursor.quit == true then
                love.event.quit()
            end
        end
    elseif gamestate.getCurrentState() == 'gameOver' then
        if key == 'up' and cursor.y > 90 then
            cursor.y = cursor.y - 35 
            cursor.rematch = true
            cursor.menu = false
        elseif key == 'down' and cursor.y == 90 then
            cursor.y = cursor.y + 35 
            cursor.rematch = false
            cursor.menu = true
        end

        if key == 'z' then
            if cursor.menu == true then
                gamestate.setState('menu', true)
                gamestate.setState('gameOver', false)
                cursor.reset()
            elseif cursor.rematch == true then
                --reset board here?
                player.isWin = false
                gamestate.setState('game', true)
                gamestate.setState('gameOver', false)
            end
        end
    end
end

return player