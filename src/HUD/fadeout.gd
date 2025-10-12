class_name Fadeout

extends ColorRect

enum Mode { FADEOUT, FADEIN }

@export var mode := Mode.FADEOUT
@export var duration := 0.5


func fade() -> void:
	visible = true
	var target_a := 0.0 if mode == Mode.FADEIN else 1.0
	print(target_a)
	await create_tween().tween_property(self, "color:a", target_a, duration).finished


func _ready() -> void:
	visible = false
	color.a = 1.0 if mode == Mode.FADEIN else 0.0
