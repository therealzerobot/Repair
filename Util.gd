extends Node

onready var Block = preload("res://Block.tscn");

func build_block(cells,w,h):
	var b = Block.instance();
	b.init(cells,w,h);
	return b;

func build_l4():
	return build_block([[[1,0],[1,0],[1,2],[1,3]],
	[[0,1],[1,1],[2,1],[3,1]]],4,4)

func build_s():
	var b = build_block([[[1,0],[2,0],[0,1],[1,1]]],3,3)
	b.w = 3;
	b.h = 3;
	return b;
	
func build_t():
	var b = build_block([[[1,0],[0,1],[1,1],[2,1]]],3,3);
	b.w = 3;
	b.h = 3;
	return b;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
