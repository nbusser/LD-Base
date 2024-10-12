extends Control

class_name HUD

@onready var level_number_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue
@onready var coins_label = $VBoxContainer/VBoxContainer/CoinNumber/CoinNumberValue
@onready var level_name_label = $VBoxContainer/CenterContainer/LevelNameValue
@onready var fadein_pane = $FadeinPane

var level_name: set = set_level_name
func set_level_name(value: String) -> void:
	level_name_label.text = value

var nb_coins: set = set_nb_coins
func set_nb_coins(value: int) -> void:
	coins_label.text = str(value)

var level_number: set = set_level_number
func set_level_number(value: int) -> void:
	level_number_label.text = str(value)

func init(level_state: LevelState) -> void:
	level_name = level_state.level_data.name
	level_number = level_state.level_number
	nb_coins = level_state.nb_coins

func _ready() -> void:
	# Fadein animation
	fadein_pane.visible = 1
	create_tween().tween_property(fadein_pane, "modulate", Color.TRANSPARENT, 0.7)
