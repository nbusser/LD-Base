class_name ScoreScreen

extends Control

@onready
var level_label: Label = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/LevelNumber
@onready
var coin_label: Label = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/CoinsNumber


func _ready() -> void:
	level_label.text = str(GameState.current_level_number + 1)
	coin_label.text = str(GameState.nb_coins)


func _on_NextLevelButton_pressed() -> void:
	Globals.end_scene(Globals.EndSceneStatus.SCORE_SCREEN_NEXT)
