import norm/[model,sqlite]
import std/[with,algorithm]
import sugar
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
        pass*:int

proc newTestCase*(cod=0,nombre="",exp="",res="",pass=0):TestCase=
    TestCase(cod_user_story:cod,nombre:nombre,expected:exp,resultado:res,pass:pass)

type
    Paso* = ref object of Model
        cod_test_case* : int
        orden* : int
        descripcion* : string
        valor* : string

proc newPaso*(cod=0,descripcion="",orden=0,valor=""):Paso=
    Paso(cod_test_case:cod,descripcion:descripcion,orden:orden,valor:valor)
proc cmp_pasos(p1,p2:Paso):int=
    cmp(p1.orden,p2.orden)

proc start_db*():DbConn=
    var dbConn = open("database","","","")
    dbConn.createTables(newProy())
    dbConn.createTables(newUserStory())
    dbConn.createTables(newTestCase())
    dbConn.createTables(newPaso())
    return dbConn

proc select_all_ps*(dbConn:DbConn,limit=50,offset=0):seq[Proyecto]=
  var somePs = @[newProy()]
  dbConn.select(somePs,"""TRUE LIMIT $1 OFFSET $2""",limit,offset)
  return somePs

proc select_all_user_story*(dbConn:DbConn,cod_proy:int,limit=50,offset=0):seq[UserStory]=
    var someUss = @[newUserStory()]
    dbConn.select(someUss,"""cod_proy = $1 LIMIT $2 OFFSET $3""",cod_proy,limit,offset)
    return someUss

proc select_all_test_case*(dbConn:DbConn,cod_user:int,limit=50,offset=0):seq[TestCase]=
    var someTcs = @[newTestCase()]
    
    dbConn.select(someTcs,"""cod_user_story = $1 LIMIT $2 OFFSET $3""",cod_user,limit,offset)
    return someTcs

proc select_all_pasos*(dbConn:DbConn,cod_test:int,limit=50,offset=0):seq[Paso]=
    var somePs= @[newPaso()]
    dbConn.select(somePs,"""cod_test_case = $1 LIMIT $2 OFFSET $3""",cod_test,limit,offset)
    somePs.sort(cmp_pasos)
    return somePs


proc insert_t*[T](dbConn:DbConn,t : var T)=
    with dbConn:
        insert t
proc update_t*[T](dbConn:DbConn,t: var T)=
    dbConn.update(t)
proc delete_t*[T](dbConn:DbConn,t : var T)=
    dbConn.delete(t)