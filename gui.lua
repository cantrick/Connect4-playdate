local gui = {}
gfx = love.graphics
gui.x = 200
gui.y = -1
gui.size = 2
gui.font = gfx.newFont(25)
gui.fontBig = gfx.newFont(100)
gui.winBG = gfx.newImage('images/winBG.png')
gui.btnRematch = gfx.newImage('images/btnRematch.png')
gui.btnMenu = gfx.newImage('images/btnMenu.png')
gui.titleMenu = gfx.newImage('images/titlescreen.png')

local dark = {0.195313,0.183594,0.160156}
local light = {0.694118, 0.682353, 0.658824}

function gui.drawText(text,x)
    gfx.push()

    gfx.setFont(gui.font)
    gfx.setColor(50/255, 47/255, 41/255)
    gfx.scale(0.1,0.1)

    gfx.print(
        text,
        x,
        gui.y,
        0,
        gui.size,
        gui.size
    )

    gfx.setColor(177/255, 174/255, 168/255)

    gfx.pop()
end

function gui.drawTextBig(text,x,y)

    gfx.setFont(gui.fontBig)

    coloredText = {dark,text}

    gfx.print(
        coloredText,
        x,
        y,
        0,
        0.2,
        0.2
    )

end

function gui.drawGameOverScreen(winner)
    --draw box to hold winner text in

    gfx.draw(
        gui.winBG,
        125,
        50
    )

    gfx.setFont(gui.fontBig)

    coloredText = {dark,winner..' wins!'}

    gfx.print(
        coloredText,
        155,
        55,
        0,
        0.2,
        0.2
    )

    gfx.draw(
        gui.btnRematch,
        155,
        90
    )

    gfx.draw(
        gui.btnMenu,
        150,
        120
    )
    
end

function gui.drawTitleMenu()
    --draw box to hold winner text in

    gfx.draw(
        gui.titleMenu,
        0,
        0
    )
    
end

return gui