extends CharacterBody2D
class_name Cat

enum CatType {OLD, NEW}

@export var type: CatType

func _ready() -> void:
	if type == CatType.OLD:
		$Animation.play("idle")
	else:
		$Animation.play("idle_new")


func _physics_process(_delta: float) -> void:
	move_and_slide()


# ---------- Node Signals --------------------
func _on_sight_range_body_entered(body: Node2D) -> void:
	if body is Player:
		if type == CatType.OLD:
			$Animation.play("walk")
		else:
			$Animation.play("walk_new")
		velocity.x = -15
		velocity.y = -5


func _on_sight_range_body_exited(body: Node2D) -> void:
	if body is Player:
		if type == CatType.OLD:
			$Animation.play("idle")
		else:
			$Animation.play("idle_new")
		velocity.x = 0
		velocity.y = 0
