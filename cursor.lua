local cursor = {}
gfx = love.graphics

cursor.image = gfx.newImage('images/cursor.png')
cursor.x = 130
cursor.y = 90
cursor.menu = false
cursor.rematch = true
cursor.quit = false
cursor.isInitialized = false

function cursor.initialize(x,y)
    if cursor.isInitialized == false then
        cursor.x = x
        cursor.y = y
        cursor.isInitialized = true
    end
end

function cursor.reset()
    cursor.isInitialized = false
    cursor.menu = false
    cursor.rematch = true
    cursor.quit = false
end

function cursor.draw()
    gfx.draw(
        cursor.image,
        cursor.x,
        cursor.y
    )
end

return cursor