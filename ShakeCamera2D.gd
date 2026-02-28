extends Camera2D

@export var decay = 4.0
@export var max_offset = Vector2(100,75) # Vert/hor shake in the pixels
@export var max_rol = 0.1 # radians
#export (NodePath) var target # Node this camera will follow

var trauma = 0.5
var trauma_power = 2

func _ready():
	pass
	
func _process(delta):
	var strength = pow(trauma,trauma_power)
	offset = Vector2(randf_range(-1,1)*strength,randf_range(-1,1)*strength)
	trauma = max(trauma-decay*delta,0)
	
func shake(strength):
	trauma = strength
