extends Node2D



func _on_Area2D_body_entered(body):
	if body.name == "player":
		$Text/AnimationPlayer.play("ShowText");
		#$"../AudioStreamPlayer".play()


func _on_Area2D_body_exited(body):
	if body.name == "player":
		$Text/AnimationPlayer.play("RemoveText")
		#$"../AudioStreamPlayer2".play()
