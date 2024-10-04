extends CharacterBody2D

var speed = 35
var player = null
var last_direction = "down"

func _physics_process(_delta: float) -> void:
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		if (player.global_position - global_position).length() < 30:
			velocity = Vector2(0, 0)
		else:
			velocity = direction * speed
		
		if abs(direction.x) > abs(direction.y):
			if direction.x < 0:
				$Sprite.play('walk_side')
				$Sprite.flip_h = true
				last_direction = "left"
			if direction.x > 0:
				$Sprite.play('walk_side')
				$Sprite.flip_h = false
				last_direction = "right"
		else:
			if direction.y < 0:
				$Sprite.play('walk_back')
				$Sprite.flip_h = false
				last_direction = "up"
			if direction.y > 0:
				$Sprite.play('walk_front')
				$Sprite.flip_h = false
				last_direction = "down"
			
	else:
		velocity = Vector2(0, 0)
		if last_direction == "left":
			$Sprite.flip_h = true
			$Sprite.play("idle_side")
		if last_direction == "right":
			$Sprite.flip_h = false
			$Sprite.play("idle_side")
		if last_direction == "up":
			$Sprite.flip_h = false
			$Sprite.play("idle_back")
		if last_direction == "down":
			$Sprite.flip_h = false
			$Sprite.play("idle_front")		

	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body

func _on_sight_range_body_exited(_body: Node2D) -> void:
	player = null
