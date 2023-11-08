extends Particles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Really, the story should 100% always be loaded by now,
	#  but I'll include this check just in case
	if GlobalStory.player_ready:
		check_pause(true)
	else:
		GlobalStory.connect("player_loaded",self,"check_pause")


func check_pause(successfully: bool):
	if not successfully:
		return
	
	if not GlobalStory._ink_player.get_variable("BG_ANIMATION"):
		# Background animations have been turned off by player
		# So LERP speed scale to 0, for smooth transition + final stationary background
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(self, "speed_scale",
			speed_scale, 0, 2,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
