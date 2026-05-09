#hereda de godot las fisicas , colisiones, etc
extends CharacterBody2D

#constantess, no cambian a lo largo de la ejecucion del programa
const VELOCIDAD = 200.0 #velocidad de movimiento del jugador
const GRAVEDAD = 900.0  #que tan rapido cae el personaje 
const FUERZA_SALTO = -400.0 # negativo pq en gdscritpt la y esta arriba 

# ===============================================================

func _physics_process(delta):#  función interna que se ejecuta automáticamente en 
							 #  cada frame de física (por defecto 60 veces por segundo

	if Input.is_action_pressed("RIGHT"): #movimiento hacia la derecha en el eje x
		velocity.x = VELOCIDAD
		
	elif Input.is_action_pressed("LEFT"):  #movimiento hacia la izquierda en el eje x
		velocity.x = -VELOCIDAD
		
	else:
		velocity.x = 0

	if not is_on_floor():  # pregunta si el pj no ta tocando el suelo entonces 
		velocity.y += GRAVEDAD * delta
			
	if Input.is_action_just_pressed("SPACE") and is_on_floor(): #  # Funcion para que cuando el pj salta la gravedad lo tire para abjo
		velocity.y = FUERZA_SALTO

	move_and_slide()  #Aplica velocity, detecta colisiones, no atraviesa paredes ni suelo
