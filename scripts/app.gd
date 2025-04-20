extends Control
@onready var global_time: Label = $vertical_layout/header/layout/global_time

@onready var entries_needs: VBoxContainer = $vertical_layout/body/columns/needs/scroller/entries
@onready var entries_tasks: VBoxContainer = $vertical_layout/body/columns/tasks/scroller/entries
@onready var entries_amusements: VBoxContainer = $vertical_layout/body/columns/amusement/scroller/entries
@onready var autoload: CheckButton = $vertical_layout/header/layout/autoload

const TIME_CARD = preload("res://scenes/time_card.tscn")

@export var variation = ["Planned ", "Is "]
@export var prefix := "Time: "
@export var suffix := " h remaining"

@export var _stop_min_max := true

var _save = save_tasks.new()
var _load = load_task.new()

#zeiten als ziel oder range

func _ready() -> void:
	print(Settings.settings["autoload"])
	if Settings.settings["autoload"] == "true":
		_load.load_tasks([entries_needs, entries_tasks, entries_amusements])
		autoload.button_pressed = true
	update_global_time()
	Global.timing_changed.connect(update_global_time)
	Global.stop_min_max = _stop_min_max
	
func update_global_time():
	global_time.text = str(variation[0], prefix, Global.remaining_planned_time, " / ",Global.total_day_time, suffix, " | ", variation[1], prefix, Global.remaining_is_time, " / ",Global.total_day_time, suffix)


func _on_new_need_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_needs.add_child(inst)


func _on_new_task_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_tasks.add_child(inst)


func _on_new_amusement_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_amusements.add_child(inst)



func _on_autoload_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	Settings.change_setting("autoload", toggled_on)
	

	
func _on_save_pressed() -> void:
	_save.get_data(entries_needs, entries_tasks, entries_amusements)

func _on_load_pressed() -> void:
	_load.load_tasks([entries_needs, entries_tasks, entries_amusements])
