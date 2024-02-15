extends Node2D


var following = null;
var offset = Vector2(-40, 0)
onready var locked_position = global_position;

func _process(delta):
	if following:
		if following.is_in_group("door"):
			global_position += (following.global_position - global_position)/20;
		elif following.item == self:
			global_position += (following.global_position - global_position + offset)/50;
			
			if following.get_node("Rotatable").scale.x == -1:
				offset = Vector2(40, 0)
			elif following.get_node("Rotatable").scale.x == 1:
				offset = Vector2(-40, 0)
		else:
			locked_position = following.global_position;
			following = null;
	else:
		global_position += (locked_position - global_position)/30;


func _on_Area2D_body_entered(body):
	if body.name == "player" and following == null:
		following = body
		body.item = self;

func disappear():
	$Key/AnimationPlayer.play("disappear")


func _on_AnimationPlayer_animation_finished(anim_name):
	following.item = null;
	queue_free()
