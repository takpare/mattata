--[[
    Copyright 2017 Matthew Hesketh <wrxck0@gmail.com>
    This code is licensed under the MIT. See LICENSE for details.
]]

local dice = {}
local mattata = require('mattata')

function dice:init()
    dice.commands = mattata.commands(self.info.username):command('dice').table
    dice.help = '/dice <number> <range> - Rolls a die - returning random numbers between 1 and the given range the given number of times.'
end

function dice:on_message(message, configuration, language)
    local input = mattata.input(message.text)
    if not input
    then
        return mattata.send_reply(
            message,
            dice.help
        )
    end
    local count, range
    if input:match('^(%d*) (%d*)$')
    then
        count, range = input:match('^(%d*) (%d*)$')
    end
    if not count
    or not range
    then
        return mattata.send_reply(
            message,
            dice.help
        )
    end
    if tonumber(range) < configuration.dice.min_range
    then
        return mattata.send_reply(
            message,
            string.format(
                language['dice']['1'],
                configuration.dice.min_range
            )
        )
    elseif tonumber(range) > configuration.dice.max_range
    or tonumber(count) > configuration.dice.max_count
    then
        if configuration.dice.max_range == configuration.dice.max_count
        then
            return mattata.send_reply(
                message,
                string.format(
                    language['dice']['2'],
                    configuration.dice.max_range
                )
            )
        end
        return mattata.send_reply(
            message,
            string.format(
                language['dice']['3'],
                configuration.dice.max_range,
                configuration.dice.max_count
            )
        )
    end
    local output = string.format(
        language['dice']['4'],
        count,
        range
    )
    local results = {}
    for i = 1, tonumber(count)
    do
        table.insert(
            results,
            math.random(
                tonumber(range)
            )
        )
    end
    return mattata.send_message(
        message.chat.id,
        output .. '<pre>' .. table.concat(
            results,
            ', '
        ) .. '</pre>',
        'html'
    )
end

return dice