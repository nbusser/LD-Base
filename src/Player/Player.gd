class_name Player

extends CharacterBody2D

var _velocity := Vector2.ZERO

@onready var nav: Node2D = $"../"
@onready var target: CharacterBody2D = $"../../Target"
#onready var map = nav.get_node("TileMap")
#onready var game = map.get_parent()

@onready var _agent: NavigationAgent2D = $NavigationAgent2D
@onready var _sprite := $Sprite2D
@onready var _timer := $Timer


func _ready() -> void:
	# Waits for Game.gd to run randomize()
	await get_tree().process_frame
	$SoundFx/SpawnSound.play()
	_timer.timeout.connect(self._update_pathfinding)
	_agent.velocity_computed.connect(self.move)


func _physics_process(delta: float) -> void:
	if abs(global_position.distance_to(target.global_position)) < 50:
		print("TODO: game over")

	if _agent.is_navigation_finished():
		return

	var target_global_position := _agent.get_next_path_position()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	_agent.set_velocity(_velocity)


func move(velocity_p: Vector2) -> void:
	set_velocity(velocity_p)
	move_and_slide()
	_velocity = velocity_p
	_sprite.rotation = lerp_angle(
		_sprite.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time()
	)


func _update_pathfinding() -> void:
	_agent.set_target_position(target.global_position)
