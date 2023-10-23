extends Node2D

var current_track = "silence"
const FADE_TIME = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play(track):
	var audio = get_node(current_track)
	if audio:
		audio.playing = true
	else:
		print("Can't load audio for some reason")

func fade_out(duration):
	print("Fading out")
	var audio = get_node(current_track)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(audio, "volume_db",
		audio.volume_db, -60, duration,
		Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()

func fade_to(target_track):
	if target_track == current_track:
		return
	if not (target_track in ["level1","level2","level3","level4","portal_idle","silence","main_menu"]):
		return
	# Fade to the given music.
	var old_player = get_node(current_track)
	var new_player = get_node(target_track)
	current_track = target_track
	
	#old_player.playing = false
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(old_player, "volume_db",
		0, -60, FADE_TIME,
		Tween.TRANS_EXPO, Tween.EASE_IN)
	if target_track != "silence":
		new_player.playing = true
		tween.interpolate_property(new_player, "volume_db",
			-50,0, FADE_TIME,
			Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
