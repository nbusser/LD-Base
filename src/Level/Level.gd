extends Node

class_name Level

@onready var hud: HUD = $UI/HUD
@onready var timer: Timer = $Timer

var level_state: LevelState


func _ready():
	assert(
		level_state, "init must be called before creating Level scene"
	)
	hud.init(level_state)

	timer.start(level_state.level_data.timer_duration)


func init(level_number_p: int, level_data_p: LevelData, nb_coins_p: int):
	level_state = LevelState.new(
		level_number_p, level_data_p, nb_coins_p
	)


func _on_Timer_timeout():
	if randi() % 2:
		Globals.end_scene(Globals.EndSceneStatus.LEVEL_END)
	else:
		Globals.end_scene(Globals.EndSceneStatus.LEVEL_GAME_OVER)
