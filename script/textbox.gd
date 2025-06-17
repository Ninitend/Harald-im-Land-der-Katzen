extends CanvasLayer

@onready var textbox = $TextboxContainer
@onready var end_indicator = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var content = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {
	Ready,
	Writing,
	Finished
}

var tween = null
var char_read_rate: float = 0.05
var current_state: State = State.Ready
var text_queue = []

signal dialogue_start
signal dialogue_end

func _ready() -> void:
	queue_text("Hilfe, hilfe, meine Kätzchen sind von Skeletten entführt und eingesperrt worden!")
	queue_text("Kannst du mir helfen, meine geliebten Kätzchen zu retten?")
	queue_text("Besiege alle Skelette bei den Käfigen, um sie zu befreien.")


func _process(_delta: float) -> void:
	match current_state:
		State.Ready:
			if not text_queue.is_empty():
				display_text()
		State.Writing:
			if Input.is_action_just_pressed("dialogue_enter"):
				tween.kill()
				content.visible_ratio = 1.0
				text_finished()
		State.Finished:
			if Input.is_action_just_pressed("dialogue_enter"):
				if text_queue.is_empty():
					hide_textbox()
					change_state(State.Ready)
				else:
					display_text()


func queue_text(text: String) -> void:
	text_queue.push_back(text)


func hide_textbox() -> void:
	content.text = ""
	textbox.hide()
	dialogue_end.emit()


func show_textbox() -> void:
	textbox.show()
	dialogue_start.emit()


func display_text() -> void:
	change_state(State.Writing)
	var next_text = text_queue.pop_front()
	content.text = next_text
	end_indicator.hide()
	content.visible_ratio = 0.0
	show_textbox()
	tween = create_tween()
	tween.tween_property(content, "visible_ratio", 1.0, len(next_text) * char_read_rate)
	tween.tween_callback(text_finished)


func text_finished() -> void:
	end_indicator.show()
	change_state(State.Finished)


func change_state(next_state: State) -> void:
	current_state = next_state
	match current_state:
		State.Ready:
			print("Textbox: Ready")
		State.Writing:
			print("Textbox: Reading")
		State.Finished:
			print("Textbox: Finished")
