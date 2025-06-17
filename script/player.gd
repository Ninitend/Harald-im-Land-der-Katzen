extends CharacterBody2D
class_name Player

const SPEED = 130
var last_direction = "down"
var attack_in_progress = false
var hurt_cooldown = false
var health = 4
var movement_disabled = true


func _physics_process(_delta: float) -> void:
	if movement_disabled:
		return
	movement()
	update_attack_range()
	attack()

func movement():
	var direction_x = Input.get_axis("walk_left", "walk_right")
	var direction_y = Input.get_axis("walk_up", "walk_down")
	
	if direction_x and health > 0:
		velocity.x = direction_x * SPEED
		
		if attack_in_progress == false and health > 0:
			$Sprite.play("walk_side")
		if direction_x == 1:
			last_direction = "right"
			$Sprite.flip_h = false
		if direction_x == -1:
			last_direction = "left"
			$Sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y and health > 0:
		velocity.y = direction_y * SPEED
		
		$Sprite.flip_h = false
		if direction_y == 1:
			last_direction = "down"
			if attack_in_progress == false and health > 0:
				$Sprite.play("walk_front")
		if direction_y == -1:
			last_direction = "up"
			if attack_in_progress == false and health > 0:
				$Sprite.play("walk_back")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if direction_x == 0 and direction_y == 0:
		match last_direction:
			"left":
				$Sprite.flip_h = true
				if attack_in_progress == false and health > 0:
					$Sprite.play("idle_side")
			"right":
				$Sprite.flip_h = false
				if attack_in_progress == false:
					$Sprite.play("idle_side")
			"up":
				$Sprite.flip_h = false
				if attack_in_progress == false and health > 0:
					$Sprite.play("idle_back")
			"down":
				$Sprite.flip_h = false
				if attack_in_progress == false and health > 0:
					$Sprite.play("idle_front")
	
	move_and_slide()

func attack():
	if Input.is_action_just_pressed("attack") and not attack_in_progress:
		attack_in_progress = true
		$AttackCooldown.start()
		match last_direction:
			"up":
				$Sprite.play("attack_back")
			"left":
				$Sprite.flip_h = true
				$Sprite.play("attack_side")
			"down":
				$Sprite.play("attack_front")
			"right":
				$Sprite.flip_h = false
				$Sprite.play("attack_side")
		for body in $AttackRange.get_overlapping_areas():
			global.player_attack_success = true

func hurt():
	if not hurt_cooldown:
		print("aua")
		health -= 1
		hurt_cooldown = true
		$HurtCooldown.start()
		if health <= 0:
			print("tot")
			$Sprite.play("death")
			$DeathDuration.start()

func update_attack_range():
	match last_direction:
		"up":
			$AttackRange/Cone.rotation_degrees = 180 +90
		"left":
			$AttackRange/Cone.rotation_degrees = 90+90
		"down":
			$AttackRange/Cone.rotation_degrees = 0+90
		"right":
			$AttackRange/Cone.rotation_degrees = 270+90


# ---------- Node Signals --------------------
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		hurt()


func _on_attack_cooldown_timeout() -> void:
	attack_in_progress = false


func _on_hurt_cooldown_timeout() -> void:
	hurt_cooldown = false


func _on_death_duration_timeout() -> void:
	print("Player dead")
	queue_free()
