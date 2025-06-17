extends CharacterBody2D
class_name Cat
var color_name = null

@export var cat_color = CatColor.beige

enum CatColor {
	beige = 0,
	white = 1,
	gray = 2,
	brown = 3
}

func _ready() -> void:
	change_color()


func change_color():
	match cat_color:
		CatColor.beige:
			color_name = "beige"
		CatColor.white:
			color_name = "white"
		CatColor.gray:
			color_name = "gray"
		CatColor.brown:
			color_name = "brown"
	$Animation.play("idle_front_" + color_name)



func _physics_process(_delta: float) -> void:
	move_and_slide()


# ---------- Node Signals --------------------
func _on_sight_range_body_entered(body: Node2D) -> void:
	if body is Player:
		if false:
			$Animation.play("walk")
		else:
			$Animation.play("walk_new")
		velocity.x = -15
		velocity.y = -5


func _on_sight_range_body_exited(body: Node2D) -> void:
	if body is Player:
		if false:
			$Animation.play("idle")
		else:
			$Animation.play("idle_new")
		velocity.x = 0
		velocity.y = 0
