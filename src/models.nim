import norm/[model,sqlite]

type
    Proyecto* = ref object of Model
        nombre:string
proc newProy*(n:string):Proyecto=
    Proyecto(nombre:n)

let dbConn* = open(":memory:","","","")
dbConn.createTables(newProy("P"))
echo()