extends Label

const time_keeper = preload("res://time_keeper.tres")

func _ready():
	time_keeper.connect("time_updated", self, "_on_time_updated")

func _on_time_updated(new_time, max_time):
	var hours = int(new_time/60/60)
	new_time -= float(hours) * 60 * 60
	var minutes = int(new_time/60)
	new_time -= float(minutes) * 60
	var seconds = new_time
	
	text = str(maybe_add_zero(hours), hours, ":", \
	maybe_add_zero(minutes), minutes, ":", \
	maybe_add_zero(seconds), seconds)

func maybe_add_zero(in_amount: int) -> String:
	if in_amount < 10:
		return "0"
	else:
		return ""