--[[
    Copyright 2017 Matthew Hesketh <wrxck0@gmail.com>
    This code is licensed under the MIT. See LICENSE for details.
]]

local wordfilter = {}
local mattata = require('mattata')
local redis = require('mattata-redis')

function wordfilter:init()
    wordfilter.commands = mattata.commands(self.info.username):command('wordfilter').table
    wordfilter.help = '/wordfilter - View a list of words which have been added to the chat\'s word filter.'
end

function wordfilter:on_message(message, configuration, language)
    if message.chat.type ~= 'supergroup'
    then
        return mattata.send_reply(
            message,
            language['errors']['supergroup']
        )
    elseif not mattata.is_group_admin(
        message.chat.id,
        message.from.id
    )
    then
        return mattata.send_reply(
            message,
            language['errors']['admin']
        )
    end
    local words = redis:smembers('word_filter:' .. message.chat.id)
    if #words < 1
    then
        return mattata.send_reply(
            message,
            'There are no words filtered in this chat. To add words to the filter, use /filter <word(s)>.'
        )
    end
    return mattata.send_message(
        message.chat.id,
        'Filtered words: ' .. table.concat(words, ', ')
    )
end

return wordfilter