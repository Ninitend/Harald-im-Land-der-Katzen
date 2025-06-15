extends CanvasLayer

var tween = create_tween()
var char_read_rate = 0.05

@onready var textboxContainer = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var textbox_content = $TextboxContainer/MarginContainer/HBoxContainer/Label

func _ready() -> void:
	hide_texbox()
	add_text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.")



func hide_texbox():
	textbox_content.text = ""
	start_symbol.text = ""
	end_symbol.text = ""
	textboxContainer.hide()

func show_textbox():
	start_symbol.text = "-"
	textboxContainer.show()

func add_text(next_text):
	textbox_content.text = next_text
	show_textbox()
	textbox_content.visible_ratio = 0.0
	tween.tween_property(textbox_content, "visible_ratio", 1.0, len(next_text) * char_read_rate)
