extends Control

class_name SceneManager

var current_level_number := 0
var nb_coins := 0

var current_player: AudioStreamPlayer
var current_scene: set = set_scene

@onready var music_players = $Musics.get_children() as Array[AudioStreamPlayer]

@onready var main_menu = preload("res://src/MainMenu/MainMenu.tscn")
@onready var level = preload("res://src/Level/Level.tscn")
@onready var change_level = preload("res://src/EndLevel/EndLevel.tscn")
@onready var credits = preload("res://src/Credits/Credits.tscn")
@onready var game_over = preload("res://src/GameOver/GameOver.tscn")

@onready var viewport: Viewport = $SubViewportContainer/SubViewport

# Settings of all levels. To be configured from the editor
@export var levels: Array[LevelData]

func _ready() -> void:
	randomize()
	Globals.scene_ended.connect(self._on_end_scene)
	_run_main_menu()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().quit()


func _on_quit_game() -> void:
	get_tree().quit()


func _on_start_game() -> void:
	_load_level()


func _on_show_credits() -> void:
	_run_credits(true)


func _on_show_main_menu() -> void:
	_run_main_menu()


func set_scene(new_scene: Node) -> void:
	# Free older scene
	if current_scene:
		viewport.remove_child(current_scene)
		current_scene.queue_free()

	current_scene = new_scene
	viewport.add_child(current_scene)


func _load_level() -> void:
	var scene: Level = level.instantiate()
	scene.init(current_level_number, levels[current_level_number], nb_coins)

	scene.connect("end_of_level", Callable(self, "_on_end_of_level"))
	scene.connect("game_over", Callable(self, "_on_game_over"))

	self.current_scene = scene


func _on_end_of_level() -> void:
	if current_level_number + 1 >= levels.size():
		# Win
		_run_credits(false)
	else:
		_load_end_level()


func first_level() -> bool:
	return current_level_number == 0


func _on_game_over() -> void:
	var scene: GameOver = game_over.instantiate()

	scene.connect("restart", Callable(self, "_on_restart_level"))
	scene.connect("quit", Callable(self, "_on_quit_game"))

	self.current_scene = scene


func _on_restart_level() -> void:
	_load_level()


func _on_restart_select_level() -> void:
	_load_end_level()


func _load_end_level() -> void:
	var scene: EndLevel = change_level.instantiate()
	scene.init(current_level_number, nb_coins)

	scene.connect("next_level", Callable(self, "_on_next_level"))

	self.current_scene = scene


func _on_next_level() -> void:
	current_level_number += 1
	change_music_track(music_players[current_level_number % len(music_players)])
	_load_level()


func _run_credits(can_go_back: bool) -> void:
	var scene: Credits = credits.instantiate()

	scene.set_back(can_go_back)
	if can_go_back:
		scene.connect("back", Callable(self, "_on_show_main_menu"))

	self.current_scene = scene


func _run_main_menu() -> void:
	var scene: MainMenu = main_menu.instantiate()

	change_music_track(music_players[0])

	scene.connect("start_game", Callable(self, "_on_start_game"))
	scene.connect("quit_game", Callable(self, "_on_quit_game"))
	scene.connect("show_credits", Callable(self, "_on_show_credits"))

	self.current_scene = scene


func change_music_track(new_player: AudioStreamPlayer) -> void:
	if current_player != new_player:
		for mp in music_players:
			mp.stop()

		new_player.play()
		current_player = new_player

func _on_end_scene(status: Globals.EndSceneStatus, params: Dictionary = {}) -> void:
	print(status)
