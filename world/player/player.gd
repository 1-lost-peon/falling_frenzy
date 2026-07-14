extends CharacterBody2D

signal player_scored(controller_id: int)
signal player_penalized(controller_id: int)

@export var controller_id: int = 0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_A) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	var direction := Input.get_joy_axis(
		controller_id,
		JOY_AXIS_LEFT_X
	)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#for i in get_slide_collision_count():
		#var collision := get_slide_collision(i)
		#var object := collision.get_collider()
#
		#if object is RigidBody2D:
			#print("Hit rigid body: ", object.name)
			#object.queue_free()
			#player_scored.emit()
