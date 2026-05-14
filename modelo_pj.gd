extends Node3D

@onready var anim = $UAL1_Standard/AnimationPlayer

func _ready():
	anim.play("Idle")

func _process(_delta):
	if Input.is_action_pressed("RIGHT"):
		rotation_degrees.y = 0
	elif Input.is_action_pressed("LEFT"):
		rotation_degrees.y = 180

	var mov_x = Input.is_action_pressed("RIGHT") or Input.is_action_pressed("LEFT")
	var corriendo = Input.is_action_pressed("SHIFT")
	var en_aire = not get_parent().get_parent().is_on_floor()

	if en_aire:
		if not anim.current_animation == "Jump":
			anim.play("Jump")
	elif corriendo and mov_x:
		if not anim.current_animation == "Sprint":
			anim.play("Sprint")
	elif mov_x:
		if not anim.current_animation == "Walk":
			anim.play("Walk")
	else:
		if not anim.current_animation == "Idle":
			anim.play("Idle")
