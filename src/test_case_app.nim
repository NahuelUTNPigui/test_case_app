import norm/[model,sqlite]
import std/with
import std/os
removeFile("database")
type
    Proyecto* = ref object of Model
        nombre:string


proc newProy*(n=""):Proyecto=
    Proyecto(nombre:n)

let dbConn* = open("database","","","")
dbConn.createTables(newProy())
var p=newProy("testing")
var p2=newProy("mas testing")
with dbConn:
  insert p
  insert p2
var somePs = @[newProy()]
dbConn.select(somePs,"""TRUE LIMIT $1 OFFSET $2""",10,0)

for p in somePs:
  echo p[]

echo()

echo("Bienvenido al test case app")
