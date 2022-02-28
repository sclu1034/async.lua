project := `basename $PWD`
outdir := "out"
lua_exe := "lua"

doc:
    @mkdir -p "{{outdir}}/doc" "{{outdir}}/lib"
    @sh tools/process_docs.sh "{{outdir}}"
    ldoc --config=doc/config.ld --dir "{{outdir}}/doc" --project {{project}} "{{outdir}}/lib"

busted *ARGS:
    busted --config-file=.busted.lua --helper=tests/_helper.lua {{ARGS}} tests

clean:
    rm -r "{{outdir}}"
