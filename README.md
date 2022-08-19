# test_case_app
Es una aplicacion de comandos para gestionar test cases
Por ahora puramente CLI


## Modelos
Todos tienen un campo entero auto incremental llamado id manejado por norm
### Proyecto
* nombre string
### UserStory
* cod_proy int (FK)
* nombre string
### TestCase
* cod_user_story int (FK)
* nombre/descripcion string
* expected string
* result string
* pass int (0 si, 1 mas o menos, 2 no)
### Paso
* cod_test_case ing (FK)
* orden int (Estaria bueno que no haya 2 pasos con el mismo orden)
* nombre string
* valor string
