extends Node2D

var time := 0.0
var started := false

func _ready():
	# Source: https://padamthapa.com/blog/how-to-set-camera-2d-boundary-in-godot/
	var camera := get_viewport().get_camera_2d()
	var tile_map: TileMap = $TileMap
	var map_limits := tile_map.get_used_rect()
	var map_tile_size := tile_map.tile_set.tile_size
	camera.limit_left = map_limits.position.x * map_tile_size.x
	camera.limit_right = map_limits.end.x * map_tile_size.x
	camera.limit_top = map_limits.position.y * map_tile_size.y
	camera.limit_bottom = map_limits.end.y * map_tile_size.y

	%EndGame.on_activated.connect(end_game)

func _process(delta: float) -> void:
	if started: time += delta
	var timer: Label = $"CanvasLayer/MarginContainer/Timer"
	timer.visible = Global.show_timer

	var minutes := time / 60.0
	var seconds := fmod(time, 60.0)
	timer.text = " %02d:%02.2f" % [minutes, seconds]

func end_game() -> void:
	for child in %Pipe.get_children():
		if child is not Tap: continue
		if child.open: continue
		%EndGame.open = false
		return

	var minutes := time / 60.0
	var seconds := fmod(time, 60.0)
	%WinMessage.text = %WinMessage.text.replace("$TIME", "%02d:%02.2f" % [minutes, seconds])
	%WinMessage.visible = true

func _on_start_game_body_entered(_body: Node2D) -> void:
	started = true
