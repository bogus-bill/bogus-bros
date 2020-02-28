
local TICK_RATE = 1/60

-- How many Frames are allowed to be skipped at once due to lag (no "spiral of death")
local MAX_FRAME_SKIP = 10

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local lag = 0.0

    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Cap number of Frames that can be skipped so lag doesn't accumulate
        if love.timer then 
            lag = math.min(lag + love.timer.step(), TICK_RATE * MAX_FRAME_SKIP) 
        end

        while lag >= TICK_RATE do
            if love.update then love.update(TICK_RATE) end
            lag = lag - TICK_RATE
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
            
            if love.draw then love.draw(TICK_RATE) end
            love.graphics.present()
        end

        -- Even though we limit tick rate and not frame rate, we might want to cap framerate at 1000 frame rate as mentioned https://love2d.org/forums/viewtopic.php?f=4&t=76998&p=198629&hilit=love.timer.sleep#p160881
        if love.timer then love.timer.sleep(0.001) end
    end
end
