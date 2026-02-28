extends Node2D

func _display_points(pos: Vector2, points: int):
	var label = Label.new()
	label.text = "+" + str( points )
	label.position = pos
	var labSet = LabelSettings.new()
	labSet.font_color = Color(0.0,0.72,0.0,1.0)
	label.label_settings = labSet
	label.pivot_offset = label.size / 2
	add_child(label)
	
	# Animate
	var t = create_tween().set_parallel( true )
	var end_pos = pos + Vector2(randf_range(-20,20),-50)
	
	t.tween_property(label,"position",end_pos,0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	t.tween_property(label,"scale",Vector2.ZERO,0.2).set_delay(0.4)
	t.chain().tween_callback(label.queue_free)
