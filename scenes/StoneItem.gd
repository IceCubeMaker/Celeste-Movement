extends Node2D


var following = null;
var offset = Vector2(-40, 0)
onready var locked_position = global_position;

export var _name = "";
export var _sprite : Texture;
export var _sprite_size : float = 2;

func _ready():
	name = _name;
	$Key.texture = _sprite;
	$Key.scale.x = _sprite_size;
	$Key.scale.y = _sprite_size;

func _process(delta):
	if following:
		if following.item == self:
			global_position += (following.global_position - global_position + offset)/50;
			
			if following.name == "player":
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
