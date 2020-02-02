extends Node2D

var BlockTargetCell = load("BlockTargetCell.tscn");

signal game_solved();
signal game_quit();

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var solved = false;

var target_cells = [
	[1+4,0+3],
	[0+4,1+3],
	[1+4,1+3],
	[2+4,1+3]
]

var blocks = [];

const UP = Vector2(0,-72);
const DOWN = Vector2(0,72);
const LEFT = Vector2(-72,0);
const RIGHT = Vector2(72,0);
const NOSHIFT = Vector2(0,0);

var focused_block = null;

func init_target_dict():
	var d = {};
	for i in range(10):
		d[i] = {};
		for j in range(7):
			d[i][j] = false;
	return d;
	

func handle_target_cells():
	var d = init_target_dict();
	for tc in target_cells:
		d[tc[0]][tc[1]] = true;
	for x in range(10):
		for y in range(7):
			if(d[x][y]):
				var b = BlockTargetCell.instance();
				b.set_position(Vector2(x*72, y*72));
				$"PlayFieldBG".add_child(b);
				

func _block_clicked(the_block):
	if the_block == focused_block:
		pass
	else:
		focused_block = the_block;

func init_checked_dict():
	var d = {};
	for x in range(10):
		d[x] = {};
		for y in range(7):
			d[x][y] = 0;
	return d;
	
func add_solution_to_dict(d):
	for c in target_cells:
		d[c[0]][c[1]] = -1;
	return d;
	
func add_blocks_to_dict(d):
	for b in blocks:
		var p = b.get_position();
		for c in b.get_integral_cells(int(p.x/72), int(p.y/72)):
			var ix = c[0];
			var iy = c[1];
			d[ix][iy] = d[ix][iy] + 1;
	return d;
		
func check_dict(d):
	var sum = 0;
	for i in range(10):
		for j in range(7):
			sum = sum + abs(d[i][j]);
	print("Solution sum: ", sum);
	return sum == 0;

func check_solution():
	var d = init_checked_dict();
	d = add_solution_to_dict(d);
	d = add_blocks_to_dict(d);
	var r = check_dict(d);
	if r:
		$SuccessIndicator.text = "Success"
		solved = true;
		setup_success_tween();
	else:
		$SuccessIndicator.text = "Failure"

func connect_block(block):
	block.connect("clicked",self,"_block_clicked");
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello World")
	var pf = $PlayField;
	var otherBlock = Util.build_t();
	connect_block(otherBlock);
	pf.add_child(otherBlock);
	blocks.append(otherBlock);
	focused_block = otherBlock;
	handle_target_cells();
	pass # Replace with function body.

func _process_no_focus(delta):
	pass

func move_block(block, shift):
	var bp = block.get_position();
	block.set_position(bp+shift);
	var current_pos = block.get_position();	
	var current_bounds = block.get_bounds_rect(current_pos.x, current_pos.y);
	if(current_bounds.position.x<0):
		block.set_position(current_pos+Vector2(-current_bounds.position.x,0));
	if(current_bounds.position.y<0):
		block.set_position(current_pos+Vector2(0,-current_bounds.position.y));
	if(current_bounds.end.x - current_bounds.position.x > $PlayField.rect_size.x):
		var cbx = current_bounds.end.x;
		var ew = $PlayField.rect_size.x;
		block.set_position(current_pos - Vector2(72, 0));
	if(current_bounds.end.y - current_bounds.position.y > $PlayField.rect_size.y):
		var cby = current_bounds.end.y;
		var eh = $PlayField.rect_size.y;	
		block.set_position(current_pos - Vector2(0, 72));
		
func setup_success_tween():
	$SuccessTween.reset_all();
	$SuccessTween.set_active(true);
	$SuccessTween.interpolate_property($SuccessPlacard,"position",
		null,
		Vector2(252,261),1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,0);
	$SuccessTween.connect("tween_step",self,"_tween_step_debug");
	$SuccessTween.start();

func _tween_step_debug(o,n,e,k):
	print("Tween elapsed ", e);

func _process_success_anim(delta):
	print($SuccessPlacard.get_position());
	pass

func _process_focused(delta):
	var fbp = focused_block.get_position();
	var changed = false;
	
	var shift = NOSHIFT;
	if Input.is_action_just_pressed("tetris_right"):
		shift = RIGHT;
	if Input.is_action_just_pressed("tetris_left"):
		shift = LEFT;
	if Input.is_action_just_pressed("tetris_down"):
		shift = DOWN;
	if Input.is_action_just_pressed("tetris_up"):
		shift = UP;
	if Input.is_action_just_pressed("tetris_rotate"):
		changed = true;
		focused_block.rotate_right();
	move_block(focused_block,shift);
	if(shift != NOSHIFT or changed == true):
		check_solution();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if solved:
		_process_success_anim(delta);
		return;
	if focused_block:
		_process_focused(delta);
	else:
		_process_no_focus(delta);
