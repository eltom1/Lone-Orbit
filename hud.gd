extends Control

@export var vida_max: float = 100.0


var vida_actual: float = 100.0
var estamina_actual: float = 100.0

const ANCHO_MAX = 200.0
const VELOCIDAD_RECARGA = 25.0
const VELOCIDAD_GASTO = 40.0

@onready var barra_vida = $BarraVida


func _ready():
	actualizar_barra(barra_vida, vida_actual, vida_max)



func set_vida(valor: float):
	vida_actual = clamp(valor, 0.0, vida_max)
	actualizar_barra(barra_vida, vida_actual, vida_max)

func actualizar_barra(barra: ColorRect, actual: float, maximo: float):
	barra.size.x = ANCHO_MAX * (actual / maximo)
