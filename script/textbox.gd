extends CanvasLayer

@onready var textboxContainer = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _ready() -> void:
	hide_texbox()
	add_text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.")



func hide_texbox():
	label.text = ""
	start_symbol.text = ""
	end_symbol.text = ""
	textboxContainer.hide()

func show_textbox():
	start_symbol.text = "-"
	textboxContainer.show()

func add_text(next_text):
	label.text = next_text
	show_textbox()
