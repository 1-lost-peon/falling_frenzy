extends ScreenState

@export var falling_object_scene: PackedScene
@export var falling_object_scene2: PackedScene

@export var player1_score: int
@export var player2_score: int


@onready var mark_left: Marker2D = $MarkLeft
@onready var mark_right: Marker2D = $MarkRight
@onready var player_1: CharacterBody2D = $Player1
@onready var player_1_score: Label = $Player1Score
@onready var player_2_score: Label = $Player2Score
@onready var label: Label = $Label
@onready var player_2: CharacterBody2D = $Player2


var player_score_prefix_text: String = "SCORE: "


func _ready() -> void:
	player_1.player_scored.connect(_on_player_scored)
	player_1.player_penalized.connect(_on_player_penalized)
	player_2.player_scored.connect(_on_player_scored)
	player_2.player_penalized.connect(_on_player_penalized)
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	check_controllers()


func _process(_delta: float) -> void:
	var total_seconds := int(ceil($Timer.time_left))
	var minutes := int(total_seconds / 60)
	var seconds := total_seconds % 60

	label.text = "%02d:%02d" % [minutes, seconds]

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	print("Controller ", device, " connected: ", connected)
	check_controllers()


func check_controllers() -> void:
	var controllers := Input.get_connected_joypads()

	print("Connected controllers: ", controllers)

	if controllers.size() >= 2:
		print("Two controllers detected!")
		print("Player 1 device: ", controllers[0])
		print("Player 2 device: ", controllers[1])


func _on_player_scored(controller_id: int) -> void:
	if controller_id == 0:
		player1_score = player1_score + 1
		player_1_score.text = player_score_prefix_text + str(player1_score)
	if controller_id == 1:
		print(player2_score)
		player2_score = player2_score + 1
		player_2_score.text = player_score_prefix_text + str(player2_score)


func _on_player_penalized(controller_id: int) -> void:
	if controller_id == 0:
		player1_score = player1_score - 2
		player_1_score.text = player_score_prefix_text + str(player1_score)
	if controller_id == 1:
		player2_score = player2_score - 2
		player_2_score.text = player_score_prefix_text + str(player2_score)


func _on_spawn_timer_timeout() -> void:
	var scenes: Array[PackedScene] = [
		falling_object_scene,
		falling_object_scene2
	]

	var selected_scene: PackedScene = scenes.pick_random()
	var object := selected_scene.instantiate()

	add_child(object)

	object.global_position = Vector2(
		randf_range(
			mark_left.global_position.x,
			mark_right.global_position.x
		),
		mark_left.global_position.y
	)
