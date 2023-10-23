extends CanvasLayer

var scene_dict = {
	"rain": preload("res://backgrounds/rain.tscn"),
	"vortex": preload("res://backgrounds/vortex.tscn"),
	"leaves": preload("res://backgrounds/leaves.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_scene(name):
	if name in scene_dict:
		var current_child = get_child(0)
		add_child(scene_dict[name].instance())
		if current_child:
			current_child.queue_free()
