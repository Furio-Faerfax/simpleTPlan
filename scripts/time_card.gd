extends Panel
@onready var delete: Button = $delete
@onready var time: Label = $split/time/HBoxContainer/time
@onready var title_label: LineEdit = $split/container/title

@export var _fixed := false #Fixed cards like sleep cannot be deleted
@export var time_step := 0.5
@export var time_preset := 0.0
@export var title := ""

var time_val :float = 0.0


func _ready() -> void:
	title_label.text = title
	
	if time_preset > 0.0:
		time_val = time_preset
		time.text = str(time_val)
		Global.change_remaining_time(-time_val) 
		
	if _fixed:
		delete.queue_free()


func _on_delete_pressed() -> void:
	queue_free()


func _on_up_pressed() -> void:
	if time_val <= 24-time_step:
		time_val += time_step
		time.text = str(time_val)
		Global.change_remaining_time(-time_step)


func _on_down_pressed() -> void:
	if time_val >= time_step:
		time_val -= time_step
		time.text = str(time_val)
		Global.change_remaining_time(time_step)
