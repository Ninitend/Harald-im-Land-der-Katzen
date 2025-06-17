extends StaticBody2D

@export var cat_color = CatColor.beige
var cat = preload("res://scenes/Cat.tscn")

enum CatColor {
	beige = 0,
	white = 1,
	gray = 2,
	brown = 3
}

func _ready() -> void:
	$Sprite2D.frame = cat_color

func _process(_delta: float) -> void:
	var children = get_children()
	var skeletons = false
	for child in children:
		if child is Enemy:
			skeletons = true
	if not skeletons:
		var new_cat = cat.instantiate()
		get_tree().root.add_child(new_cat)
		new_cat.position = global_position
		new_cat.cat_color = cat_color
		new_cat.change_color()
		queue_free()
