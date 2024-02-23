extends Node

export(NodePath) var cameraPath

var scrHeight;
var calculatedOffset : float;

func _ready():
	scrHeight = ProjectSettings.get_setting("display/window/size/height");

func _process(delta):
	var camZoom = get_node(cameraPath).zoom.y;
	
	calculatedOffset = (-get_node(cameraPath).position.y/(scrHeight) + self.position.y/scrHeight) * 2 / camZoom;
	
	self.material.set_shader_param("calculatedOffset", calculatedOffset);
