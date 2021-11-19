fx_version 'cerulean'
games {'gta5'}

author 'mn#0810'
description 'mn-cardealer'
version '1.0.0'

client_scripts { -- Client side Scripts
    "client/*",
    "config.lua"
}

server_scripts {
    "server/*",
    "config.lua",
    '@mysql-async/lib/MySQL.lua'
}


dependency {
    'es_extended',
    'mn-helpnotify'
}
