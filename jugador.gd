extends CharacterBody3D

const VELOCIDAD = 2.0
const VELOCIDAD_CORRIENDO = 6.0
const VELOCIDAD_AGACHADO = 1.0
const GRAVEDAD = -20.0
const FUERZA_SALTO = 8.0

var anim_tree
var anim_state
var en_gravedad = true

func _ready():
	anim_tree = $"UAL1_standard/AnimationTree"
	anim_state = anim_tree.get("parameters/playback")
	$"../z-Grav".body_entered.connect(_entrar_gravedad)
	$"../z-SinG".body_entered.connect(_entrar_espacio)

func _entrar_gravedad(body):
	if body == self:
		en_gravedad = true

func _entrar_espacio(body):
	if body == self:
		en_gravedad = false

func _physics_process(delta):
	var hud = get_tree().get_first_node_in_group("hud")
	var tiene_estamina = true if hud == null else hud.estamina_actual > 0
	var corriendo = Input.is_action_pressed("SHIFT") and tiene_estamina
	var agachado = Input.is_action_pressed("CTRL") and is_on_floor()
	var vel_objetivo = VELOCIDAD_CORRIENDO if corriendo else VELOCIDAD

	if Input.is_action_pressed("RIGHT"):
		velocity.x = VELOCIDAD_AGACHADO if agachado else vel_objetivo
		$"UAL1_standard".rotation.y = PI / 2
	elif Input.is_action_pressed("LEFT"):
		velocity.x = -(VELOCIDAD_AGACHADO if agachado else vel_objetivo)
		$"UAL1_standard".rotation.y = -PI / 2
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
			anim_state.travel("Crouch_Fwd")
		else:
			anim_state.travel("Crouch_Idle")
	elif not is_on_floor():
		anim_state.travel("Jump")
	elif corriendo and mov_x:
		anim_state.travel("Sprint")
	elif mov_x:
		anim_state.travel("Walk")
	else:
		anim_state.travel("Idle")
