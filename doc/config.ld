project = 'async.lua'
title = 'async.lua'
description = 'Utilities for callback-style asynchronous Lua'

template = true
style = true

format = 'discount'

pretty = 'lua'
prettify_files = 'show'
backtick_references = false
wrap = true
no_space_before_args = true

local function format_asynctreturn(tag, raw, item, md)
    local type, name, description = raw:match("([^%s]+) ([^%s]+) (.*)")
    local fmt = '<span class="parameter">%s</span> <span class="types">%s</span> <span>%s</span>'
    local type_ref = type
    if type ~= "any" then
        local type_fmt = '@{%s}'
        type_ref = md(type_fmt:format(type))
    end

    return fmt:format(name, type_ref, md(description))
end

custom_tags = {
    {
        "asynctreturn",
        title = "Callback parameters",
        format = format_asynctreturn
    }
}
