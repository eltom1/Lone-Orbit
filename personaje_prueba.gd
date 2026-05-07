extends CharacterBody2D

const VELOCIDAD = 200.0
const GRAVEDAD = 900.0
const FUERZA_SALTO = -400.0

var en_escalera = false


func _physics_process(delta):
	
	if Input.is_action_pressed("RIGHT"):
		velocity.x = VELOCIDAD
	elif Input.is_action_pressed("LEFT"):
		velocity.x = -VELOCIDAD
	else:
		velocity.x = 0

	if en_escalera:
		velocity.y = 0
		
		if Input.is_action_pressed("ui_up"):
			velocity.y = -VELOCIDAD
		elif Input.is_action_pressed("ui_down"):
			velocity.y = VELOCIDAD
	
	else:

		if not is_on_floor():
			velocity.y += GRAVEDAD * delta
		
		
		if Input.is_action_just_pressed("SPACE") and is_on_floor():
			velocity.y = FUERZA_SALTO

	move_and_slide()
