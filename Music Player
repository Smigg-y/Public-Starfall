--@name Music Player
--@author
--@shared

if SERVER then

    hook.add( "playerSay", "", function( ply, txt )
        if ply == owner() and txt:sub( 1, 4 ) == "!req" then
            net.start( "args" )
            net.writeString( txt:sub( 7 ) )
            net.send()
            
            return ""
        end
    end )

else
    
    local url = nil
    local convert = "http://ytapi.gaerisson-softs.fr/?key=  !!ADD YOUR API KEY IN HERE!!  &steamid=  !!ADD YOUR STEAM ID IN HERE!!  &url=https://youtu.be/"
    local search = "https://www.googleapis.com/youtube/v3/search?key=  !!ADD YOUR API KEY IN HERE!!  &type=video&part=snippet&maxResults=1&q="
    
    local function fancyChat( error, txt )
        if error > 0 then color = Color( 0, 255, 0 ) else color = Color( 255, 0, 0 ) end
        print( color, "| ", Color( 255, 255, 255 ), txt )
    end
    
    local n, fft, mul = 14, {}, 10
    
    local function playSong( url )
        if song then song:stop() end
        bass.loadURL( url, "3d noblock", function( snd )
            if snd then
                song = snd
                snd:setVolume( 1 )
                snd:setFade( 500 , 5000 )
                        
                hook.add( "think", "", function( )
                    if isValid( snd ) then
                        snd:setPos( radio:getPos() )
                        fft = snd:getFFT( 1 )
                    end
                end )
            end
        end )
        
        url = nil
    end
    
    local function request( id )
        timer.create( "delay", 2, 1, function()
            fancyChat( 1, "Requesting..." )
            http.get( convert .. id, function( body )
                if body:sub( 1, 6 ) == "<br />" then
                    local split = string.split( body, "/>" )
                    local data = json.decode( split[3] )
                    playSong( data[1]["url"] )
                else
                    local data = json.decode( body )
                    playSong( data[1]["url"] )
                end
            end )
            
        end )
    end
    
    net.receive( "args", function()
        local args = net.readString()
        
        fancyChat( 1, "Searching..." )
        http.get( search .. http.urlEncode( args ), function( body )
            local data = json.decode( body )
            if table.count( data ) < 6 then
                fancyChat( 0, "An issue has occurred fetching this video." )
            else
                request( data["items"][1]["id"]["videoId"] )
            end
        end )
    end )
    
    local mat = material.load( "sprites/light_glow02_add" )
    local curSize, size = 0, 65

    local radio = holograms.create( chip():getPos() + Vector( 0, 0, 35 ), Angle(), "models/props_lab/citizenradio.mdl" )
    local emitter = particle.create( radio:getPos(), false )
    
    timer.create( "animation", 0, 0, function()
        emitter:setPos( radio:getPos() )
        
        curSize = ( curSize * 0.98 ) + ( size * 0.02 )
        local dir = ( math.random( 0, 360 ) + timer.curtime() * 50 ) % 360        
        local p = emitter:add( mat, radio:getPos() + Angle( 0, dir, 0 ):getForward() * ( curSize / 2 ), 10, 1, 10, 1, 255, 0, 1.25 )      
            p:setRoll( math.random( -90, 90 ) )
            p:setVelocity( Vector( 0, 0, 25 + ( math.random( 0.1, 0.7 ) * 30 ) ) )
            p:setCollide( true )
            p:setBounce( 0.25 )
            
            local amount = emitter:getNumActiveParticles()
            
            p:setColor( Color( ( timer.curtime() * 100 + amount * 5 ) % 360, 1, 1 ):hsvToRGB() )
        
        radio:setPos( chip():getPos() + Vector( 0, 0, 35 + math.sin( timer.curtime() * 2 ) * 5 ) )
        radio:setAngles( Angle( math.cos( timer.curtime() * 2 ) * 3, timer.systime() * 25 + math.cos( timer.curtime() * 2 ) * 3, math.cos( timer.curtime() * 2 ) * 3 ) )
    end )

    hook.add( "postdrawtranslucentrenderables", "", function()                
        for i = 1, n do
            local deg = ( math.pi / n * i / 1.8 )
            local x, y = deg, 0
            local pos = Vector( 0.75, x - 0.70, y + 1.175 ) * mul

            render.setColor( Color( ( ( timer.curtime() * 60 ) + ( i * 5 ) ) % 360, 1, 1 ):hsvToRGB() )
            render.draw3DBox( radio:localToWorld( pos ), radio:getAngles(), Vector(), Vector( 1, 1.1, 1 + ( fft[ i % ( n ) ] or 0 ) * 3.5 ) )
        end       
    end )
    
end
