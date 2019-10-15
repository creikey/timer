extends Resource

signal time_updated(new_time_left, time_maximum) # always in seconds
signal next_time_segment(new_time_segment_label) # text describing time segment
signal new_iteration(cur_iterations)


var time_left: int = 35 setget set_time_left
var time_maximum: int = 50
var iterations: int = 0

var cur_delta = 0.0

var time_loop: Array = [
	["work", 1],
	["break", 2]
]
var cur_time_loop_position: int = 0 setget set_cur_time_loop_position

func ready():
	self.cur_time_loop_position = 0

func process(delta):
	cur_delta += delta
	if cur_delta >= 1.0:
		cur_delta = 0.0
		self.time_left -= 1
#		print(self.time_left, "	", self.time_maximum)

func set_time_left(new_time_left):
	if new_time_left < 0:
		next_time_segment()
	else:
		time_left = new_time_left
		emit_signal("time_updated", time_left, time_maximum)

func next_time_segment():
	self.cur_time_loop_position += 1
	

func reset_time_segments():
	self.cur_time_loop_position = 0

func set_cur_time_loop_position(new_cur_time_loop_position):
	cur_time_loop_position = new_cur_time_loop_position
	
	# wrap around array
	if cur_time_loop_position < time_loop.size():
		pass
	else:
		cur_time_loop_position = 0
		iterations += 1
		emit_signal("new_iteration", iterations)
	
	# update time segment labels and time lefts
	var cur_time_segment = time_loop[cur_time_loop_position]
	emit_signal("next_time_segment", cur_time_segment[0])
	time_maximum = cur_time_segment[1]
	self.time_left = time_maximum