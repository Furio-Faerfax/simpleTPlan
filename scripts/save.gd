extends Node

class_name  save_tasks

func get_data(needs, tasks, amusements):
	var data_array := []
	var data :JSON = JSON.new()
	
	var entry_data := []
	for entry in needs.get_children():
		entry_data.push_back(get_entry_data(entry))
	data_array.push_back(entry_data)
	
	entry_data = []
	for entry in tasks.get_children():
		entry_data.push_back(get_entry_data(entry))
	data_array.push_back(entry_data)
		
	entry_data = []
	for entry in amusements.get_children():
		entry_data.push_back(get_entry_data(entry))
	data_array.push_back(entry_data)
	
	var data_string := JSON.stringify(data_array)
	data.parse(data_string)
	save_tasks(data_string)

func get_entry_data(entry) -> Array:
	return [entry.title_label.text,entry.planned_time_val]#,entry.is_time_val]
	

func save_tasks(data: String):
	var file = FileAccess.open(str(Settings.user_dir,Settings.task_file), FileAccess.WRITE)
	file.store_string(data)
	file.close()
