extends Label

const time_keeper = preload("res://time_keeper.tres")

onready var font_ratio = float(theme.default_font.size)/ProjectSettings.get_setting("display/window/size/width")

func _ready():
	time_keeper.connect("next_time_segment", self, "_on_next_time_segment")

func _process(delta):
	theme.default_font.size = font_ratio * get_viewport().size.x

func _on_next_time_segment(new_time_segment):
	text = new_time_segment