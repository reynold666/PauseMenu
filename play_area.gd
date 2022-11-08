class_name PlayArea
extends Sprite

export var ceiling_y = 0.35
"""Fraction of the play area (from top) at which the depth 'ceiling' is, where the player can no longer navigate."""

export(float, 0.1, 1.0) var min_persp_scaling
export(float, 1.0, 3.0) var max_persp_scaling

export var debug := false setget toggle_debug
"""Show debug play area constraints"""

onready var width_texture = self.texture.get_width()
onready var height_texture = self.texture.get_height()
onready var width_scaled = width_texture * self.scale.x
onready var height_scaled = height_texture * self.scale.y

func get_ceiling_min_y():
	return ceiling_y * height_scaled

func toggle_debug(val):
	debug = val
	update()  # Force redraw
		
func _draw():
	if debug:
		var line_height = ceiling_y * height_texture
		draw_line(Vector2(0, line_height), Vector2(width_texture, line_height),Color.red, 1.5)
