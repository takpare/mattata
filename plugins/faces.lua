--[[
    Copyright 2017 Matthew Hesketh <wrxck0@gmail.com>
    This code is licensed under the MIT. See LICENSE for details.
]]

local faces = {}
local mattata = require('mattata')

function faces:init(configuration)
    faces.commands = mattata.commands(self.info.username):command('faces').table
    faces.help = 'Faces:\n'
    for k, v in pairs(configuration.faces)
    do
        faces.help = faces.help .. '• /' .. k .. ': ' .. v .. '\n'
        table.insert(
            faces.commands,
            '^[/!$]' .. k
        )
    end
end

function faces:on_message(message, configuration)
    if message.text:match('^%/faces')
    then
        return mattata.send_reply(
            message,
            faces.help
        )
    end
    for k, v in pairs(configuration.faces)
    do
        if message.text:match('[/!$]' .. k)
        then
            return mattata.send_message(
                message.chat.id,
                v,
                'html'
            )
        end
    end
end

return faces