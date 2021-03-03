
push = require 'push'
Class = require 'class'

--llamada a los objetos 

require 'Bird'

require 'Pipe'

require 'PipePair'
-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
COUNTDOWN_TIME = 0.75

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--LLAMA A LA IMAGEN A USAR 
local background = love.graphics.newImage('ground/namek.png')
local background1 = love.graphics.newImage('ground/namek.png')
local background2 = love.graphics.newImage('ground/segundo.png')
local background3 = love.graphics.newImage('ground/tercero.png')
local background4 = love.graphics.newImage('ground/cuarto.png')
local background5 = love.graphics.newImage('ground/quinto.png')


local lost = love.graphics.newImage('krillin.png')
local logo = love.graphics.newImage('logo.png')

local yabasta=love.graphics.newImage('yabasta.png')
local krim=love.graphics.newImage('krillin.png')
local l1 = love.graphics.newImage('goku_p.png')
local l2 = love.graphics.newImage('goku_a.png')
local l3 = love.graphics.newImage('goku_s.png')

local naveB=love.graphics.newImage('nave.png')
local naves=love.graphics.newImage('suelo/nave.png')
--SU MOVIMIENTO AL INICIAR 
local backgroundScroll = 0
local background1Scroll = 0
--LLAMA AL SUELO -
local ground = love.graphics.newImage('suelo/primera.png')
local groundScroll = 0


--sondio 
intro=love.audio.newSource("sonidos/intro.mp3", "static")
radar=love.audio.newSource("sonidos/radar.mp3", "static")
yab=love.audio.newSource("sonidos/yab.mp3", "static")
go=love.audio.newSource("sonidos/go.mp3", "static")
psh=love.audio.newSource("sonidos/psh.mp3", "static")
fli=love.audio.newSource("sonidos/fli.mp3", "stream")
--VELOCIDAD DEL FONDO Y EL SUELO 
local BACKGROUND_SCROLL_SPEED = 200
local GROUND_SCROLL_SPEED = 60

--punto de reinicio para el ground 

local GROUND_LOOPING_POINT = 514
--PUNTO DE LOOP
local BACKGROUND_LOOPING_POINT =1440

local bird = Bird()

local pipePairs = {}

---tabla para los spawn de los pipes 
local pipes = {}

----variable para el tiempo de spawn 
local spawnTimer = 0


-- variable para la brecha en donde pasara el jugador 
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- scrolling variable to pause the game when we collide with a pipe
local scrolling = true

score=0
highscore=0
spawn_r=2
dificulty=0
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

function love.load()
  
    ----ventana del juego 
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('FLAPPY BIRD CHIDO ')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    dragon = love.graphics.newFont('stocky.ttf', 24)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    ---varible para delimitar el fondo a usar 
    fondo=0
    count=5
    timw=0

    ---tabla oara el almacenaje de las veces que se preciono brincar 
    love.keyboard.keysPressed = {}

    gamestate='start'
end


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

function love.resize(w, h)
    push:resize(w, h)
end

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    --para salir del juego 

    if key == 'escape' then
        love.event.quit()
    end
