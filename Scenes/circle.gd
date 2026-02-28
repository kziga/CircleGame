extends Node2D

signal circle_clicked(data)
signal circle_missed

# := infers type instead of explicitly setting type
var pos := Vector2.ZERO
var radius := 15.0
# Make a set of nice colors and randomly pick among those
var color := Color.RED
var expansion_rate := 10.0;
var point_value := 10.0
var max_radius = 100.0

func _ready():
	# Particle effect on spawn
	# Make sure the click area is at the same position as the circle 
	$ClickBox.position = pos
	var color_index = randi_range(0,5)
	match color_index:
		0:
			color = Color.BLUE_VIOLET
		1:
			color = Color.DARK_MAGENTA
		2:
			color = Color.DARK_ORCHID
		3:
			color = Color.DARK_SLATE_BLUE
		4:
			color = Color.MIDNIGHT_BLUE
		5:
			color = Color.STEEL_BLUE
		_:
			color = Color.BLUE_VIOLET

func _process(delta):
	radius += expansion_rate * delta
	if radius >= max_radius:
		circle_missed.emit()
		queue_free()
	point_value = ceil(10.0 * ((max_radius-radius)/(max_radius-15.0)))
	$ClickBox.shape.radius = radius
	queue_redraw()
	
func _draw():
	var shadow_pos = Vector2(pos.x + 7,pos.y + 7)
	draw_circle(shadow_pos,radius,Color.BLACK)
	draw_circle(pos,radius,color)
	draw_arc(pos,radius+1,0,TAU,64,Color.WHITE,2.0)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var space_state = get_world_2d().direct_space_state
		var mouse_pos = get_global_mouse_position()
		# Use intersect_point to get all objects at the mouse position
		# Note: intersect_point gives an array of dictionaries with collider info
		# You may need to adjust the collision mask/layer or use a specific shape query
		var p = PhysicsPointQueryParameters2D.new()
		p.position = mouse_pos
		p.collide_with_areas = true # We have areas so make sure this will detect collision with areas, not just bodies
		var objects_hit = space_state.intersect_point(p) # All objects intersecting with the clicked position
		
		for o in objects_hit:
			if o.collider.radius > self.radius:
				return
				
		circle_clicked.emit({"points": point_value, "pos": pos})
		# Some effect where the color fades or something
		queue_free()
