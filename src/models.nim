import norm/[model,sqlite]
import std/[with,algorithm]
import sugar
type
    Proyecto* = ref object of Model
        nombre*:string
proc newProy*(n=""):Proyecto=
    Proyecto(nombre:n)
proc showProy*(p:Proyecto)=
    echo "{ id: " & $p.id & " , nombre: " & $p.nombre & "}"
type
    UserStory* = ref object of Model
        cod_proy*: int
        nombre*:string

proc newUserStory*(cod=0,n=""):UserStory=
    UserStory(cod_proy:cod,nombre:n)
proc showStory*(us:UserStory)=
    echo "{ id: " & $us.id & " , nombre: " & $us.nombre & "}"
type
    Bug* = ref object of Model
        cod_user_story*: int
        descripcion*: string

proc newBug*(cod=0,descripcion=""):Bug=
    Bug(cod_user_story:cod,descripcion:descripcion)
proc showBug*(b:Bug)=
    echo "{ id: " & $b.id & " , descripcion: " & $b.descripcion & "}"
type
    TestCase* = ref object of Model
        cod_user_story*: int
        nombre*: string
        expected*: string
        resultado*:string
        #0 si 1 maso 2 no
        pass*:int

proc newTestCase*(cod=0,nombre="",exp="",res="",pass=0):TestCase=
    TestCase(cod_user_story:cod,nombre:nombre,expected:exp,resultado:res,pass:pass)
proc showTestCase*(ts:TestCase)=
    let pass=(case ts.pass 
        of 0:"si"
        of 1:"maso" 
        else:"no")
    echo "{ id: " & $ts.id & ", nombre: " & $ts.nombre & ", esperado: " & $ts.expected & ", resultado: " & $ts.resultado & " pass: " & $pass & "}"
type
    Paso* = ref object of Model
        cod_test_case* : int
        orden* : int
        descripcion* : string

proc newPaso*(cod=0,descripcion="",orden=0):Paso=
    Paso(cod_test_case:cod,descripcion:descripcion,orden:orden)
proc showPaso*(p:Paso)=
    echo "{ id: " & $p.id & " ,orden: " & $p.orden & " ,descipcion: " & $p.descripcion & "}"
proc cmp_pasos(p1,p2:Paso):int=
    cmp(p1.orden,p2.orden)

proc restart_db*():DbConn=
    var dbConn = open("database","","","")
    dbConn.createTables(newProy())
    dbConn.createTables(newUserStory())
    dbConn.createTables(newTestCase())
    dbConn.createTables(newPaso())
    dbConn.createTables(newBug())
    return dbConn
proc start_db*():DbConn=
    open("database","","","")
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

proc select_all_bugs*(dbConn:DbConn,cod_user:int,limit=50,offset=0):seq[Bug]=
    var someBs = @[newBug()]
    dbConn.select(someBs,"""cod_user_story = $1 LIMIT $2 OFFSET $3""",cod_user,limit,offset)
    return someBs

proc insert_t*[T](dbConn:DbConn,t : var T)=
    with dbConn:
        insert t
proc update_t*[T](dbConn:DbConn,t: var T)=
    dbConn.update(t)
proc delete_t*[T](dbConn:DbConn,t : var T)=
    dbConn.delete(t)

#Show cosas
proc show_ts*[T](ls:seq[T],show:proc(t:T))=
    for t in ls:
        show(t)

proc show_all_ps*(dbConn:DbConn)=
    let ps=select_all_ps(dbConn)
    show_ts(ps,showProy)