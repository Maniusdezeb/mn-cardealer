MN = {}



MN = {}

MN.testdrivetime = 120 -- seconden

MN.WebHook = ""


MN.Cardealers = {
    ["Premium deluxe motorsport"] = {
        marker = vector3(-33.59185, -1101.784, 26.42235),
        vehicles = {
            [1] = {
                label = "Compact",
                vehicles = {
                    [1] = {
                        label = 'Lamborghini Aventador SV',
                        model = 'blista',
                        price = 35000
                    },
                    [2] = {
                        label = 'Elegy',
                        model = 'elegy',
                        price = 25000
                    },
                }
            },
            [2] = {
                label = "Sport",
                vehicles = {
                    [1] = {
                        label = 'Bugatti Veyron',
                        model = 'adder',
                        price = 40000
                    },
                    [2] = {
                        label = 'T20',
                        model = 't20',
                        price = 50000
                    },
                },
            },
        },
        CamSettings = { 
            camcoords = vector3(-44.27112, -1099.573, 26.82235),
            fov = 50.0
        },
        vehshowcase = vector4(-48.74387, -1096.614, 26.42234, 247.5464),
        vehspawn = vector4(-49.83476, -1110.784, 26.43581, 78.28138),
        testplate = "TESTDRIVE",

        cutscene = { 
            pedcoords = vector4(-30.25519, -1104.998, 26.42236, 158.5286),
            npc_coords= vector4(-30.94632, -1106.523, 26.42236, 342.5061),
            cam_coords = vector3(-31.36026, -1102.746, 26.92236)
        },

        Blip = {
            enabled = true,
            sprite = 225,
            color = 3,
            label = "Cardealer",
            scale = 0.6
        }

    }
}

