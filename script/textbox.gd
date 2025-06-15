extends CanvasLayer

@onready var textboxContainer = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var content = $TextboxContainer/MarginContainer/HBoxContainer/Label

var tween = create_tween()
var char_read_rate = 0.05
var current_state = State.Ready
var text_queue = []

enum State {
	Ready,
	Reading,
	Finished
}



func _ready() -> void:
	hide_texbox()
	queue_text("1. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
	queue_text("2. Irgendwas stimmt da nicht, oder?")

func _process(delta: float) -> void:
	match current_state:
		State.Ready:
			if !text_queue.is_empty():
				display_text()
		State.Reading:
			if Input.is_action_just_pressed("dialogue_enter"):
				content.visible_ratio = 1.0
				tween.kill()
				end_symbol.text = "v"
				change_state(State.Finished)
		State.Finished:
			if Input.is_action_just_pressed("dialogue_enter"):
				change_state(State.Ready)
				hide_texbox()


func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_texbox():
	content.text = ""
	start_symbol.text = ""
	end_symbol.text = ""
	textboxContainer.hide()

func show_textbox():
	start_symbol.text = "-"
	textboxContainer.show()

func display_text():
	var next_text = text_queue.pop_front()
	content.text = next_text
	content.visible_ratio = 0.0
	change_state(State.Reading)
	show_textbox()
	
	tween.tween_property(content, "visible_ratio", 1.0, len(next_text) * char_read_rate)
	tween.finished.connect(_on_tween_finished)
	
func _on_tween_finished():
	end_symbol.text = "v"
	change_state(State.Finished)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.Ready:
			print("Textbox: Ready")
		State.Reading:
			print("Textbox: Reading")
		State.Finished:
			print("Textbox: Finished")
