project := `basename $PWD`
outdir := "out/"

doc:
    @mkdir -p "{{outdir}}/doc"
    ldoc --dir "{{outdir}}/doc" --project {{project}} lib/
