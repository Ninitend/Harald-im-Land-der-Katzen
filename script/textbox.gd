extends CanvasLayer

@onready var textboxContainer = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var content = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {
	Ready,
	Reading,
	Finished
}

var tween = null
var char_read_rate: float = 0.05
var current_state: State = State.Ready
var text_queue = []


func _ready() -> void:
	hide_texbox()
	queue_text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod.")
	queue_text("Labore et dolore magna aliquyam erat, sed diam voluptua.")
	queue_text("At vero eos et accusam et justo duo dolores et ea rebum.")


func _process(_delta: float) -> void:
	match current_state:
		State.Ready:
			if not text_queue.is_empty():
				display_text()
		State.Reading:
			if Input.is_action_just_pressed("dialogue_enter"):
				tween.kill()
				content.visible_ratio = 1.0
				text_finished()
		State.Finished:
			if Input.is_action_just_pressed("dialogue_enter"):
				if text_queue.is_empty():
					change_state(State.Ready)
					hide_texbox()
				else:
					display_text()


func queue_text(text: String) -> void:
	text_queue.push_back(text)


func hide_texbox() -> void:
	content.text = ""
	start_symbol.text = ""
	end_symbol.text = ""
	textboxContainer.hide()


func show_textbox() -> void:
	start_symbol.text = "-"
	textboxContainer.show()


func display_text() -> void:
	change_state(State.Reading)
	var next_text = text_queue.pop_front()
	content.text = next_text
	content.visible_ratio = 0.0
	show_textbox()
	tween = create_tween()
	tween.tween_property(content, "visible_ratio", 1.0, len(next_text) * char_read_rate)
	tween.tween_callback(text_finished)


func text_finished() -> void:
	end_symbol.text = "v"
	change_state(State.Finished)


func change_state(next_state) -> void:
	current_state = next_state
	match current_state:
		State.Ready:
			print("Textbox: Ready")
		State.Reading:
			print("Textbox: Reading")
		State.Finished:
			print("Textbox: Finished")
