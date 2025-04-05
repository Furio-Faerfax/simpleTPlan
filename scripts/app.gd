extends Control
@onready var global_time: Label = $vertical_layout/header/global_time

@onready var entries_needs: VBoxContainer = $vertical_layout/body/columns/needs/scroller/entries
@onready var entries_tasks: VBoxContainer = $vertical_layout/body/columns/tasks/scroller/entries
@onready var entries_amusements: VBoxContainer = $vertical_layout/body/columns/amusement/scroller/entries

const TIME_CARD = preload("res://scenes/time_card.tscn")

@export var prefix := "Time: "
@export var suffix := " h remaining"
#zeiten als ziel oder range

func _ready() -> void:
	update_global_time()
	Global.timing_changed.connect(update_global_time)
	
func update_global_time():
	global_time.text = str(prefix, Global.remaining_time, " / ",Global.total_day_time, suffix)


func _on_new_need_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_needs.add_child(inst)


func _on_new_task_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_tasks.add_child(inst)


func _on_new_amusement_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_amusements.add_child(inst)
