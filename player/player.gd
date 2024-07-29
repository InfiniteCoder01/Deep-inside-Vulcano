class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const SLIDE_VELOCITY = 100.0
const KICK_VELOCITY = 800.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: PlayerAnimationTree = $AnimationTree
@onready var feet: Area2D = $Feet
@onready var left: Area2D = $Left
@onready var right: Area2D = $Right
@onready var jump_sfx: AudioStreamPlayer = $JumpSFX

var last_grounded := 0.0
var sliding := false
var stamina := 0.0

func _physics_process(delta: float) -> void:
	animation_tree.jump = false
	animation_tree.kick = false

	if stamina > 0.0: stamina -= delta

	var horizontal_input := Input.get_axis("left", "right")
	var target_velocity := horizontal_input * SPEED
	velocity.x += (target_velocity - velocity.x) * 0.1;

	velocity += get_gravity() * delta
	if sliding:
		velocity.y = min(velocity.y, SLIDE_VELOCITY)
		if Input.is_action_just_pressed("jump"):
			animation_tree.kick = true
			jump_sfx.play()
			stamina -= 2.0
			velocity.y = JUMP_VELOCITY
			velocity.x = -horizontal_input * KICK_VELOCITY
	elif Input.is_action_just_pressed("jump") && last_grounded < 0.1:
		jump_sfx.play()
		animation_tree.jump = true
		velocity.y = JUMP_VELOCITY

	if abs(velocity.x) > 40.0:
		sprite.flip_h = velocity.x < 0

	if feet.has_overlapping_bodies():
		last_grounded = 0.0
		stamina = 5.0
	else: last_grounded += delta

	sliding = ((horizontal_input > 0 && right.has_overlapping_bodies()) ||
			   (horizontal_input < 0 && left.has_overlapping_bodies())) && stamina > 0.0

	var motion := velocity * delta
	var collision_info := move_and_collide(motion, true, 0.2)
	if collision_info:
		var resolved := false
		if velocity.y < 0:
			const STEP := 0.5
			const MAX_DEVIATION := 3.0

			var step_dir := Vector2(-velocity.y, velocity.x).normalized()
			for i in range(1, MAX_DEVIATION / STEP):
				var deviation := i * STEP
				for dir in range(-1, 2, 2):
					var correction := step_dir * dir * deviation
					if !move_and_collide(motion + correction, true, 0.2):
						resolved = true
						position += motion + correction
						break
				if resolved: break

		if !resolved:
			velocity -= collision_info.get_normal() * collision_info.get_normal().dot(velocity)
			position += collision_info.get_travel()
	else: position += motion
