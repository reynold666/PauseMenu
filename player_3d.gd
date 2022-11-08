## Main player class

class_name Player
extends KinematicBody

## Velocity multiplier for directions
## Note that because of camera setup, using the same number results
## in different visual results for x and z axis, so it's best to set them separately
export(float, 1.0, 10.0) var _vel_horiz_mult = 5.0
export(float, 1.0, 20.0) var _vel_z_mult = 10.0

export var jump_vel := 10.0
export var gravity := 9.8

# Keep ref to project it on ground
onready var shadow_sprite := get_node("Sprite/Shadow") as Sprite3D
onready var _shadow_init_scale := shadow_sprite.scale

func _ready() -> void:
	assert(shadow_sprite != null, "Shadow sprite is missing")

var _velocity := Vector3.ZERO
func _physics_process(delta):
	
	_velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_velocity.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	_velocity.x *= _vel_horiz_mult
	_velocity.z *= _vel_z_mult
	
	# TODO: We might need a better check, when moving we get y vel
	# 		values of around 0.00001 instead of 0. But works for now
	var is_grounded := abs(_velocity.y) < 0.0001 and \
					   abs(global_translation.y) < 0.1 # prevent jump at apex
	
	# Apply gravity accel
	_velocity.y -= gravity * delta
	
	# Handle jump press
	if is_grounded and Input.is_action_just_pressed("jump"):
		_velocity.y = jump_vel
	
	# Move and keep velocity for next frame
	_velocity = move_and_slide(_velocity)
	
	if Input.is_action_pressed("Pause"):
		get_tree().change_scene("res://HUD/PauseMenu.tscn")
	
	
func _process(_delta: float) -> void:
	
	# Doing this allows for parenting shadow to the player in the scene
	shadow_sprite.global_translation.y = 0.0
	
	# Grow the shadow sprite, to simulate height
	var max_shadow_growth_height := 5.0  # After reaching this height, shadow does not grow more
	var t := translation.y / max_shadow_growth_height
	shadow_sprite.scale = lerp(_shadow_init_scale, _shadow_init_scale * 1.2, t)

