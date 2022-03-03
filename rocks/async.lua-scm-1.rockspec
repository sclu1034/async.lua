package = "async.lua"
version = "scm-1"
source = {
    url = "git://github.com/sclu1034/async.lua"
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
        async = "lib/async/async.lua",
        ["async.internal.util"] = "lib/async/internal/util.lua"
    },
    copy_directories = {
        "doc", "examples", "tests"
    }
}