end
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
function love.keyboard.wasPressed(key)
    ---funcion para obtenida de bird para poder saltar en base a las funciones en la otra clase 
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
function love.update(dt)
-----avance del fondo 
        if backgroundScroll <= BACKGROUND_LOOPING_POINT then 
            backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        else
    -------------------------------------------------------------------
            ---cambio de fondo con el tiempo 
            if fondo==0 then 
                background=background2
                fondo=fondo+1
            elseif fondo ==1 then 
                background=background3
                fondo=fondo+1
            elseif fondo ==2 then 
                background=background4
                fondo=fondo+1
            elseif fondo ==3 then 
                background=background5
                fondo=fondo+1
            elseif fondo ==4 then 
                background=background1
                fondo=0
            end
             backgroundScroll=0
        end

        ---avence del suelo 
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % GROUND_LOOPING_POINT    
        ------------------------------------------------------------------------------------------------------------------------------------------
        ---estados 
    -----/////estado inicial 
    if gamestate=='start' then 
        intro:play()
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gamestate= 'dificultie'
            radar:play()
        end
    -----/////estado juego 
    elseif gamestate=='play' then 
        count=5
        time=0
        ---dificultad progresiva 
        if score==5 then 
            PIPE_SPEED=PIPE_SPEED+10

            bird.image=naves
            psh:play()
        elseif score==15 then 
            PIPE_SPEED=PIPE_SPEED+10
            spawn_r=spawn_r-1
        elseif score==30 then 
            PIPE_SPEED=PIPE_SPEED+10
            spawn_r=spawn_r-1
        end 
        --inicio del juego 
        if scrolling then
            spawnTimer = spawnTimer + dt

            --------------------- tiempo de spawn de los objetos a golpear despues de 4 segundos 
            if spawnTimer > spawn_r then
                local y = math.max(-PIPE_HEIGHT + 10, 
                    math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
                lastY = y
            
            --los inserta para poder ser desplegados mas adelante 
                table.insert(pipePairs, PipePair(y))
            --regresa el tiempo de spawn a 0 para el siguiente par 
                spawnTimer = 0
            end


            -----------------------------puntos
            for k, pair in pairs(pipePairs) do
                 if not pair.scored then
                    if pair.x + PIPE_WIDTH < bird.x then
                        score = score + 1
                        pair.scored = true
                    end
                 end 
                pair:update(dt)
            end 

             ------------ para hacer los pares de pipes ---eliminarlos 
            for k, pair in pairs(pipePairs) do
                if pair.remove then
                    table.remove(pipePairs, k)
                end
            end

            bird:update(dt)

              --------- -- para los pipe que se vean ---coliciones 
            for k, pair in pairs(pipePairs) do
                -- check to see if bird collided with pipe
                for l, pipe in pairs(pair.pipes) do
                    if bird:collides(pipe) then
                        -- pause the game to show collision
                        go:play()
                        lost=krim
                        scrolling = false
                        gamestate='endgame'
                    end
                end

                -- if pipe is no longer visible past left edge, remove it from scene
                if pair.x < -PIPE_WIDTH then
                    pair.remove = true
                end
            end

        ---cuando toca el suelo 
            if bird.y > VIRTUAL_HEIGHT - 15 then
                gamestate='endgame'
                lost=yabasta
                yab:play()
            end
            
        end
    -----/////estado final
    elseif gamestate=='endgame' then 

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
                bird:reset()
                for k, pair in pairs(pipePairs) do
                        table.remove(pipePairs, k)
                end
                if score>highscore then
                    highscore=score 
                end 
                bird.image=naveB
                PIPE_SPEED = 90
                score=0
                radar:play()
                gamestate= 'previous'
        end
    ---//////estado seleccion de DIFICULTAD
    elseif gamestate=='dificultie' then 
        intro:stop()

        if love.keyboard.wasPressed('q') then
            gamestate= 'play'
            radar:play()
            spawn_r=3
            GRAVITY = 8
            space_distance=-2
            PIPE_SPEED=90
        elseif love.keyboard.wasPressed('w') then
            gamestate= 'play'
            radar:play()
            spawn_r=2
            GRAVITY = 16
            space_distance=-4
            PIPE_SPEED=120
        elseif love.keyboard.wasPressed('e') then
            gamestate= 'play'
            radar:play()
            spawn_r=1
            GRAVITY = 20
            space_distance=-5
            PIPE_SPEED=180
        end
    -----/////estado preventivo 
    elseif gamestate=='previous' then
        scrolling=false
        time=time+dt

        if time>=COUNTDOWN_TIME then 
            time=time%COUNTDOWN_TIME 
            count=count-1
            if  count==0 then 
                gamestate= 'play'
                scrolling=true
            end 
        end
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
             gamestate= 'play'
             scrolling=true
        end 
    end

    ---------------tabla para poder usar el boton de salto 
    love.keyboard.keysPressed = {}
end

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)

    ----dibujado del suelo 
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    if gamestate=='start' then 
        love.graphics.draw(logo, 200, 0)
        love.graphics.setColor(0,0,0)
        love.graphics.setFont(dragon)
        love.graphics.printf('FLAPPY BIRD--DBZ ', 0, 64, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press START', 0, 100, VIRTUAL_WIDTH, 'center')

    elseif gamestate=='play' then 
             -- dibujado de los pipes 
        for k, pair in pairs(pipePairs) do
            pair:render()
        end
        --puntaje 
            love.graphics.setFont(mediumFont)
            love.graphics.print('Score: '.. tostring(score), 8, 250)
            love.graphics.setFont(smallFont)
            love.graphics.print('highScore: '.. tostring(highscore), 440, 20)
            love.graphics.draw(l3, 490, 5)
            --dibujado del pajaro 
             bird:render()
            ---dibujado de la parte de atras     
    elseif gamestate=='endgame' then 

        love.graphics.setFont(dragon)
        love.graphics.printf('PERDISTE GUERRERO  ', 0, 64, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: '.. tostring(score), 0, 100, VIRTUAL_WIDTH, 'center')

        love.graphics.printf('¡PRESIONA ENTER PARA VOLVER A JUGAR ', 0, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(lost, 200, 200)
    
    elseif gamestate=='previous' then
        bird:render()
        love.graphics.printf('Preparado', 0, 120, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(count), 0, 160, VIRTUAL_WIDTH, 'center')
    elseif gamestate=='dificultie' then 
        love.graphics.setFont(mediumFont)
        love.graphics.printf('SELECCIONE SU DIFICULTAD', 0, 8, VIRTUAL_WIDTH, 'center')

        love.graphics.setColor(255,0,0)
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Q)DIFICULATAD 1', -50, 120, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('W)DIFICULATAD 2', -50, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('E)DIFICULATAD 3', -50, 200, VIRTUAL_WIDTH, 'center')
    end
    
    push:finish()
end