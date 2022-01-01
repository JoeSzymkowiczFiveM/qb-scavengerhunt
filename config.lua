Config = {}

Config.ScavengerBoss = 'IOM87780' --this is the citizenid of the person in charge of the scavenger hunt.

Config.Teams = {}

Config.Hunts = {
    [1] = {
        ["completed"] = false,
        ["type"] = "ped",
        ["model"] = "player_zero",
        ["coords"] = vector4(-813.070861, 179.6125488, 72.15914154, 114.5794601),
        ["gender"] = "male",
		["animDict"] = "amb@world_human_stand_impatient@female@no_sign@base",
		["animName"] = "base",
        ["isRendered"] = false,
        ["entity"] = nil,
        ["clue"] = "I had some wild times in the single player game with my acquaintances, Franklin and Trevor. You can find me relaxing at my house.",
    },
    [2] = {
        ["completed"] = false,
        ["type"] = "object",
        ["model"] = "v_res_fa_book03",
        ["coords"] = vector4(293.1302185, 183.5417785, 104.2938385, 245.9309082),
        --["gender"] = "female",
		--["animDict"] = "amb@world_human_stand_impatient@female@no_sign@base", 
		--["animName"] = "base",
        ["isRendered"] = false,
        ["entity"] = nil,
        ["clue"] = "You can find books anywhere. Even laying around on the Walk of Fame. Interesting subject...",
    },
    [3] = {
        ["completed"] = false,
        ["type"] = "item",
        ["name"] = "coffee",
        ["clue"] = "Fresh cup of joe. Can't start my morning without it.",
    },
    [4] = {
        ["completed"] = false,
        ["type"] = "ped_giveitem",
        ["model"] = "player_one",
        ["coords"] = vector4(-18.2927074, -1440.60241, 31.10155296, 322.0364685),
        ["gender"] = "male",
		["animDict"] = "amb@world_human_stand_impatient@female@no_sign@base", 
		["animName"] = "base",
        ["isRendered"] = false,
        ["entity"] = nil,
        ["clue"] = "I've moved up out the hood, but I'm at my aunt's house, back in my old room. I've got something for you to complete the task.",
        ["reward_item"] = "rolex",
    },
    [5] = {
        ["completed"] = false,
        ["type"] = "item",
        ["name"] = "coffee",
        ["clue"] = "Pickup a coffee. Another coffee task?! Seriously? Fine. Coffee it is.",
    },
    [6] = {
        ["completed"] = false,
        ["type"] = "boxzone",
        ["coords"] = vector3(2568.5, 2571.87, 33.26),
        ["width"] = 7.4,
        ["height"] = 12.6,
        ["heading"] = 327,
        ["minZ"] = 33.26,
        ["maxZ"] = 47.66,
        ["isRendered"] = false,
        ["clue"] = "Say Hi to Barney for me. Tell him that 'I love you, you love me' song is still stuck in my brain.",
    },
    [7] = {
        ["completed"] = false,
        ["type"] = "item",
        ["name"] = "coffee",
        ["clue"] = "Pickup a coffee. YET ANOTHER COFFEE TASK?!?!?!? What is with this guy and coffee? FINE!",
    },
    [8] = {
        ["completed"] = false,
        ["type"] = "item",
        ["name"] = "coffee",
        ["clue"] = "Pickup a coffee. Find Coffee again?!!? This just seems like a lazy scavenger hunt.",
    },
    [9] = {
        ["completed"] = false,
        ["type"] = "item",
        ["name"] = "lockpick",
        ["clue"] = "Finally, something other than a coffee. With this item, you will be definitely opening some doors and going places.",
    },
    [10] = {
        ["completed"] = false,
        ["type"] = "item",
        ["name"] = "coffee",
        ["clue"] = "Pickup a coffee. GOD DAMNIT?!?! Fine, let's get this scavenger hunt over with.",
    },
}