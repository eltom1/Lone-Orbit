# hereda de godot las fisicas, colisiones, etc
extends CharacterBody2D

# constantes, no cambian a lo largo de la ejecucion del programa
const VELOCIDAD = 200.0            # velocidad de movimiento del jugador
const VELOCIDAD_CORRIENDO = 380.0  # velocidad corriendo con SHIFT
const GRAVEDAD = 900.0             # que tan rapido cae el personaje
const FUERZA_SALTO = -400.0        # negativo pq en gdscript la y esta arriba
const SUAVIZADO_MOVIMIENTO = 15.0  # que tan rapido acelera/frena

var VIDA = 100

func _physics_process(delta):
	var hud = get_tree().get_first_node_in_group("hud")
	var tiene_estamina = hud != null and hud.estamina_actual > 0
	var corriendo = Input.is_action_pressed("SHIFT") and tiene_estamina
	var vel_objetivo = VELOCIDAD_CORRIENDO if corriendo else VELOCIDAD

	if Input.is_action_pressed("RIGHT"):
		velocity.x = lerp(velocity.x, vel_objetivo, SUAVIZADO_MOVIMIENTO * delta)
	elif Input.is_action_pressed("LEFT"):
		velocity.x = lerp(velocity.x, -vel_objetivo, SUAVIZADO_MOVIMIENTO * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, SUAVIZADO_MOVIMIENTO * delta)

	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

	if Input.is_action_just_pressed("SPACE") and is_on_floor():
		velocity.y = FUERZA_SALTO

	move_and_slide()
