extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://level/level.tscn"))

func _on_show_timer_toggled(toggled_on: bool) -> void:
	Global.show_timer = toggled_on
