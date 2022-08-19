import std/parseutils
import tables
proc tomar_opcion(inicio=0,fin:int,mensaje=""):int=
    var consoleInput=readLine(stdin)
    
    var opcion:int
    var chars=parseInt(consoleInput,opcion,0)
    while chars==0 or opcion<inicio or opcion>fin:
        if(cmp(mensaje,"")==0):
            echo "Escriba un numero entre " & $inicio & " y " & $fin
        else:
            echo mensaje
        consoleInput=readLine(stdin)
        chars=parseInt(consoleInput,opcion,0)
    return opcion
proc ver_todos_los_proyectos()=
    echo "Todos los proyectos"
proc salir()=
    echo "Chau"

#Siempre el primero metodo es para salir
proc menu_generico(mensaje_inicial="Hola",mensajes_opciones:seq[string],opcion_inicio=1,opcion_fin=2,opcion_accion:Table[int,proc()])=
    echo mensaje_inicial
    var i=0
    var opcion:int = -1
    while i==0 or opcion>opcion_inicio and opcion<=opcion_fin:
        i=1
        for m in mensajes_opciones:
            echo m
        opcion=tomar_opcion(opcion_inicio,opcion_fin)
        opcion_accion[opcion]()
proc create_mensajes_opciones_menu_inicial():seq[string]=
    var mensajes_opciones = @["1) Para salir"]
    mensajes_opciones.add("2) Para ver los proyectos")
    return mensajes_opciones
proc create_table_menu_inicial():Table[int,proc()]=
    var opcion_accion=initTable[int,proc()]()
    opcion_accion[1]=salir
    opcion_accion[2]=ver_todos_los_proyectos
    return opcion_accion
proc menu_principal*()=
    let mensaje_inicial="Hola dev"
    var mensajes_opciones =create_mensajes_opciones_menu_inicial()
    var opcion_accion=create_table_menu_inicial()
    menu_generico(mensaje_inicial,mensajes_opciones,1,2,opcion_accion)