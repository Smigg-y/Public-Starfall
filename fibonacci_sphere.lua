--@name Fibonacci Sphere
--@author
--@shared

if CLIENT then
    local arr = {}
    
    local n = 5000
    
    local goldenRatio = (1 + math.pow(5, 0.5)) / 2
    
    local pi = 3.14159265359
    
    for i = 1, n do
        table.insert(arr, i)
        
        local theta = 2 * pi * arr[i] / goldenRatio
        local phi = math.acos(1 - 2 * (arr[i] + 0.5) / n)
            
        local x = (math.cos(theta) * math.sin(phi)) * 500
        local y = (math.sin(theta) * math.sin(phi)) * 500
        local z = math.cos(phi) * 500
            
        holograms.create(chip():getPos() + Vector(x, y, z), Angle(), "models/holograms/hq_icosphere.mdl")
    end
end
