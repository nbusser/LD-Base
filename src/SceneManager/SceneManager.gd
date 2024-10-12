extends Control

class_name SceneManager

var current_level_number := 0
var nb_coins := 0

var current_player: AudioStreamPlayer
var current_scene: set = set_scene

@onready var music_players = $Musics.get_children() as Array[AudioStreamPlayer]

@onready var main_menu = preload("res://src/MainMenu/MainMenu.tscn")
@onready var level = preload("res://src/Level/Level.tscn")
@onready var change_level = preload("res://src/ScoreScreen/ScoreScreen.tscn")
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

func _reset_game_state() -> void:
	current_level_number = 0
	nb_coins = 0

func _quit_game() -> void:
	get_tree().quit()


func _on_start_game() -> void:
	_run_level()

func _on_show_credits() -> void:
	_run_credits(true)


func set_scene(new_scene: Node) -> void:
	# Free older scene
	if current_scene:
		viewport.remove_child(current_scene)
		current_scene.queue_free()

	current_scene = new_scene
	viewport.add_child(current_scene)


func _run_level() -> void:
	var scene: Level = level.instantiate()
	scene.init(current_level_number, levels[current_level_number], nb_coins)
	self.current_scene = scene

func _run_selected_level(level_i: int) -> void:
	current_level_number = level_i
	_run_level()

func _start_game() -> void:
	_reset_game_state()
	_run_level()


func _on_end_of_level() -> void:
	if current_level_number + 1 >= levels.size():
		# Win
		_run_credits(false)
	else:
		_load_score_screen()


func first_level() -> bool:
	return current_level_number == 0


func _on_game_over() -> void:
	var scene: GameOver = game_over.instantiate()
	self.current_scene = scene


func _restart_level() -> void:
	_run_level()

func _load_score_screen() -> void:
	var scene: 	ScoreScreen = change_level.instantiate()
	scene.init(current_level_number, nb_coins)
	self.current_scene = scene


func _run_next_level() -> void:
	current_level_number += 1
	change_music_track(music_players[current_level_number % len(music_players)])
	_run_level()


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
	match status:
		Globals.EndSceneStatus.MAIN_MENU_CLICK_START:
			_start_game()
		Globals.EndSceneStatus.MAIN_MENU_SELECT_LEVEL:
			push_error("No handler")
		Globals.EndSceneStatus.MAIN_MENU_CLICK_CREDITS:
			_run_credits(true)
		Globals.EndSceneStatus.MAIN_MENU_CLICK_QUIT:
			_quit_game()
		Globals.EndSceneStatus.LEVEL_END:
			_on_end_of_level()
		Globals.EndSceneStatus.LEVEL_GAME_OVER:
			_on_game_over()
		Globals.EndSceneStatus.LEVEL_RESTART:
			_restart_level()
		Globals.EndSceneStatus.GAME_OVER_RESTART:
			_restart_level()
		Globals.EndSceneStatus.GAME_OVER_QUIT:
			_quit_game()
		Globals.EndSceneStatus.SCORE_SCREEN_NEXT:
			_run_next_level()
		Globals.EndSceneStatus.SCORE_SCREEN_RETRY:
			_restart_level()
		Globals.EndSceneStatus.SELECT_LEVEL_SELECTED:
			var level_i: int = params["level_i"]
			_run_selected_level(level_i)
		Globals.EndSceneStatus.SELECT_LEVEL_BACK:
			_run_main_menu()
		Globals.EndSceneStatus.CREDITS_BACK:
			_run_main_menu()
		_:
			assert(false, "Unknown status " + str(status))
