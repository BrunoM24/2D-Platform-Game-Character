extends State


export var acceleration_x = 5000.0
export var jump_impulse := 900.0
export var max_jump_count := 2

var _jump_counting := 0


func unhandled_input(event: InputEvent) -> void:
	var move := get_parent()
	
	if event.is_action_pressed("jump") and _jump_counting < max_jump_count:
		jump()
	
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move := get_parent()
	
	move.physics_process(delta)
	
	if owner.is_on_floor():
		var target_state := "Move/Idle" if move.get_move_direction().x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	var move := get_parent()
	move.enter(msg)
	move.acceleration.x = acceleration_x
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
	
	if "impulse" in msg:
		jump()
	else:
		_jump_counting += 1


func exit() -> void:
	var move := get_parent()
	move.acceleration = move.acceleration_default
	_jump_counting = 0
	move.exit()


func jump() -> void:
	var move := get_parent()
	move.velocity.y = 0
	move.velocity += calculate_jump_velocity(jump_impulse)
	_jump_counting += 1


func calculate_jump_velocity(impulse := 0.0) -> Vector2:
	var move := get_parent()
	
	return move.calculate_velocity(move.velocity, move.max_speed, Vector2(0, impulse), Vector2.ZERO, 1.0, Vector2.UP)
