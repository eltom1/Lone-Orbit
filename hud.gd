extends Control

@export var vida_max: float = 100.0
@export var estamina_max: float = 100.0

var vida_actual: float = 100.0
var estamina_actual: float = 100.0

const ANCHO_MAX = 200.0
const VELOCIDAD_RECARGA = 25.0
const VELOCIDAD_GASTO = 40.0

@onready var barra_vida = $BarraVida
@onready var barra_estamina = $BarraEstamina

func _ready():
	actualizar_barra(barra_vida, vida_actual, vida_max)
	actualizar_barra(barra_estamina, estamina_actual, estamina_max)

func _process(delta):
	if Input.is_action_pressed("SHIFT") and estamina_actual > 0:
		estamina_actual = max(0.0, estamina_actual - VELOCIDAD_GASTO * delta)
	elif not Input.is_action_pressed("SHIFT"):
		estamina_actual = min(estamina_max, estamina_actual + VELOCIDAD_RECARGA * delta)
	
	actualizar_barra(barra_estamina, estamina_actual, estamina_max)

func set_vida(valor: float):
	vida_actual = clamp(valor, 0.0, vida_max)
	actualizar_barra(barra_vida, vida_actual, vida_max)

func actualizar_barra(barra: ColorRect, actual: float, maximo: float):
	barra.size.x = ANCHO_MAX * (actual / maximo)
