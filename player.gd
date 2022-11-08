extends KinematicBody2D

export var velocity_mult = 300.0
"""Player movement multiplier"""

export var play_area_path : NodePath = "PlayArea"
onready var _play_area = get_node(play_area_path) as PlayArea
"""Reference to gameplay area (for navigation purposes)"""

# TODO: This could also be a single box
onready var _upper_limit_point = get_node("UpperLimitPoint")
onready var _lower_limit_point = get_node("LowerLimitPoint")
"""Points that defines where the player 'hits their head' on play area constraints"""

onready var _collision_box = get_node("CollisionShape2D")

func _ready():
	if _play_area == null:
		push_warning("Player has no reference to play area. Out of bounds navigation is possible.")

var velocity = Vector2.ZERO
func _physics_process(_delta):
	
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = velocity * velocity_mult
	var _unused = move_and_slide(velocity)
	
	if _play_area:
		
		# Apply upper limit
		# Clamp the global pos of the upper limit point so it stays below "ceiling"
		# Then, set the player at this position, plus an offset relative to that collision point
		# Remember that top of the screen => y = 0, which is why we use min and not max
		position.y = clamp(_upper_limit_point.global_position.y, _play_area.get_ceiling_min_y(), _play_area.height_scaled) - _upper_limit_point.position.y
		
		# Apply lower limit (bottom of screen)
		position.y = clamp(_lower_limit_point.global_position.y, 0, _play_area.height_scaled) - _lower_limit_point.position.y
		
		# Clamp horizontal movement too (for now just use player center
		position.x = clamp(position.x, 0, _play_area.width_scaled)
		
		# Apply fake perspective scaling on player, based on distance to edges
		var t = inverse_lerp(_play_area.get_ceiling_min_y(), _play_area.height_scaled, position.y)
		var new_scale = lerp(_play_area.min_persp_scaling, _play_area.max_persp_scaling,t)
		_collision_box.scale.x = new_scale
		_collision_box.scale.y = new_scale
		
