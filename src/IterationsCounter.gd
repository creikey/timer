extends Label

const time_keeper = preload("res://time_keeper.tres")

func _ready():
	text = "0"
	time_keeper.connect("new_iteration", self, "_on_new_iteration")

func _on_new_iteration(iteration):
	text = str(iteration)