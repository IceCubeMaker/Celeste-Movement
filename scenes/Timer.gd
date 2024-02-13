extends Label


var time = 0;


func _on_Timer_timeout():
	time += 0.1;
	text = str(time)


func _on_Area2D_body_entered(body):
	if body == $"..":
		$Timer.stop()
