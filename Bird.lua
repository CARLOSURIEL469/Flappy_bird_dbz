Bird = Class{}

----------------GRAVEDAD
 GRAVITY = 8
 space_distance=-2

function Bird:init()
    --cargar la imagen de la pelota
    self.image = love.graphics.newImage('nave.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- posicino del objeto en la pantalla 
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    ---gravedad del objeto 
    self.dy=0
end


function Bird:collides(pipe)

	--para indicar si el pipe choco con alguno de los objetos 
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y+ PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:reset(seft)

	--para indicar si el pipe choco con alguno de los objetos 
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

function Bird:update(dt)
    -- aplicacndo la gravedad en el objeto 
    self.dy = self.dy + GRAVITY * dt

--------------------------------DISTANCIA DE SALTO 
    if love.keyboard.wasPressed('space') then
        self.dy = space_distance
        fli:play()
    end
    ---para el movimiento en y 
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end