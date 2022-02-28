-- async.lua is a set of utilities for callback-style asynchronous Lua
-- Copyright (C) 2022  Lucas Schwiderski
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
local module = {}

--- Append items from the source table to the target table.
--
-- Note that this only considers the array part of `source` (same semantics
-- as `ipairs`).
-- Nested tables are copied by reference and not recursed into.
--
-- @tparam table target The table to append values to.
-- @tparam table source The table to copy values from.
-- @treturn table The target table.
function module.append(target, source)
    for _, v in ipairs(source) do
        table.insert(target, v)
    end

    return target
end

return module
