class_name Tap
extends AnimatedSprite2D

var open := false

signal on_activated()

func turn() -> void:
	if open: return
	open = true
	on_activated.emit()
	for i in range(5):
		play("open")
		await animation_finished

func _on_area_2d_body_entered(_body: Node2D) -> void:
	turn()
