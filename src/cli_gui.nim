import std/parseutils
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
proc menu_principal*()=
    echo "Hola"
    echo "Escriba la opcion que desee"
    echo "1) Para ver todos los proyectos"
    echo "2) Para salir"
    var opcion=tomar_opcion(1,2)
    
    while opcion==1:
        echo "Escriba la opcion que desee"
        echo "1) Para ver todos los proyectos"
        echo "2) Para salir"
        opcion=tomar_opcion(1,2)
        if(opcion==1):
            ver_todos_los_proyectos()
        if(opcion==2):
            salir()
    