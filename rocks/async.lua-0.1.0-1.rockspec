package = "async.lua"
version = "0.1.0-1"
source = {
    url = "git://github.com/sclu1034/async.lua"
    tag = "v0.1.0"
}
description = {
    summary = "Utilities for callback-style asynchronous Lua",
    homepage = "https://github.com/sclu1034/async.lua",
    license = "GPLv3"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        async = "lib/async.lua",
        ["async.internal.table"] = "lib/internal/table.lua"
    },
    copy_directories = {
        "doc", "examples", "tests"
    }
}
