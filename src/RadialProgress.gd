tool
extends Control

const resolution: int = 128

export (float) var radius = 100.0
export (float) var width = 30.0
export (Color) var color = Color()
export (bool) var center_in_parent = true
export (float) var cur_amount = 0.5

onready var radius_ratio = radius/ProjectSettings.get_setting("display/window/size/width")
onready var width_ratio = width/ProjectSettings.get_setting("display/window/size/width")

func _ready():
	if Engine.editor_hint:
		set_process(true)
	else:
#		set_pocess(false)
		set_process(true)

func _process(delta):
	if not Engine.editor_hint:
		radius = radius_ratio * get_viewport().size.x
		width = width_ratio * get_viewport().size.x
#	cur_amount += delta/10.0
#	if cur_amount >= 1.0:
#		cur_amount = 0.0
	update()

func _draw():
	var cur_rotation = 0.0
	var points: Array = []
#	rect_size = Vector2(2*radius + width, 2*radius + width)
	while cur_rotation < (2*PI)*cur_amount:
		points.append(Vector2(radius, 0).rotated(cur_rotation))
		points[points.size() - 1] += rect_size / 2
		cur_rotation += (2*PI)/resolution
	points.append(Vector2(radius, 0).rotated((2*PI)*cur_amount + (2*PI)/resolution))
	points.append(Vector2(radius, 0).rotated((2*PI)*cur_amount + 2*(2*PI)/resolution))
	points[points.size() - 1] += rect_size / 2
	draw_polyline(points, color, width, true)
#	if center_in_parent:
#		rect_position = -rect_size/2