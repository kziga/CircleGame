extends Node2D

@export var circle_scene: PackedScene

const POINT_DISPLAY = preload("res://Scenes/pointDisplay.tscn")

var total_score
var this_round_score
var lives
var difficulty_multiplier

func _ready():
	total_score = 0
	this_round_score = 0
	lives = 30
	difficulty_multiplier = 1.0
	$SpawnTimer.start()
	$CanvasLayer/UI/LevelUpMenu.hide()
	$CanvasLayer/UI/GameOverMenu.hide()

func _level_up():
	$SpawnTimer.stop()
	this_round_score = 0
	lives = 3
	$CanvasLayer/UI/Lives/LivesLabel.text = "Lives: " + str(lives)
	get_tree().call_group("circles","queue_free")
	get_tree().paused = true
	$CanvasLayer/UI/LevelUpMenu.show()
	difficulty_multiplier *= 1.2;
	$SpawnTimer.wait_time = max(0.5,$SpawnTimer.wait_time/difficulty_multiplier)
	
func _game_over():
	get_tree().call_group("circles","queue_free")
	get_tree().paused = true
	$CanvasLayer/UI/GameOverMenu.show()

func _on_spawn_timer_timeout():
	# Prevent spawning two on each other
	var viewport_size = get_viewport_rect().size # Do we have to get this every time?
	var spawn_pos = Vector2(randi_range(150,viewport_size.x-150),randi_range(150,viewport_size.y-150))
	var spawned_circles = get_tree().get_nodes_in_group("circles")
	var found_spawn_point = false
	var min_distance = 1000000
	
	# Do our best to not spawn two on top of each other
	# But it won't be perfect given the max size of the circles and the limit
	# region we are spawning in
	# We handle spawning two on top of each other by only scoring the older
	# circle if both are clicked
	if spawned_circles.size() > 0:
		var attempts = 0
		while not found_spawn_point:
			attempts += 1
			if attempts >= 10:
				found_spawn_point = true
				break
			for c in spawned_circles:
				var dist = spawn_pos.distance_to(c.pos)
				if dist < min_distance:
					min_distance = dist
				
			if min_distance > 200:
				found_spawn_point = true
			else:
				spawn_pos = Vector2(randi_range(150,viewport_size.x-150),randi_range(150,viewport_size.y-150))

	var circle = circle_scene.instantiate()
	circle.circle_clicked.connect(_on_circle_clicked)
	circle.circle_missed.connect(_on_circle_missed)
	circle.pos = spawn_pos
	circle.expansion_rate = 10.0 * difficulty_multiplier
	add_child(circle)

func _on_circle_clicked(data):
	$ShakeCamera2D.shake(2)
	this_round_score += data.points
	total_score += data.points
	$CanvasLayer/UI/Score/ScoreLabel.text = "Score: " + str(total_score)
	
	var d = POINT_DISPLAY.instantiate()
	add_child(d)
	d._display_points(data.pos,data.points)

	if this_round_score >= 100:
		_level_up()

func _on_circle_missed():
	$ShakeCamera2D.shake(3)
	lives -= 1
	if lives <= 0:
		_game_over()
	$CanvasLayer/UI/Lives/LivesLabel.text = "Lives: " + str(lives)


func _on_continue_button_pressed():
	$CanvasLayer/UI/LevelUpMenu.hide()
	get_tree().paused = false
	$SpawnTimer.start()


func _on_new_game_button_pressed():
	$CanvasLayer/UI/GameOverMenu.hide()
	total_score = 0
	this_round_score = 0
	lives = 3
	difficulty_multiplier = 1.0
	$SpawnTimer.wait_time = 2.0
	$CanvasLayer/UI/Lives/LivesLabel.text = "Lives: " + str(lives)
	$CanvasLayer/UI/Score/ScoreLabel.text = "Score: " + str(total_score)
	get_tree().paused = false
	$SpawnTimer.start()
