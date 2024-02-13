extends Sprite

var amplitude := 5.0
var time = 0;
var frequency := 1.0

onready var default_pos = get_position()

func _process(delta : float) -> void:
	time += delta * frequency * 3.5
	set_position(default_pos + Vector2(0, sin(time) * amplitude))
