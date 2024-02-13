extends Particles2D

var locked_position = Vector2.ZERO;

func _process(delta):
	global_position = locked_position;
