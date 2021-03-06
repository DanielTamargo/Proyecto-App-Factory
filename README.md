## Resumen de la tarea

*"Crea una aplicación que permita seleccionar una actividad (caminar, correr, andar en bici...), grabe los recorridos mostrándolos en un mapa y registre el histórico de todas las actividades"*

## Planteamiento (estructura de las ventanas y cómo se enlazan)

![Estructura](/Items%20y%20apuntes/Pantallazos/Estructura-Views.png)

## Pods Utilizados

* [RealmSwift (Base de Datos)](https://github.com/realm/realm-cocoa)
* [SwiftyGif (Gif)](https://github.com/kirualex/SwiftyGif)
* [CardParts (Cartas usuarios)](https://github.com/intuit/CardParts)

## Cosas que hace o no hace la aplicación

|                |**Sí hace**                                        |**No hace**                         |
|----------------|---------------------------------------------------|------------------------------------|
|**Recorridos**      |Permite iniciar un nuevo recorrido.                |No permite modificarlo.             |
|                |Guarda un registro de cada recorrido.              |                                    |
|                |Permite eliminar un registro.                      |                                    |
|                |Se puede acceder a un listado de los registros y visualizar cada uno de estos.|         |
|                |Cada registro está vinculado a un usuario.         |                                    |
|                |Se crea un mapa, se traza una línea con el recorrido sobre dicho mapa, se guardan todas las coordenadas utilizadas en la BBDD, se guardan los siguientes datos: distancia total, calorías estimadas, número de pausas, fecha y tiempo.         |                   |
|**Usuarios**        |Permite crear un nuevo usuario.                    |No permite modificarlo.             |
|                |El usuario guarda información tal como: nickname, sexo, altura, peso, fecha nacimiento y avatar.|No permite seleccionar entre los usuarios creados (problemas con las CardParts).|
|                |                                                   |No permite eliminar un usuario.     |


## ¿Cumple mi proyecto con la tarea pedida?
Considero que **sí** cumple con lo pedido. Aunque siempre se podrán añadir más cosas a la aplicación haciendo que esta sea mucho más completa.

## Opinión del proyecto
Creo que si le dedicas el tiempo necesario, este proyecto puede ser una de las mejores maneras de aprender. Empecé el curso bastante flojo en lo que al lenguaje Swift se refiere, pero a base de esfuerzo y constancia he conseguido llegar a entender mucho mejor de lo esperado el lenguaje que a priori me parecía muy complicado. 
Es un proyecto donde se te fuerza a aprender a buscar documentación, contrastar diferentes versiones obsoletas con la tuya actual, etc. 
En mi opinión, me ha resultado muy productivo y personalmente lo he disfrutado *(aunque algún que otro dolor de cabeza sí que me ha dado)*.

## Otros puntos del proyecto

> - He añadido un gif animado como intro de la App cuando esta se inicia.
> - He intentado diseñar un logo decente (sin mucho éxito).
> - He creado un vídeo de 'promoción' o 'anuncio' para simular el lanzamiento real de la App.
> - He intentado añadir cartas (CardParts) para poder seleccionar entre distintos usuarios, sin éxito (si esto hubiese funcionado, habría derivado también en dar la opción de editar dichos usuarios), actualmente se pueden crear varios usuarios pero siempre se usará el último creado (te avisa mediante alertas).
> - Obligo al usuario a registrar mínimo un usuario para dar uso a la aplicación.
> - He comprobado que la aplicación funcione correctamente en dispositivos con bastante diferencia de tamaño de pantalla, funciona por lo general bien, exceptuando algún problema a la hora de cuadrar la polyline al querer ver un registro de la lista en pantallas más pequeñas (no he sido capaz de solucionarlo).

## Iconos e imagenes obtenidos de

- https://www.flaticon.com
- https://www.flaticon.com/authors/freepik
- https://www.flaticon.com/authors/monkik
- https://www.flaticon.es/autores/smashicons

## Enlaces utilizados para consultar (W.I.P)

- [Varios vídeos del canal de Ion Jaureguialzo Sarasola](https://www.youtube.com/channel/UCaFf9p4OcV4w9IFjhHdL3tw)
- [Timer](https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f)
- MapKit
  * [Mostrar mapa, utilizar CoreLocation y mostrar localización usuario](https://www.youtube.com/watch?v=WPpaAy73nJc)
  * [Mostrar mapa basado en dos coordenadas](https://stackoverflow.com/questions/36996987/how-to-show-a-map-within-two-coordinates)
  * [Localización](https://www.innofied.com/implement-location-tracking-using-mapkit-in-swift/)
  * [Distancia entre dos coordenadas](https://stackoverflow.com/questions/44139786/calculate-distance-between-my-location-and-a-mapkit-pin-on-swift)
- Polyline
  * [Documentación Apple](https://developer.apple.com/documentation/mapkitjs/route/3039035-polyline)
  * [Documentación Apple 2](https://developer.apple.com/documentation/mapkit/mkpolyline)
  * [Borde Polyline](https://stackoverflow.com/questions/58810993/how-to-add-border-to-mkpolyline)
  * [Pintar Polyline 1](https://medium.com/devzy/ios-draw-polyline-via-mapkit-in-swift-9cdac6ceeecf)
  * [Pintar Polyline 2](https://www.youtube.com/watch?v=vEN5WzsAoxA)
  * [Añadir color gradiente a la Polyline (sin éxito, quizás obsoleto)](https://github.com/joeltrew/GradientPathRenderer)
- Realm
  * [Tutorial Realm](https://realm.io/docs/tutorials/realmtasks/)
  * [Tutorial Realm en Vídeo](https://www.youtube.com/watch?v=PmsJW59rNY8)
  * [Entidad con máximo ID](https://stackoverflow.com/questions/32804266/how-to-get-item-with-max-id)
- Fechas
  * [DateComponents](https://nshipster.com/datecomponents/)
  * [DateFormatter en otro lenguaje](https://stackoverflow.com/questions/46877573/using-dateformatter-in-another-language)
- [Animar Transición TabBar](https://stackoverflow.com/questions/44346280/how-to-animate-tab-bar-tab-switch-with-a-crossdissolve-slide-transition)
- [Poner un máximo de caracteres a un UITextField](https://stackoverflow.com/questions/25223407/max-length-uitextfield)
- [Cambiar el índice seleccionado del TabBar mediante código](https://stackoverflow.com/questions/25325923/programmatically-switching-between-tabs-within-swift)
- [Calculadora IMC](https://www.texasheart.org/heart-health/heart-information-center/topics/calculadora-del-indice-de-masa-corporal-imc/)
- CardParts ...
  * [Ejemplo CardPartPagedViewCardController](https://github.com/intuit/CardParts/blob/master/Example/CardParts/CardPartPagedViewCardController.swift)
  * [Tutorial 1](https://www.youtube.com/watch?v=L-f1KSPKm4I)
  * [Tutorial 2 (japonés)](https://www.youtube.com/watch?v=0KGZ6H9unP8)
- [Ajustar el aspecto y centro de una UIImageView](https://stackoverflow.com/questions/15499376/uiimageview-aspect-fit-and-center)
- [Consulta sobre Timer.fire() (no reanuda el cronómetro tras el Timer.invalidate()](https://stackoverflow.com/questions/32282415/timer-fire-not-working-after-invalidating-in-swift)
- [Format](https://stackoverflow.com/questions/24074479/how-to-create-a-string-with-format)
- [Fondo con degradado](https://www.youtube.com/watch?v=w7b6lTg6s7s)


## Manual (vídeo)

[Fuente](https://youtu.be/ktOvlhbMIQU)

[![Manual](/Items%20y%20apuntes/Pantallazos/PantallazoManual.png)](https://youtu.be/ktOvlhbMIQU)

## Intro gif

![Intro](/Items%20y%20apuntes/Gifs/IntroGifs/Intro-Running-Alfada-GIF-Far.gif)
