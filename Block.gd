extends Node2D

onready var BlockCell = preload("res://BlockCell.tscn");

var cells = [[1,0],[1,1],[1,2],[1,3]];
var w = 4;
var h = 4;

var vcellw = 72;
var vcellh = 72;

var buttons = [];

func init(init_cells):
	cells = init_cells;

func clear_buttons():
	for b in buttons:
		remove_child(b);
		b.queue_free();
	buttons = [];
# Called when the node enters the scene tree for the first time.
func _ready():
	clear_buttons();
	for c in cells:
		var x = c[0]
		var y = c[1]
		print("adding at ", x, y);
		var bc = BlockCell.instance();
		bc.set_position(Vector2(vcellw*x,vcellh*y));
		bc.connect("pressed",self,"_child_clicked");
		add_child(bc);
		buttons.append(bc);
	pass # Replace with function body.
	
func _child_clicked():
	print("Click")
	rotate_right();

func rotate_right():
	clear_buttons();
	var new_cells = [];
	for c in cells:
		var x = c[0]-w/2;
		var y = c[1]-h/2;
		var xp = y+w/2;
		var yp = x+h/2;
		var bc = BlockCell.instance();
		bc.set_position(Vector2(vcellw*xp,vcellh*yp));
		bc.connect("pressed",self,"_child_clicked");
		add_child(bc);
		buttons.append(bc);
		new_cells.append([xp,yp]);
	cells = new_cells;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
