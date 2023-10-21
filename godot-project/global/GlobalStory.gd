# Global story loader to persist story across multiple scenes, if necessary.
extends Node

var InkPlayer = load("res://addons/inkgd/ink_player.gd")
onready var _ink_player = InkPlayer.new()

# For communicating readiness to other scenes:
var player_ready = false # true if player is ready to be used
signal player_loaded     # Emitted when player is first loaded

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(_ink_player)

	_ink_player.ink_file = load("res://story/main.ink.json")

	_ink_player.loads_in_background = true
	_ink_player.connect("loaded", self, "_story_loaded")
	_ink_player.create_story() # will emit "loaded"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _story_loaded(successfully: bool):
	if !successfully:
		# TODO Error handling?
		return
	player_ready = true
	print("Story loaded successfully.")
	emit_signal("player_loaded")

	# Note: no observing/binding, we'll do that in the non-global calling code.
	# Similarly, no continue_story here.
