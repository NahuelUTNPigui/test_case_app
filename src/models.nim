import norm/[model,sqlite]
import std/with

type
    Proyecto* = ref object of Model
        nombre*:string
proc newProy*(n=""):Proyecto=
    Proyecto(nombre:n)

type
    UserStory* = ref object of Model
        cod_proy*: int
        nombre*:string

proc newUserStory*(cod=0,n=""):UserStory=
    UserStory(cod_proy:cod,nombre:n)

type
    TestCase* = ref object of Model
        cod_user_story*: int
        nombre*: string
        expected*: string
        resultado*:string
        pass*:bool

proc newTestCase*(cod=0,nombre="",exp="",res="",pass=false):TestCase=
    TestCase(cod_user_story:cod,nombre:nombre,expected:exp,resultado:res,pass:pass)

proc start_db*():DbConn=
    var dbConn = open("database","","","")
    dbConn.createTables(newProy())
    dbConn.createTables(newUserStory())
    dbConn.createTables(newTestCase())
    return dbConn
proc insert_proy*(dbConn:DbConn,p:var Proyecto)=
    with dbConn:
        insert p

proc select_all_ps*(dbConn:DbConn,limit=50,offset=0):seq[Proyecto]=
  var somePs = @[newProy()]
  dbConn.select(somePs,"""TRUE LIMIT $1 OFFSET $2""",limit,offset)
  return somePs

proc select_all_user_story*(dbConn:DbConn,cod_proy:int,limit=50,offset=0):seq[UserStory]=
    var someUss = @[newUserStory()]
    dbConn.select(someUss,"""cod_proy = $1 LIMIT $2 OFFSET $3""",cod_proy,limit,offset)
    return someUss

proc insert_us*(dbConn:DbConn,us:var UserStory)=
    with dbConn:
        insert us