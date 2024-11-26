extends CharacterBody2D
class_name Cat

func _ready() -> void:
	$Animation.play("idle")


# ---------- Node Signals --------------------
func _on_sight_range_body_entered(body: Node2D) -> void:
	if body is Player:
		$Animation.play('walk')


func _on_sight_range_body_exited(body: Node2D) -> void:
	if body is Player:
		$Animation.play('idle')
