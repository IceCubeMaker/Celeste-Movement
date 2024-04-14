extends Node2D

export var second_text : String = "";

func _on_Area2D_body_entered(body):
	if body.name == "player":
		$Text/AnimationPlayer.play("ShowText");
		#$"../AudioStreamPlayer".play()


func _on_Area2D_body_exited(body):
	if body.name == "player":
		$Text/AnimationPlayer.play("RemoveText")
		#$"../AudioStreamPlayer2".play()

func _on_Pedastol_puzzle_solved():
	$Text/Label.text = second_text;
