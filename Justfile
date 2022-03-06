outdir := "out"

doc:
    @mkdir -p "{{outdir}}/doc" "{{outdir}}/src"
    sh tools/process_docs.sh "{{outdir}}"
    ldoc --config=doc/config.ld --dir "{{outdir}}/doc" --project async.lua "{{outdir}}/src"
    sass doc/ldoc.scss "{{outdir}}/doc/ldoc.css"

test *ARGS:
    busted --config-file=.busted.lua --helper=tests/_helper.lua {{ARGS}} tests

check *ARGS:
    find src/ -iname '*.lua' | xargs luacheck {{ARGS}}

@ci:
    find src/ -iname '*.lua' | xargs luacheck --formatter TAP
    busted --config-file=.busted.lua --helper=tests/_helper.lua --output=TAP tests

make version="scm-1":
    luarocks --local make rocks/async.lua-{{version}}.rockspec

clean:
    rm -r "{{outdir}}"
