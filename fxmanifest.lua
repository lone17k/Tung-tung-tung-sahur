fx_version 'cerulean'
game 'gta5'

author '.lone17'
description 'Lone17 - Tung tung tung sahur'
version '1.0.0'
lua54 'yes'

shared_scripts {
    'config.lua',
}
client_scripts {
    '@PolyZone/client.lua',
    'client/main.lua',
}
server_scripts {
    'server/main.lua',
}
dependencies {
    'PolyZone',
    'xsound',
    
}
files {
    'assets/tung.mp3',
    'xsound/html/sounds/tung.mp3',
}