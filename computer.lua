local board = require 'board'
local gamestate = require 'gamestate'
local computer = {}
gfx = love.graphics

computer.x = 40
computer.y = 1
computer.xBounds = {72,(32*7)+72}
computer.xPad = 32
computer.newY = 0
computer.image = gfx.newImage('images/p2disc.png')
computer.allDiscs = {}
computer.currDiscCreated = false
computer.turn = false
computer.inAnim = false

currDisc = {}

function computer.draw()
    for _, disc in pairs(computer.allDiscs) do
        computer.drawAllDiscs(disc)
    end
    
end

function computer.drawAllDiscs(disc)
    gfx.draw(
        computer.image,
        disc.x,
        disc.y
    )
end

function computer.update(dt)
    if computer.inAnim == true then
        computer.updateAnimation(dt)
        print('anim')
    else 
        if board.turn == 2 then
            computer.turn = true
        end

        if computer.turn == false then
            computer.turn = true
        end

        if computer.currDiscCreated == false then
            currDisc = computer.newDisc(computer.x, computer.y)
            table.insert(computer.allDiscs, currDisc)
            computer.currDiscCreated = true
        end

        if currDisc.isPlaced ~= true then
            computer.takeTurn()
        end
    end
end

function computer.newDisc(pX, pY)
    return({
        x = pX,
        y = pY,
        gridPos = {0,4},
        isPlaced = false
    })
end

function computer.placeDisc(disc)
    computer.newY = disc.gridPos[1] * 32 + 1
    computer.currDisc = disc
    computer.inAnim = true
    computer.updateAnimation(dt)
end

function computer.reset()
    computer.allDiscs = {}
    computer.currDiscCreated = false
end

function computer.updateAnimation(dt)
    print('we in')
    if computer.newY ~= 0 and computer.currDisc.y ~= computer.newY then
        computer.currDisc.y = computer.currDisc.y + fallSpeed
        fallSpeed = fallSpeed + 1.1
        print('curr: ' .. computer.currDisc.y)
        print('new: ' .. computer.newY)
        if computer.currDisc.y > computer.newY then
            computer.currDisc.y = computer.newY
        end
    end

    if computer.newY ~= 0 and computer.currDisc.y == computer.newY then
        print('2')
        fallSpeed = 0
        computer.inAnim = false
        computer.newY = 0
    end
end


function computer.takeTurn()
    if gamestate.getCurrentState() == 'game' then
        if computer.turn then
            currDisc = computer.allDiscs[#computer.allDiscs]
            --pick a random column to drop to

            while currDisc.isPlaced ~= true do
                --gen random #
                --try to place it
                    --if successful, move on
                    --if failed, generate # again and do it all over
                currDisc.gridPos[2] = love.math.random(8)
                currDisc.x = currDisc.x + (32*currDisc.gridPos[2])

                if board.checkCell(currDisc,currDisc.gridPos[2]) then
                    currDisc.gridPos[1] = board.drop(2,currDisc.gridPos[2])
                    computer.placeDisc(currDisc)
                    if board.checkWin() == 2 then
                        print('comp wins')
                        print(currDisc.gridPos[1]..','..currDisc.gridPos[2])
                        currDisc.isPlaced = true
                        computer.currDiscCreated = false
                        board.turn = 1
                        computer.turn = false
                        gamestate.setState('gameOver',true)
                        gamestate.setState('game',false)
                    else
                        currDisc.isPlaced = true
                        computer.currDiscCreated = false
                        board.turn = 1
                        computer.turn = false
                    end
                else
                    currDisc.x = computer.x
                end
            end
        end
    end
end

return computer