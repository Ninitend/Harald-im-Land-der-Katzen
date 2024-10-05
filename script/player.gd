extends CharacterBody2D


const SPEED = 170
var last_direction = "down"


func _physics_process(_delta: float) -> void:
	var direction_x = Input.get_axis("walk_left", "walk_right")
	if direction_x:
		$Sprite.play("walk_side")
		if direction_x == 1:
			$Sprite.flip_h = false
			last_direction = "right"
		if direction_x == -1:
			$Sprite.flip_h = true
			last_direction = "left"
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var direction_y = Input.get_axis("walk_up", "walk_down")
	if direction_y:
		velocity.y = direction_y * SPEED
		$Sprite.flip_h = false
		if direction_y == 1:
			$Sprite.play("walk_front")
			last_direction = "down"
		if direction_y == -1:
			$Sprite.play("walk_back")
			last_direction = "up"
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if direction_x == 0 and direction_y == 0:
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
