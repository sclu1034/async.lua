outdir := "out"
lua_exe := "lua"

doc:
    @mkdir -p "{{outdir}}/doc" "{{outdir}}/src"
    @sh tools/process_docs.sh "{{outdir}}"
    ldoc --config=doc/config.ld --dir "{{outdir}}/doc" --project async.lua "{{outdir}}/src"

test *ARGS:
    busted --config-file=.busted.lua --helper=tests/_helper.lua {{ARGS}} tests

check *ARGS:
    find lib/ -iname '*.lua' | xargs luacheck {{ARGS}}

@ci:
    find lib/ -iname '*.lua' | xargs luacheck --formatter TAP
    busted --config-file=.busted.lua --helper=tests/_helper.lua --output=TAP tests

make version="scm-1":
    luarocks --local make rocks/async.lua-{{version}}.rockspec

clean:
    rm -r "{{outdir}}"
