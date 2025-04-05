extends Node
signal send_console_message(str)
signal timing_changed

const total_day_time := 24
var remaining_time :float = total_day_time


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pr(_str: String):
	send_console_message.emit(_str)
	print(_str)
	

func change_remaining_time(val: float):
	if remaining_time >= val && remaining_time <= total_day_time-val:
		remaining_time += val
		print(remaining_time)
		timing_changed.emit()
