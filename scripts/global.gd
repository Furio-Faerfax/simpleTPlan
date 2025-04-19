extends Node
signal send_console_message(str)
signal timing_changed

const total_day_time := 24
var remaining_planned_time :float = total_day_time
var remaining_is_time :float = total_day_time

var stop_min_max := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pr(_str: String):
	send_console_message.emit(_str)
	print(_str)
	

func change_remaining_time(label: String, val: float):
	match label:
		"planned":
			if stop_min_max && remaining_planned_time >= val && remaining_planned_time <= total_day_time-val || !stop_min_max:
				remaining_planned_time += val
				#print(remaining_time)
				timing_changed.emit()
		"is":
			if stop_min_max && remaining_is_time <= total_day_time-val || !stop_min_max:
				remaining_is_time += val
				timing_changed.emit()
		_:
			pass
