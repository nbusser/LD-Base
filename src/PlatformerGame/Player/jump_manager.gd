class_name JumpManager

extends Node2D

enum State {
	NOT_JUMPING,
	JUMPING,
}

# Describes why the jump ascending coroutine has been interrupted.
enum CancelReason {
	NOT_CANCELED,
	BUMP_CEILING,
}

const _MAX_JUMPS := 3
const _JUMP_FORCE := Vector2(0.0, -6000.0)
const _ASCENDING_MAX_DURATION := 0.5

var _state := State.NOT_JUMPING
var _cancel_token := CancelReason.NOT_CANCELED
var _current_nb_jumps_left := _MAX_JUMPS
var _jumping_velocity := Vector2.ZERO

@onready var _player: PlatformerPlayer = $".."
@onready var _sprite: AnimatedSprite2D = $"../Sprite"


func _cancel_jump(reason: CancelReason):
	assert(reason != CancelReason.NOT_CANCELED)
	_cancel_token = reason


func _process(_delta: float):
	if _player.is_on_floor():
		# Reset the number of jumps.
		_current_nb_jumps_left = _MAX_JUMPS
	elif _player.is_on_ceiling():
		# Cancel jump because we bumped the ceiling.
		_cancel_jump(CancelReason.BUMP_CEILING)


# This coroutine is responsible for sequentially handling the jumping logic.
# It cannot be called concurrently.
func _ascending_routine() -> void:
	assert(_state != State.JUMPING, "This coroutine cannot be called concurrently.")

	_cancel_token = CancelReason.NOT_CANCELED

	# Abstract state saying that we are currently in this coroutine.
	_state = State.JUMPING

	var ascending_timer = get_tree().create_timer(_ASCENDING_MAX_DURATION)
	$JumpSound.play()
	while (
		_cancel_token == CancelReason.NOT_CANCELED
		and ascending_timer.time_left > 0.0
		and Input.is_action_pressed("jump")
	):
		# Tune jump power depending on the time we spent ascending.
		var timer_proportion = (
			(
				1
				- (
					clamp(
						_ASCENDING_MAX_DURATION - ascending_timer.time_left,
						0,
						_ASCENDING_MAX_DURATION
					)
					/ _ASCENDING_MAX_DURATION
				)
			)
			** 2
		)
		_jumping_velocity = _JUMP_FORCE * get_process_delta_time() * timer_proportion

		# Wait one frame.
		# Why do we not simply await ascending_timer.timeout?
		# -> to be able to cancel the routine mid-way
		await get_tree().process_frame

	_jumping_velocity = Vector2.ZERO
	_state = State.NOT_JUMPING


# Tries to input a jump.
# Returns whenever the jump was sucessful.
func try_jump() -> bool:
	if not Input.is_action_just_pressed("jump") or _current_nb_jumps_left == 0:  # If no jump left
		return false

	# Because we have to release jump button to press it again, we are not supposed to be in a jump

	# Cleans up gravity
	_player.velocity.y = 0
	_current_nb_jumps_left -= 1

	# Run the jump routine in the background.
	_ascending_routine.call()

	return true


# Called every frame by the player to know the jumping velocity.
# Handled by the coroutine.
func get_jump_velocity() -> Vector2:
	return _jumping_velocity

# TODO
# Plays the right jumping animation if the player is in the air.
# func try_play_jumping_or_falling_animation(velocity_y: float):
# 	if not is_jumping_or_falling():
# 		return false

# 	if velocity_y >= 140 or Time.get_unix_time_from_system() - _play_jump_start_ts < .05:
# 		_sprite.play("jump_end")
# 	elif velocity_y <= 0:
# 		_sprite.play("jump_start")
# 	else:
# 		_sprite.play("jump_middle")
# 	return true
