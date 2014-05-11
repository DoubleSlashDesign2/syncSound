-- Testing files for syncSound.lua Corona SDK module
-- Based on Electric Eggplant's Synchronied Text to Speech framework
-- Development starting point was Electric Eggplant's syncSound version 3.2 - for K2 (7/22/12)

-- Continued development by Little Pup Studios (starting 5/10/14)

---------------------------------------------------------------------------------
-- File: config.lua
---------------------------------------------------------------------------------
application = {
    content = {
        width = 800,
        height = 1200, 
        scale = "letterBox",
        fps = 30,
        
        --[[
        imageSuffix = {
            ["@2x"] = 2,
        }
        --]]
    },

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
