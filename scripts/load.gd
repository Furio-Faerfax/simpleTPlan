extends Node

class_name load_task
const TIME_CARD = preload("res://scenes/time_card.tscn")

var saved_tasks_data

func load_tasks(columns):
	var file = FileAccess.open(str(Settings.user_dir,Settings.task_file), FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var result = json.parse(json_string)
	
	if result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	else:
		saved_tasks_data = json.data
		print(saved_tasks_data)
		_empty_board(columns, true)
		_spawn_tasks(columns)

	
func _empty_board(columns, delete_sleep):
	for all in columns:
		_empty_column(all, delete_sleep)

func _empty_column(column, delete_sleep):
	if column.get_child_count() > 0:
		for each in column.get_children():
			if each.title == "Sleep" && !delete_sleep:
				continue
			each.queue_free()

func _spawn_tasks(columns):
	var column := 0
	for each in saved_tasks_data:
		for entry in each:
			var card = TIME_CARD.instantiate()
			
			card.title = entry[0]
			card.planned_time_val = entry[1]
			
			if entry[0] == "Sleep":
				card._fixed = true
			
			columns[column].add_child(card)
		column += 1
