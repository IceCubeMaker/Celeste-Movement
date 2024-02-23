extends Sprite

signal puzzle_solved

export var item_name = "";
var item = null;

func _on_Area2D_body_entered(body):
	print(body.name)
	if body.name == "player":
		if body.item:
			if body.item.name == item_name:
				item = body.item;
				body.item = null;
				item.following = self;
				emit_signal("puzzle_solved")
				$"../AudioStreamPlayer".playing = true;
				$"../AudioStreamPlayer".stream_paused = false;


func _on_AudioStreamPlayer_finished():
	$"../AudioStreamPlayer".playing = false;
	$"../AudioStreamPlayer".stream_paused = true;
