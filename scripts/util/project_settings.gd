extends Node

class_name project_settings

	
func _add_autoload_singleton(path, _name):
	var script_path = path
	var _script = load(script_path)


func setup() -> void:
	#Credit goes out to Heartbeast, his video got me the idea of this template project
	ProjectSettings.set("display/window/size/viewport_width", 320)
	ProjectSettings.set("display/window/size/viewport_height", 180)
	ProjectSettings.set("display/window/size/window_width_override", 1920)
	ProjectSettings.set("display/window/size/window_height_override", 1080)
	ProjectSettings.set("display/window/stretch/mode", "canvas_items")
	ProjectSettings.set("rendering/textures/canvas_textures/default_texture_filter", "Nearest")
	ProjectSettings.save()
