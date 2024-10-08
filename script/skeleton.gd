extends CharacterBody2D
class_name Enemy

const speed = 35
var distance_to_player = 10
var player = null
var health = 2
var last_direction = "down"


func _physics_process(_delta: float) -> void:
	movement()
	hurt()

 
func movement():
	if player != null and health > 0:
		var direction = (player.global_position - global_position).normalized()
		if (player.global_position - global_position).length() < distance_to_player:
			velocity = Vector2(0, 0)
		else:
			velocity = direction * speed
		
		if abs(direction.x) > abs(direction.y):
			if direction.x < 0:
				last_direction = "left"
				if health > 0:
					$Sprite.play('walk_side')
					$Sprite.flip_h = true
			if direction.x > 0:
				last_direction = "right"
				if health > 0:
					$Sprite.play('walk_side')
					$Sprite.flip_h = false
		else:
			if direction.y < 0:
				last_direction = "up"
				if health > 0:
					$Sprite.play('walk_back')
					$Sprite.flip_h = false
			if direction.y > 0:
				last_direction = "down"
				if health > 0:
					$Sprite.play('walk_front')
					$Sprite.flip_h = false
			
	else:
		velocity = Vector2(0, 0)
		if health > 0:
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
