extends Control

class_name GameOver


func _on_Restart_pressed() -> void:
	Globals.end_scene(Globals.EndSceneStatus.GAME_OVER_RESTART)


func _on_Quit_pressed() -> void:
	Globals.end_scene(Globals.EndSceneStatus.GAME_OVER_QUIT)
