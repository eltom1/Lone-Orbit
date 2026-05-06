extends CharacterBody2D

const VELOCIDAD = 200.0
const GRAVEDAD = 900.0
const FUERZA_SALTO = -400.0

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta
	
	# Salto
	if Input.is_action_just_pressed("SPACE") and is_on_floor():
		velocity.y = FUERZA_SALTO
	
	# Movimiento horizontal
	if Input.is_action_pressed("RIGHT"):
		velocity.x = VELOCIDAD
	elif Input.is_action_pressed("LEFT"):
		velocity.x = -VELOCIDAD
	else:
		velocity.x = 0
	
	move_and_slide()
