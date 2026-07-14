extends RigidBody2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var collected := false

func _ready() -> void:
	gravity_scale = 0.15


func _on_area_2d_body_entered(body: Node2D) -> void:
	if collected:
		return

	if body is CharacterBody2D:
		collected = true
		body.player_penalized.emit(body.controller_id)
		await despawn_with_sound()

	elif body is StaticBody2D:
		await despawn_with_sound()


func despawn_with_sound() -> void:
	collision_shape.set_deferred("disabled", true)
	visible = false

	audio_stream_player.play()
	await audio_stream_player.finished

	queue_free()
