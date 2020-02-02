extends Node2D

var BlockCell = preload("res://BlockCell.tscn");

signal clicked(source);

var configs = [[[1,0],[1,1],[1,2],[1,3]],
			   [[0,1],[1,1],[2,1],[3,1]]];
var config_i = 0;

var w = 4;
var h = 4;

var vcellw = 72;
var vcellh = 72;

var buttons = [];

func init(init_cells,iw,ih):
	w = iw;
	h = ih;
	if(init_cells.size() == 1):
		for i in range(3):
			var last = init_cells[init_cells.size() - 1];
			var newset = [];
			for p in last:
				var x = p[0]-w/2;
				var y = p[1]-h/2;
				var xx = -y + w/2;
				var yy = x + h/2;
				newset.append([xx,yy]);
			init_cells.append(newset);
	configs = init_cells;
	reset_blocks();
	
func clear_buttons():
	for b in buttons:
		remove_child(b);
		b.queue_free();
	buttons = [];
# Called when the node enters the scene tree for the first time.

func reset_blocks():
	clear_buttons();
	for c in configs[config_i % configs.size()]:
		var x = c[0]
		var y = c[1]
		var bc = BlockCell.instance();
		bc.set_position(Vector2(vcellw*x,vcellh*y));
		bc.connect("pressed",self,"_child_clicked");
		add_child(bc);
		buttons.append(bc);
	pass

func _ready():
	reset_blocks(); # Replace with function body.
	
func _child_clicked():
	print("Click")
	emit_signal("clicked",self);

func rotate_right():
	config_i = config_i + 1;
	reset_blocks();
	
func get_bounds_rect(fromx=0, fromy=0):
	var minx = INF;
	var miny = INF;
	var maxx = -INF;
	var maxy = -INF;
	
	for b in buttons:
		var p = b.get_position();
		var x = p.x;
		var y = p.y;
		var r = p.x + 72;
		var l = p.y + 72;
		
		if x < minx:
			minx = x;
		if r > maxx:
			maxx = r;
		if y < miny:
			miny = y;
		if l > maxy:
			maxy = l;
			
	return Rect2(Vector2(fromx+minx,fromy+miny),
				 Vector2(fromx+maxx,fromy+maxy));
				
func get_integral_cells(ofx=0, ofy=0):
	var out = [];
	for c in configs[config_i % configs.size()]:
		out.append([c[0]+ofx, c[1]+ofy]);
	return out;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
