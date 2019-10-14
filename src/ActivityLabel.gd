extends Label

const time_keeper = preload("res://time_keeper.tres")

func _ready():
	time_keeper.connect("next_time_segment", self, "_on_next_time_segment")

func _on_next_time_segment(new_time_segment):
	text = new_time_segment