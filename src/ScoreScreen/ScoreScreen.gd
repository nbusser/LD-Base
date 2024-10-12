extends Control

class_name ScoreScreen

var level_number: int
var nb_coins: int

@onready var level_label = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/LevelNumber
@onready var coin_label = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/CoinsNumber


func _ready() -> void:
	assert(
		level_number != null and nb_coins != null,
		"init must be called before creating ScoreScreen scene"
	)
	level_label.text = str(level_number + 1)
	coin_label.text = str(nb_coins)


func init(level_number_p: int, nb_coins_p: int) -> void:
	self.level_number = level_number_p
	self.nb_coins = nb_coins_p


func _on_NextLevelButton_pressed() -> void:
	Globals.end_scene(Globals.EndSceneStatus.SCORE_SCREEN_NEXT)
