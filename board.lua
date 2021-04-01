gfx = love.graphics
local board = {}

board.width = 260
board.height = 205
board.x = 70
board.y = 17
board.rows = 6
board.cols = 8
board.image = gfx.newImage('images/board.png')
board.fullBoard = {}
board.turn = 1

function board.create()
    board.fullBoard = {
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
    }
end

function board.draw()
    gfx.draw(
        board.image,
        board.x,
        board.y
    )
end

function board.drop(player, col)
    for i = board.rows, 1, -1 do
        if board.fullBoard[i][col] == 0 then
            board.fullBoard[i][col] = player
            return i
        end
    end
end

function board.checkCell(player,col)
    for i = board.rows, 1, -1 do
        if board.fullBoard[i][col] == 0 then
            return true
        end
    end

    return false
end

function board.checkWin()
    --find any 4 in a row pattern here
    --let's check horizontal first:
    local tempNum = 9
    local combo = 1

    for i = 1, board.rows do 
        for j = 1, board.cols do
            if j == 1 and board.fullBoard[i][j] ~= 0 then
                tempNum = board.fullBoard[i][j]
            elseif board.fullBoard[i][j] == tempNum and board.fullBoard[i][j] ~= 0 then
                combo = combo + 1
            else
                tempNum = board.fullBoard[i][j]
                combo = 1
            end

            if combo == 4 then
                return tempNum
            elseif j == 8 then
                tempNum = 9
                combo = 1
            end
        end
    end
    
    --now let's check the vertical
    --it's like the same as the above... but backwards. ezpz
    for i = 1, board.cols do 
        for j = 1, board.rows do
            if j == 1 and board.fullBoard[j][i] ~= 0 then
                tempNum = board.fullBoard[j][i]
            elseif board.fullBoard[j][i] == tempNum and board.fullBoard[j][i] ~= 0 then
                combo = combo + 1
            else
                tempNum = board.fullBoard[j][i]
                combo = 1
            end

            if combo == 4 then
                return tempNum
            elseif j == 6 then
                tempNum = 9
                combo = 1
            end
        end
    end

    --shit I forgot we had to check DIAGONALS as well
    --I guess I'll try to do the forward diagonal (/) first:
    --might be pretty similar to the vertical...
    for i = 4, board.cols do 
        for j = 1, board.rows-3 do
            if j == 1 and board.fullBoard[j][i] ~= 0 then
                tempNum = board.fullBoard[j][i]
            elseif board.fullBoard[j+1][i-1] == board.fullBoard[j][i] and board.fullBoard[j+1][i-1] ~= 0 then
                tempNum = board.fullBoard[j][i]
                if board.fullBoard[j+2][i-2] == tempNum and board.fullBoard[j+2][i-2] ~= 0 then
                    if board.fullBoard[j+3][i-3] == tempNum and board.fullBoard[j+3][i-3] ~= 0 then
                        return tempNum
                    else
                        tempNum = board.fullBoard[j][i]
                        combo = 1
                    end
                else
                    tempNum = board.fullBoard[j][i]
                    combo = 1
                end
            else
                tempNum = board.fullBoard[j][i]
                combo = 1
            end

            if combo == 4 then
                return tempNum
            elseif j == 8 then
                tempNum = 9
                combo = 1
            end
        end
    end

    --and finally, the other diagonal (\)
    for i = 1, board.cols-3 do 
        for j = 1, board.rows-3 do
            if j == 1 and board.fullBoard[j][i] ~= 0 then
                tempNum = board.fullBoard[j][i]
            elseif board.fullBoard[j+1][i+1] == board.fullBoard[j][i] and board.fullBoard[j+1][i+1] ~= 0 then
                tempNum = board.fullBoard[j][i]
                if board.fullBoard[j+2][i+2] == tempNum and board.fullBoard[j+2][i+2] ~= 0 then
                    if board.fullBoard[j+3][i+3] == tempNum and board.fullBoard[j+3][i+3] ~= 0 then
                        return tempNum
                    else
                        tempNum = board.fullBoard[j][i]
                        combo = 1
                    end
                else
                    tempNum = board.fullBoard[j][i]
                    combo = 1
                end
            else
                tempNum = board.fullBoard[j][i]
                combo = 1
            end

            if combo == 4 then
                return tempNum
            elseif j == 8 then
                tempNum = 9
                combo = 1
            end
        end
    end

    return 0
end

function board.printBoard()
    for i = 1, board.rows do
        print(board.fullBoard[i][1]..'-'..board.fullBoard[i][2]..'-'..board.fullBoard[i][3]..'-'..board.fullBoard[i][4]..'-'..board.fullBoard[i][5]..'-'..board.fullBoard[i][6]..'-'..board.fullBoard[i][7]..'-'..board.fullBoard[i][8])
    end
end

return board