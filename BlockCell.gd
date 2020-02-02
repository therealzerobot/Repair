extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var textures = [load("res://textures/Puzzle_Tile_1x1_inch_-_Yellow.png"),
				load("res://textures/Puzzle_Tile_1x1_inch_-_Yellowish.png"),
				load("res://textures/Puzzle_Tile_1x1_inch-_blue.png")];

# Called when the node enters the scene tree for the first time.
func _ready():
	set_normal_texture(textures[randi() % textures.size()]);
	pass # Replace with function body.
	

func change_texture():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
