extends StaticBody2D

var item = null


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "player":
		if body.item:
			if is_instance_valid(body.item):
				if body.item.is_in_group("key"):
					body.item.disappear();
					$AnimatedSprite.playing = true;
					body.item.following = self;
					item = body.item;
