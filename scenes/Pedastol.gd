extends Sprite

signal puzzle_solved

export var item_name = "";
var item = null;

func _process(delta):
	if item != null:
		item.following = self;

func _on_Area2D_body_entered(body):
	if body != null:  # Check if the body object is valid
		print(body.name)
		if body.name == "player":
			if body.item != null:
				if body.item.name == item_name:
					var item = body.item
					body.item.puzzle_solved = true;
					body.item = null
					item.following = self
					emit_signal("puzzle_solved")
					# $"../AudioStreamPlayer".playing = true;
					# $"../AudioStreamPlayer".stream_paused = false;
	else:
		print("Invalid body object entered the area.")



func _on_AudioStreamPlayer_finished():
	pass
	#$"../AudioStreamPlayer".playing = false;
	#$"../AudioStreamPlayer".stream_paused = true;
