extends CanvasLayer

var scene_dict = {
	"rain": preload("res://backgrounds/rain.tscn"),
	"vortex": preload("res://backgrounds/vortex.tscn"),
	"leaves": preload("res://backgrounds/leaves.tscn"),
	"plain": preload("res://backgrounds/plain.tscn"),
	"dark": preload("res://backgrounds/dark.tscn"),
	"cave": preload("res://backgrounds/cave.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_scene(name):
	if name in scene_dict:
		for child in get_children():
			child.free()
		add_child(scene_dict[name].instance())
