tool
extends Control

const time_keeper = preload("res://time_keeper.tres")

const resolution: int = 128

export (float) var radius = 100.0
export (float) var width = 30.0
export (Color) var color = Color()
export (float) var cur_amount = 0.5

onready var radius_ratio = radius/ProjectSettings.get_setting("display/window/size/width")
onready var width_ratio = width/ProjectSettings.get_setting("display/window/size/width")

func _ready():
	if Engine.editor_hint:
		set_process(true)
	else:
#		set_pocess(false)
		set_process(true)
# warning-ignore:return_value_discarded
	time_keeper.connect("time_updated", self, "_on_time_updated")

func _on_time_updated(new_time, max_time):
	$ProgressTween.stop_all()
	$ProgressTween.interpolate_property(self, "cur_amount", cur_amount, float(new_time)/float(max_time), 0.9, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$ProgressTween.start()

# warning-ignore:unused_argument
func _process(delta):
	if not Engine.editor_hint:
		radius = radius_ratio * get_viewport().size.x
		width = width_ratio * get_viewport().size.x
#	print(cur_amount)
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
		cur_rotation += (2*PI*cur_amount)/resolution
	if cur_amount == 0.0:
		return
	points.append(Vector2(radius, 0).rotated((2*PI)*cur_amount + (2*PI*cur_amount)/resolution))
	points[points.size() - 1] += rect_size / 2
	points.append(Vector2(radius, 0).rotated((2*PI)*cur_amount + 2*(2*PI*cur_amount)/resolution))
	points[points.size() - 1] += rect_size / 2
	draw_polyline(points, color, width, true)
#	if center_in_parent:
#		rect_position = -rect_size/2