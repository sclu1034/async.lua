---------------------------------------------------------------------------
--- Utilities to work with asynchronous callback-style control flow.
--
-- All callbacks must adhere to the callback signature: `function(err, values...)`.
-- The first parameter is the error value. It will be `nil` if no error ocurred, otherwise
-- the error value depends on the function that the callback was passed to.
-- If no error ocurred, an arbitrary number of return values may be received as second parameter and onward.
--
-- Depending on the particular implementation of a function that a callback is passed to, it may be possible to
-- receive non-`nil` return values, even when an error ocurred. Using such return values should be considered undefined
-- behavior, unless explicitly documented by the calling function.
--
-- @module async
-- @license
--     async.lua is a set of utilities for callback-style asynchronous Lua
--     Copyright (C) 2022  Lucas Schwiderski
--
--     This program is free software: you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation, either version 3 of the License, or
--     (at your option) any later version.
--
--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
--
--     You should have received a copy of the GNU General Public License
--     along with this program.  If not, see <https://www.gnu.org/licenses/>.
---------------------------------------------------------------------------

local table_extra = require("./internal/table")

local async = {}


--- Wraps a function such that it can only ever be called once.
--
-- If the returned function is called multiple times, only the first call will result
-- in the wrapped function being called. Subsequent calls will be ignored.
-- If no function is given, a noop function will be used.
--
-- @tparam[opt] function fn The function to wrap.
-- @treturn function The wrapped function or a noop.
function async.once(fn)
    if not fn then
        fn = function(...) end -- luacheck: no unused args
    end

    local ran = false
    return function(...)
        if not ran then
            ran = true
            fn(...)
        end
        -- TODO: Decide if we want to throw/log an error when `ran == true`
    end
end


--- Turns an asynchronous function into a blocking operation.
--
-- Using coroutines, this runs a callback-style asynchronous function and blocks until it completes.
-- The function to be wrapped may only accept a single parameter: a callback function.
-- Return values passed to this callback will be returned as regular values by `wrap_sync`.
--
-- Panics that happened inside the asynchronous function will be captured and re-thrown.
--
-- @tparam function fn An asynchronous function: `function(cb)`
-- @treturn ... Any return values as passed by the wrapped function
function async.wrap_sync(fn)
    local co = coroutine.create(function()
        fn(function(...)
            coroutine.yield(...)
        end)
    end)

    local ret = table.pack(coroutine.resume(co))
    if not ret[1] then
        error(ret[2])
    else
        table.remove(ret, 1)
        return table.unpack(ret)
    end
end

--- Wrap a function with arguments for use as callback.
--
-- This is mainly used to provide a (partial) list of arguments to a callback function.
-- Arguments to this call are passed through to the provided function when it is called.
-- Arguments from the caller are appended after those.
--
-- @todo Optimize the common use cases of only having a few outer arguments
-- by hardcoding those cases.
--
-- @tparam function fn The function to wrap.
-- @tparam any ... Arbitrary arguments to pass through to the wrapped function.
-- @treturn function
function async.callback(fn, ...)
    local outer = table.pack(...)

    return function(cb, ...)
        local inner = table.pack(...)
        -- Merge, then unpack both argument tables to provide a single var arg.
        -- But keep the returned callback first, for consistency across APIs.
        local args = { cb }
        table_extra.append(args, outer)
        table_extra.append(args, inner)
        return fn(table.unpack(args))
    end
end

return async
