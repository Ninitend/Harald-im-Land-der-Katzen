extends CharacterBody2D
class_name Enemy

var player = null
var health = 3
var last_direction = "down"

@onready cage = get_parent()

# Settings
const speed = 35
const min_player_distance = 20
const min_cage_distance = 100
const max_cage_distance = 220


func _physics_process(_delta: float) -> void:
	movement()
	hurt()

 
func movement():
	var direction = "down"

	if health <= 0:
		return
	
	if player != null:
		direction = global_position.direction_to(player.global_position)
		if global_position.distance_to(player.global_position) > min_player_distance:
			velocity = direction * speed
		else:
			velocity = Vector2(0, 0)

	if player == null or global_position.distance_to(cage.global_position) > max_cage_distance:
		direction = global_position.direction_to(cage.global_position)
		if global_position.distance_to(cage.global_position) > min_cage_distance:
			velocity = direction * speed
		else:
			velocity = Vector2(0, 0)
		if player != null:
			direction = global_position.direction_to(player.global_position)
			velocity = Vector2(0, 0)

	
	if velocity.length() > 1:
		if abs(direction.x) > abs(direction.y):
			if direction.x < 0:
				last_direction = "left"
				$Sprite.play('walk_side')
				$Sprite.flip_h = true
			if direction.x > 0:
				last_direction = "right"
				$Sprite.play('walk_side')
				$Sprite.flip_h = false
		else:
			if direction.y < 0:
				last_direction = "up"
				$Sprite.play('walk_back')
				$Sprite.flip_h = false
			if direction.y > 0:
				last_direction = "down"
				$Sprite.play('walk_front')
				$Sprite.flip_h = false
	else:
		match last_direction:
			"left":
				$Sprite.flip_h = true
				$Sprite.play("idle_side")
			"right":
				$Sprite.flip_h = false
				$Sprite.play("idle_side")
			"up":
				$Sprite.flip_h = false
				$Sprite.play("idle_back")
			"down":
				$Sprite.flip_h = false
				$Sprite.play("idle_front")

	move_and_slide()

func hurt():
	if global.player_attack_success == true:
		global.player_attack_success = false
		health -= 1
		print("Hit")
		if health <= 0:
			$Sprite.stop()
			$Sprite.play("death")
			$DeathDuration.start()


# ---------- Node Signals --------------------
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		player = body


func _on_sight_range_body_exited(_body: Node2D) -> void:
	player = null


func _on_skeleton_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_skeleton_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_death_duration_timeout() -> void:
	print("Skeleton dead")
	queue_free()
