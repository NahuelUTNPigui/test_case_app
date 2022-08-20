import norm/[model,sqlite]
import std/with
import std/os
import models
import cli_gui
proc restart_data_base()=
  removeFile("database")
proc play()=
  restart_data_base()
  type
      Proyecto = ref object of Model
          nombre:string


  proc newProy(n=""):Proyecto=
      Proyecto(nombre:n)

  let dbConn = open("database","","","")
  
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

proc main_point()=
  
  var dbConn=restart_db()
  
  var p1 = newProy("Nafa")
  var p2 = newProy("algo")
  insert_t(dbConn,p1)
  insert_t(dbConn,p2)
  #with dbConn:
  #  insert p1
  #  insert p2
  #var somePs = @[newProy()]
  #dbConn.select(somePs,"""TRUE LIMIT $1 OFFSET $2""",10,0)
  var somePs=select_all_ps(dbConn)
  for p in somePs:
    echo p[]

  var us1=newUserStory(1,"probando")
  var us2=newUserStory(1,"testeando")
  var us3=newUserStory(2,"looking")

  insert_t(dbConn,us1)
  insert_t(dbConn,us2)
  insert_t(dbConn,us3)

  var someUss1=select_all_user_story(dbConn,1)
  echo "proy 1"
  for u in someUss1:
    echo u[]
  
  var someUss2=select_all_user_story(dbConn,2)
  echo "proy 2"
  for u in someUss2:
    echo u[]

  var tc_1=newTestCase(1,"probando us1","todo bien","todo bien",2)
  insert_t(dbConn,tc1)

  var paso1=newPaso(1,"paso 1",2)
  var paso2=newPaso(1,"paso 2",3)
  var paso3=newPaso(1,"paso 3",1)
  insert_t(dbConn,paso1)
  insert_t(dbConn,paso2)
  insert_t(dbConn,paso3)

  var somePasos=select_all_pasos(dbConn,1)
  for p in somePasos:
    echo p[]
when isMainModule:

  echo("Bienvenido al test case app")
  when declared(commandLineParams):
    if(len(commandLineParams())>0):
      var opcion=commandLineParams()[0]
      if(cmp(opcion,"seed")==0):
        restart_data_base()
    else:
      menu_principal()

