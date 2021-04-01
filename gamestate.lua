local gamestate = {}
gamestate.menu = false
gamestate.game = false
gamestate.gameOver = false

function gamestate.setState(state, bool)
    if state == 'menu' then
        gamestate.menu = bool
    elseif state == 'game' then
        gamestate.game = bool
    elseif state == 'gameOver' then
        gamestate.gameOver = bool
    end
end

function gamestate.getCurrentState()
    if gamestate.menu == true then
        return 'menu'
    elseif gamestate.game == true then
        return 'game'
    elseif gamestate.gameOver == true then
        return 'gameOver'
    else
        return 'none'
    end
end

return gamestate