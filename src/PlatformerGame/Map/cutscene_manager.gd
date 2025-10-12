class_name CutsceneManager

extends Node2D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func play_intro():
	_animation_player.play("intro")
