fx_version 'cerulean'
game 'gta5'

lua54 'yes'

dependencies {
	"qb-target",
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