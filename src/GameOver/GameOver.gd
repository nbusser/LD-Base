extends Control

class_name GameOver

signal restart
signal quit


func _on_Restart_pressed() -> void:
	emit_signal("restart")


func _on_Quit_pressed() -> void:
	emit_signal("quit")
