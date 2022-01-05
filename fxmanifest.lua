fx_version 'cerulean'
game 'gta5'

name         'qb-scavengerhunt'
author       'Joe Szymkowicz'
version      '1.0.1'

lua54 'yes'

dependencies {
	"qtarget",
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'config.lua',
	'server/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/*.*',
}