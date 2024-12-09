extends Node2D

@onready var ray = $RayCast2D

var grounded = false
var jumping = false

var gravity = 15
var jump_speed = -500

var max_y_v = 300
var y_v = 0

func _physics_process(delta: float) -> void:
	if not grounded:
		y_v = min(max_y_v, y_v + gravity)
	else:
		y_v = 0
	grounded = false
	
	var jump = Input.is_action_just_pressed("jump") and not jumping
	
	if jump:
		jumping = true
		y_v = jump_speed
	
	position.y += y_v * delta

	if not jump:
		if ray.is_colliding():
			var origin = ray.global_transform.origin
			var collision = ray.get_collision_point()
			var dist = abs(origin.y - collision.y)
			var depth = abs(ray.target_position.y - dist)
			
			grounded = true
			jumping = false
			
			position.y -= depth
