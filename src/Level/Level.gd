extends Node

signal end_of_level
signal game_over

@onready var hud = $UI/HUD
@onready var timer: Timer = $Timer

var level_state: LevelState


func _ready():
	assert(
		level_state, "init must be called before creating Level scene"
	)
	hud.set_level_number(level_state.level_number)
	hud.set_coins(level_state.nb_coins)
	hud.set_level_name(level_state.level_data.name)

	timer.start(level_state.level_data.timer_duration)


func init(level_data_p: LevelData, level_number, nb_coins):
	level_state = LevelState.new(
		level_number, level_data_p, nb_coins
	)


func _on_Timer_timeout():
	if randi() % 2:
		emit_signal("end_of_level")
	else:
		emit_signal("game_over")
