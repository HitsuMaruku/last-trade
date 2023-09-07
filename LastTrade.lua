_addon.name = 'LastTrade'
_addon.author = 'Aoisa'
_addon.commands = {'lasttrade','lt'}
_addon.version = '0.1.0'
_addon.lastUpdate = '2024.09.07'

packets = require('packets')

local TRADE_CHUNK_ID = 0x036
local lastTradeData = nil

-- #region Hooks
windower.register_event('outgoing chunk', function(id, data)
    if id == TRADE_CHUNK_ID then
        lastTradeData = packets.parse('outgoing', data)
    end
end)

windower.register_event('addon command', function (command,...)
	command = command and command:lower() or 'help'
	-- local args = T{...}
    -- local arg_str = windower.convert_auto_trans(table.concat(args, ' '))

    if S{'reload', 'r','unload', 'u'}:contains(command) then
        windower.send_command(('lua %s %s'):format(command, _addon.name))
	elseif S{'trade', 't'}:contains(command) then
		trade()
	elseif S{'status', 's'}:contains(command) then
		print_status()
    elseif S{'help', 'h', '--help'}:contains(command) then
        print_help()
	else
		windower.add_to_chat(123, ('%s Error: Unknown command.'):format(_addon.name))
	end
end)

windower.register_event('load', function()
    lastTradeData = nil
end)

windower.register_event('logout', function()
    windower.send_command(('lua unload %s'):format(_addon.name))
end)

windower.register_event('zone change', function(new_id, old_id)
    lastTradeData = nil
end)

-- windower.register_event('job change', function()

-- end)

-- windower.register_event('prerender', function()

-- end)
-- #endregion

-- #region Methods
function trade()
    if (lastTradeData == nil) then
        windower.add_to_chat(123, 'No trade recorded.')
        return
    end

    local newTradePacket = packets.new('outgoing', TRADE_CHUNK_ID, lastTradeData)
    packets.inject(newTradePacket)
end

function print_status()
    if (lastTradeData == nil) then
        windower.add_to_chat(123, 'No trade recorded.')
        return
    end

    -- windower.add_to_chat(1, table.tostring(lastTradeData))
    -- TODO: Should we get these from fields.lua?
    local chunkFields = {
        'Target',
        'Item Count 1', 'Item Count 2', 'Item Count 3', 'Item Count 4', 'Item Count 5', 'Item Count 6', 'Item Count 7', 'Item Count 8', 'Item Count 9',
        '_unknown1',
        'Param 1',
        'Item Index 1', 'Item Index 2', 'Item Index 3', 'Item Index 4', 'Item Index 5', 'Item Index 6', 'Item Index 7', 'Item Index 8', 'Item Index 9',
        '_unknown2',
        'Target Index',
        'Number of Items',
        '_data',
    }
    windower.add_to_chat(1, 'Last trade details:')
    -- TODO: Translate IDs to item names, format counts with indexes.
    for i, v in ipairs(chunkFields) do
        windower.add_to_chat(1, ('%s: %s'):format(v, lastTradeData[v] or '(nil)'))
    end
end

function print_help()
    local help = T{
        ['t, trade'] = 'Repeat the last trade initiated.',
        ['s, status'] = 'Display details about the last trade initiated.',
        ['h, help'] = 'Display this help message.',
    }
    -- local mwwidth = col_width(help:keys())
    windower.add_to_chat(263, ('%s commands:'):format(_addon.name))
    for cmd,desc in pairs(help) do
        windower.add_to_chat(263, ('%s: %s'):format(cmd:rpad(' ', 12), desc))
    end
end
-- #endregion
