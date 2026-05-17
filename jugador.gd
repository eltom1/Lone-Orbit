extends CharacterBody3D

const VELOCIDAD = 2.0
const VELOCIDAD_CORRIENDO = 6.0
const VELOCIDAD_AGACHADO = 1.0
const GRAVEDAD = -20.0
const FUERZA_SALTO = 8.0

var en_gravedad = true
var saltando = false
var aterrizando = false
var tiempo_aterrizaje = 0.0
const DURACION_ATERRIZAJE = 0.4  # cuánto dura Jump_Land antes de volver a Idle

@onready var camara : Camera3D = $"../Camara"
@onready var animation_tree = $UAL1_standard/AnimationTree

func _ready():
	$"../z-Grav".body_entered.connect(_entrar_gravedad)
	$"../z-SinG".body_entered.connect(_entrar_espacio)

func _entrar_gravedad(body):
	if body == self:
		en_gravedad = true

func _entrar_espacio(body):
	if body == self:
		en_gravedad = false

func _actualizar_animacion(delta):
	var sm = animation_tree["parameters/StateMachine/playback"]
	var agachado = Input.is_action_pressed("CTRL") and is_on_floor()
	var caminando = Input.is_action_pressed("ALT")
	var corriendo = not caminando
	var moviendose = abs(velocity.x) > 0.1

	# Si está aterrizando, esperá que termine Jump_Land
	if aterrizando:
		tiempo_aterrizaje -= delta
		if tiempo_aterrizaje <= 0.0:
			aterrizando = false
		return

	if not is_on_floor():
		if not saltando:
			saltando = true
			sm.travel("Jump_Start")
		elif velocity.y < -1.0:
			# ya está cayendo, cortá Jump_Start y poné Jump_Land
			sm.travel("Jump_Land")
	else:
		if saltando:
			# acaba de aterrizar
			saltando = false
			aterrizando = true
			tiempo_aterrizaje = DURACION_ATERRIZAJE
			sm.travel("Jump_Land")
			return
		if agachado:
			if moviendose:
				sm.travel("Crouch_Fwd")
			else:
				sm.travel("Crouch_Idle")
		elif moviendose:
			if corriendo:
				sm.travel("Sprint")
			else:
				sm.travel("Walk")
		else:
			sm.travel("Idle")

func _physics_process(delta):
	var objetivo = Vector3(global_position.x, global_position.y + 2.5, 8.0)
	camara.global_position = camara.global_position.lerp(objetivo, 8.0 * delta)

	var hud = get_tree().get_first_node_in_group("hud")
	var tiene_estamina = true if hud == null else hud.estamina_actual > 0
	#var corriendo = Input.is_action_pressed("SHIFT") and tiene_estamina
	var agachado = Input.is_action_pressed("CTRL") and is_on_floor()
	#var vel_objetivo = VELOCIDAD_CORRIENDO if corriendo else VELOCIDAD
	var caminando = Input.is_action_pressed("ALT")
	var corriendo = not caminando and tiene_estamina
	var vel_objetivo = VELOCIDAD if caminando else VELOCIDAD_CORRIENDO

	# Movimiento horizontal
	if Input.is_action_pressed("RIGHT"):
		velocity.x = VELOCIDAD_AGACHADO if agachado else vel_objetivo
		$"UAL1_standard".rotation.y = PI / 2
	elif Input.is_action_pressed("LEFT"):
		velocity.x = -(VELOCIDAD_AGACHADO if agachado else vel_objetivo)
		$"UAL1_standard".rotation.y = -PI / 2
	else:
		velocity.x = move_toward(velocity.x, 0, vel_objetivo)

	# Gravedad / espacio
	if not is_on_floor():
		if en_gravedad:
			velocity.y += GRAVEDAD * delta
		else:
			velocity.y = move_toward(velocity.y, 0, 5 * delta)

	# Salto
	if Input.is_action_just_pressed("SPACE") and is_on_floor() and not agachado and not aterrizando:
		velocity.y = FUERZA_SALTO

	move_and_slide()
	_actualizar_animacion(delta)
