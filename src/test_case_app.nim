import norm/[model,sqlite]
import std/with
import std/os
import models

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
  restart_data_base()
  var dbConn=start_db()
  
  var p1 = newProy("Nafa")
  var p2 = newProy("algo")
  insert_proy(dbConn,p1)
  insert_proy(dbConn,p2)
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

  insert_us(dbConn,us1)
  insert_us(dbConn,us2)
  insert_us(dbConn,us3)

  var someUss1=select_all_user_story(dbConn,1)
  echo "proy 1"
  for u in someUss1:
    echo u[]
  
  var someUss2=select_all_user_story(dbConn,2)
  echo "proy 2"
  for u in someUss2:
    echo u[]

  echo()
when isMainModule:

  echo("Bienvenido al test case app")
  main_point()




