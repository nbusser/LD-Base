class_name PlatformerPlayer

extends CharacterBody2D

enum Direction { LEFT, RIGHT }

const _GROUND_SPEED := 300.0
const _AIR_SPEED := 150.0

@export var is_in_cutscene := false

var direction := Direction.RIGHT

var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _sprite: AnimatedSprite2D = $Sprite


func _can_move() -> bool:
	return not is_in_cutscene


func _physics_process(delta: float) -> void:
	if not _can_move():
		return

	var horizontal_velocity := 0.0
	var vertical_velocity := 0.0

	$JumpManager.try_jump()
	vertical_velocity += $JumpManager.get_jump_velocity().y

	# Horizontal movement
	var input_direction := Input.get_axis("move_left", "move_right")
	if input_direction != 0:
		direction = Direction.LEFT if input_direction == -1 else Direction.RIGHT
	horizontal_velocity = (input_direction * (_GROUND_SPEED if self.is_on_floor() else _AIR_SPEED))

	# Sprite direction
	_sprite.flip_h = direction == Direction.LEFT

	# Gravity
	horizontal_velocity = (
		velocity.x - (16 * delta * velocity.x)
		if abs(velocity.x) > abs(horizontal_velocity)
		else horizontal_velocity
	)
	velocity = Vector2(horizontal_velocity, velocity.y + vertical_velocity + _gravity * delta)

	move_and_slide()

	# TODO: walking anim


func _ready() -> void:
	pass
