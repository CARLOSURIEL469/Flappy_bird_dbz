
-------CREADO POR CARLOS URIEL CASTILLO DE LA ROSA 

-----------------------------------
ESTE PROYECTO CONSISTE EN LA IMPLEMENTACION DE UN FLAPPY BIRD. 

//////PARA UN GUSTO PERSONAL, ESTE PROYECTO TIENE TEMATICA DE DRAGON BALL Z \\\\\


EL PROYECTO CONTIENE 
	6 archivos lua 
*main
*push
*class
*bird
*pipe
*PipePair

con 17 archivos de imagen 
3 de font 
y 6 sonidos 

el proyecto esta contenido en esas clases- las clases bird estipula movimiento del jugador y la gravedad
asi mismo, permite la creacino de pipes deacuerdo a un intervalo de tiempo 


/----mi maquina de estados 
/pantalla de inicio 'start'------------inicializa la pantalla de inicio con el titulo de press enter
					asi mimsmo , inicia la musica de y animacino del fondo
					en caso de opromir enter, el juego pasa al estado dificulty 
					
/dificultad 'dificulty'----------------este estado permite iniciar el juego con 3 niveles de dificultad
					esta dificultad cambia la gravedad que influye a la nave y velocidad de aparicion de los pipes
					los niveles permanecen en todas las partidas futuras 
					niveles q=1 w=2 e=3
					cuando se eleija el nivel de dificultad se pasa al estado play

/playstate 'play'----------------------inicializa el spawn de los pies y moviemiento de gravedad de la pelota asi como permitir brincar 
					inicia musica para diferentes accinoes. este estado permanecera siempre y cuando no se toque un pipe o el suelo 
					cada vez que pase por dos pipes sin tocarlo, el marcador aunmenta 1 y se guarda
					al final de un partida se guarda el score mas alto de todas 
					tiene aumento de velocidad en 5,15,30 puntos para hacerlo ams dificil 
					cuando se pierde, se pasa el estado end game 

/muerte 'endgame'-----------------------muetra el puntaje obtenido y un mensaje diferente en caso de haber muerto por el suelo o por el pipe
					asi mismo deja volver a iniciar un juego para probarlo de nuevo
					en caso de reiniciar, se pasa al estado reinicio

/reinicio 'previous '-------------------este estado muestra un temporizador para su inicio en caso de que el usuario no presione enter antes 
					reinicia la posicino de la nave y de los pipes para comenzar una partida nueva 



