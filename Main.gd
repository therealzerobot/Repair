extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var folder_texts = ["RoboCopt","Pyramid Head Scheme","The Doner Party","Rosetta Stoner","Swole Miner's Daughter"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var x=0 
	for text in folder_texts:
		var icon=Util.build_FolderIcon(text)
		icon.set_position(Vector2(x,0))
		x=x+85
		$"Folder Area".add_child(icon)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
