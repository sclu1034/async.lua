local assert = require("luassert")
local spy = require("luassert.spy")
local match = require("luassert.match")

local async = require("async")

describe('async.waterfall', function()
    it('calls the final callback', function()
        local s = spy(function() end)
        async.wrap_sync(function(cb)
            async.waterfall({}, function(...)
                s(...)
                cb(...)
            end)
        end)
        assert.spy(s).was_called_with()
    end)

    it('runs a task', function()
        local task = spy(function(cb) cb() end)
        async.wrap_sync(function(cb)
            async.waterfall({ task }, cb)
        end)
        assert.spy(task).was_called()
    end)

    it('passes values between tasks', function()
        local val = "value"

        local task_1 = spy(function(cb) cb(nil, val) end)
        local task_2 = spy(function(cb, arg)
            assert.is_same(val, arg)
            cb()
        end)

        async.wrap_sync(function(cb)
            async.waterfall({
                task_1,
                task_2,
            }, cb)
        end)
        assert.spy(task_1).was_called()
        assert.spy(task_2).was_called_with(match.is_function(), match.is_same(val))
    end)

    it('skips to final callback on error', function()
        local val = "error"
        local task_1 = spy(function(cb) cb(val) end)
        local task_2 = spy(function(cb) cb() end)

        local err = async.wrap_sync(function(cb)
            async.waterfall({
                task_1,
                task_2,
            }, cb)
        end)

        assert.spy(task_1).was_called()
        assert.spy(task_2).was_not_called()
        assert.is_same(val, err)
    end)
end)