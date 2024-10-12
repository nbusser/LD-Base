extends Control

@onready var level_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue
@onready var coins_label = $VBoxContainer/VBoxContainer/CoinNumber/CoinNumberValue
@onready var level_name_label = $VBoxContainer/CenterContainer/LevelNameValue

func set_level_name(level_name: String):
	level_name_label.text = level_name

func set_level_number(level_number):
	level_label.text = str(level_number + 1)


func set_coins(nb_coins):
	coins_label.text = str(nb_coins)
