## Resumen de la tarea

*"Crea una aplicación que permita seleccionar una actividad (caminar, correr, andar en bici...), grabe los recorridos mostrándolos en un mapa y registre el histórico de todas las actividades"*

## Pods Utilizados

* [RealmSwift (Base de Datos)](https://github.com/realm/realm-cocoa)
* [SwiftyGif (Gif)](https://github.com/kirualex/SwiftyGif)
* [CardParts (Cartas usuarios)](https://github.com/intuit/CardParts)

## Cosas que hace o no hace la aplicación

|                |**Sí hace**                                        |**No hace**                         |
|----------------|---------------------------------------------------|------------------------------------|
|Recorridos      |Permite iniciar un nuevo recorrido.                |No permite modificarlo.             |
|                |Guarda un registro de cada recorrido.              |                                    |
|                |Permite eliminar un registro.                      |                                    |
|                |Se puede acceder a un listado de los registros y visualizar cada uno de estos.|         |
|                |Cada registro está vinculado a un usuario.         |                                    |
|                |Se crea un mapa, se traza una línea con el recorrido sobre dicho mapa, se guardan todas las coordenadas utilizadas en la BBDD, se guardan los siguientes datos: distancia total, calorías estimadas, número de pausas, fecha y tiempo.         |                   |
|Usuarios        |Permite crear un nuevo usuario.                    |No permite modificarlo.             |
|                |                                                   |No permite seleccionar entre los usuarios creados (problemas con las CardParts).|
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



#### Intro gif

![Intro](/Items%20y%20apuntes/Gifs/IntroGifs/Intro-Running-Alfada-GIF-Far.gif)
