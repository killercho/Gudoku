extends Node2D

const NROWS = 8
const NCOLS = 8
const INVALID_TILE = Vector2(-1.0, -1.0)
var tilemap_transform
var counter = 1
var placed_tiles = []
onready var tilemap = get_node("TileMap")
var possibilities = []

onready var ui = get_parent().get_child(1)
signal game_over(won)

func _ready():
	if connect("game_over", ui, "on_Game_end_signal") != OK:
		print("Something went wrong when connecting to 'game_over' signal!")
	tilemap_transform = tilemap.get_transform()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			var cell_index = mouse_to_cell_pos(get_global_mouse_position())
			if counter == 1 and is_valid(cell_index):
				tilemap.set_cell(cell_index.x, cell_index.y, counter)
				counter += 1
				placed_tiles.append(cell_index)
				light_possibilities(cell_index)
			elif is_valid(cell_index) and possibilities.has(cell_index):
				tilemap.set_cell(cell_index.x, cell_index.y, counter)
				counter += 1
				placed_tiles.append(cell_index)
				light_possibilities(cell_index)
				check_completed()

func mouse_to_cell_pos(mouse_pos):
	if mouse_pos.x < 512 and mouse_pos.y < 512:
		mouse_pos.x = mouse_pos.x / tilemap_transform.x.x
		mouse_pos.y = mouse_pos.y / tilemap_transform.y.y
		var cell_pos = tilemap.world_to_map(mouse_pos)
		return Vector2(cell_pos.x, cell_pos.y)
	else:
		return INVALID_TILE

func check_completed():
	if placed_tiles.size() == 64:
		print("You win! Congrats!")
		emit_signal("game_over", true)

func is_invalid(cell_index):
	if cell_index.x < 0 or cell_index.y < 0 or cell_index.x > 8 or cell_index.y > 8:
		return true
	else:
		return false

func is_valid(cell_index):
	if placed_tiles.has(cell_index) or is_invalid(cell_index):
		return false
	else:
		return true

func on_Clear_button_pressed():
	placed_tiles.clear()
	counter = 1
	for x in range(NROWS):
		for y in range(NCOLS):
			tilemap.set_cell(x, y, 0)

func light_possibilities(cell_index):
	for i in possibilities:
		if is_valid(i):
			tilemap.set_cell(i.x, i.y, 0)
	possibilities.clear()
	
	var potential_possibilities = []
	
	#Appending every possible position for next moves
	potential_possibilities.append(Vector2(cell_index.x + 1, cell_index.y - 2)) 
	potential_possibilities.append(Vector2(cell_index.x + 2, cell_index.y - 1))
	potential_possibilities.append(Vector2(cell_index.x + 1, cell_index.y + 2))
	potential_possibilities.append(Vector2(cell_index.x + 2, cell_index.y + 1))
	potential_possibilities.append(Vector2(cell_index.x - 1, cell_index.y + 2))
	potential_possibilities.append(Vector2(cell_index.x - 2, cell_index.y + 1))
	potential_possibilities.append(Vector2(cell_index.x - 2, cell_index.y - 1))
	potential_possibilities.append(Vector2(cell_index.x - 1, cell_index.y - 2))
	
	for poss in potential_possibilities:
		if is_valid(poss):
			possibilities.append(poss)

	for i in possibilities:
		tilemap.set_cell(i.x, i.y, 65)
	if possibilities.size() == 0:
		print("Game Over!")
		emit_signal("game_over", false)














