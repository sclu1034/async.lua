local assert = require("luassert")
local spy = require("luassert.spy")
local match = require("luassert.match")

local async = require("async")

describe('async.callback', function()
    local callback = function() end
    local s

    before_each(function()
        s = spy(function(cb) assert.is_function(cb) end)
    end)

    it('calls the wrapped function', function()
        local cb = async.callback(s)
        assert.spy(s).was_not_called()

        cb(callback)
        assert.spy(s).was_called(1)
        assert.spy(s).was_called_with(match.is_function())

        cb(callback)
        assert.spy(s).was_called(2)
    end)

    it('passes arguments from the definition', function()
        local val_1 = "val_1"
        local val_2 = "val_2"
        local cb = async.callback(s, val_1, val_2)

        cb(callback)
        assert.spy(s).was_called_with(match.is_function(), match.is_same(val_1), match.is_same(val_2))
    end)

    it('passes arguments from the call', function()
        local val_1 = "val_1"
        local val_2 = "val_2"
        local cb = async.callback(s)

        cb(callback, val_1)
        assert.spy(s).was_called_with(match.is_function(), match.is_same(val_1))

        cb(callback, val_1, val_2)
        assert.spy(s).was_called_with(match.is_function(), match.is_same(val_1), match.is_same(val_2))
    end)

    it('passes all arguments in order', function()
        local val_1 = "val_1"
        local val_2 = "val_2"
        local cb = async.callback(s, val_1)

        cb(callback, val_2)
        assert.spy(s).was_called_with(match.is_function(), match.is_same(val_1), match.is_same(val_2))
    end)
end)
