project := `basename $PWD`
outdir := "out/"

doc:
    @mkdir -p "{{outdir}}/doc"
    ldoc --dir "{{outdir}}/doc" --project {{project}} lib/

busted *ARGS:
    busted --config-file=.busted.lua --helper=tests/_helper.lua {{ARGS}} tests
