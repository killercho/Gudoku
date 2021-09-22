extends CanvasLayer

signal clear_screen
onready var game = get_parent().get_child(0)
onready var label = get_node("Game")

func _ready():
	if connect("clear_screen", game, "on_Clear_button_pressed") != OK:
		print("Something went wrong when connecting to 'clear_screen' signal!")

func _on_Quit_pressed():
	get_tree().quit()


func _on_Clear_pressed():
	label.text = ""
	emit_signal("clear_screen")

func on_Game_end_signal(won):
	if won:
		label.text = "You Won! Congrats"
	else:
		label.text = "Game Over! GL Next!"
