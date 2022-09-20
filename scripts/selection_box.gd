extends Control

var draw_box: bool = false
var mouse_pos: Vector2 = Vector2.ZERO
var start_pos: Vector2 = Vector2.ZERO
var line_colour: Color = Color.GREEN
var line_width: int = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.queue_redraw()
	
func _draw():
	if draw_box && start_pos != mouse_pos:
		draw_line(start_pos, Vector2(mouse_pos.x, start_pos.y), line_colour, line_width)
		draw_line(start_pos, Vector2(start_pos.x, mouse_pos.y), line_colour, line_width)
		draw_line(mouse_pos, Vector2(mouse_pos.x, start_pos.y), line_colour, line_width)
		draw_line(mouse_pos, Vector2(start_pos.x, mouse_pos.y), line_colour, line_width)
