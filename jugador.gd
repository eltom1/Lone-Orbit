extends CharacterBody3D

const VELOCIDAD = 2.0
const VELOCIDAD_CORRIENDO = 6.0
const VELOCIDAD_AGACHADO = 1.0
const GRAVEDAD = -20.0
const FUERZA_SALTO = 8.0

@onready var anim = $UAL1_Standard/AnimationPlayer

var en_gravedad = true

func _physics_process(delta):
	var hud = get_tree().get_first_node_in_group("hud")
	#print("hud: ", hud, " estamina: ", hud.estamina_actual if hud else "NULL")
	var tiene_estamina = true if hud == null else hud.estamina_actual > 0
	var corriendo = Input.is_action_pressed("SHIFT") and tiene_estamina
	var agachado = Input.is_action_pressed("CTRL") and is_on_floor()
	var vel_objetivo = VELOCIDAD_CORRIENDO if corriendo else VELOCIDAD

	if Input.is_action_pressed("RIGHT"):
		velocity.x = VELOCIDAD_AGACHADO if agachado else vel_objetivo
		$UAL1_Standard.rotation.y = PI / 2
	elif Input.is_action_pressed("LEFT"):
		velocity.x = -(VELOCIDAD_AGACHADO if agachado else vel_objetivo)
		$UAL1_Standard.rotation.y = -PI / 2
	else:
		velocity.x = move_toward(velocity.x, 0, vel_objetivo)

	if not is_on_floor():
		if en_gravedad:
			velocity.y += GRAVEDAD * delta
		else:
			velocity.y = move_toward(velocity.y, 0, 5 * delta)

	if Input.is_action_just_pressed("SPACE") and is_on_floor() and not agachado:
		velocity.y = FUERZA_SALTO

	move_and_slide()

	var mov_x = abs(velocity.x) > 0.1

	if agachado:
		if mov_x:
			if anim.current_animation != "Crouch_Fwd":
				anim.play("Crouch_Fwd")
		else:
			if anim.current_animation != "Crouch_Idle":
				anim.play("Crouch_Idle")
	elif not is_on_floor():
		if anim.current_animation != "Jump":
			anim.play("Jump")
	elif corriendo and mov_x:
		if anim.current_animation != "Sprint":
			anim.play("Sprint")
	elif mov_x:
		if anim.current_animation != "Walk":
			anim.play("Walk")
	else:
		if anim.current_animation != "Idle":
			anim.play("Idle")
