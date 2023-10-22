# warning-ignore-all:return_value_discarded

extends Node2D

var _ink_player = null
onready var text_target:RichTextLabel = $CanvasLayer/Panel/VBoxContainer/RichTextLabel

var blink_index = -1 # Which index is the "blink" option?
var unblink_index = -1 # Which index is the "unblink" option?

var timer_index = -1
var choice_timer = null;

func _ready():
	text_target.clear()
	text_target.connect("meta_clicked", self, "_select_choice")
	
	EyeTracker.connect("blink_down",self,"_on_blink_down")
	EyeTracker.connect("blink_up",self,"_on_blink_up")
	
	if GlobalStory.player_ready:
		_story_loaded()
	else:
		GlobalStory.connect("player_loaded",self,"_story_loaded")

# ############################################################################ #
# Signal Receivers
# ############################################################################ #

func _story_loaded():
	_ink_player = GlobalStory._ink_player
	_ink_player.connect("continued", self, "_continued")
	_ink_player.connect("prompt_choices", self, "_prompt_choices")
	_ink_player.connect("ended", self, "_ended")
	
	# Set up observers and bind external functions, if desired
	
	# Continue story
	_ink_player.continue_story()


func _continued(text, tags):
	if "CLEAR" in tags:
		# Clear before next line.
		text_target.clear()
	for tag in tags:
		if tag.begins_with("AUDIO:"):
			var sound_name = tag.split(" ")[1]
			play_sound(sound_name)
		elif tag.begins_with("AUDIOLOOP:"):
			var track_name = tag.split(" ")[1]
			$music.fade_to(track_name)
	
	text_target.append_bbcode(text)
	
	_ink_player.continue_story()


# ############################################################################ #
# Private Methods
# ############################################################################ #

func _prompt_choices(choices):
	if !choices.empty():
		var index = 0
		for choice in choices:
			if choice == "BLINK":
				blink_index = index
			elif choice == "UNBLINK":
				unblink_index = index
			elif choice == "EYES_OPEN":
				if EyeTracker.eyes_open:
					# Choice is automatically chosen if eyes are already open
					_select_choice(index)
			elif choice.begins_with("TIMER"):
				timer_index = index
				var time = int(choice.split(" ")[1])
				choice_timer = Timer.new()
				choice_timer.one_shot = true
				choice_timer.wait_time = time
				choice_timer.connect("timeout",self,"_on_timer")
				add_child(choice_timer)
				choice_timer.start()
			else:
				# (note: I adopt the convention that (( )) means a text-mode-only option
				text_target.append_bbcode("\n[center][url=%d]%s[/url][/center]\n" % [index, choice])
				#text_target.append_bbcode("[url=%d]%s[/url]\n\n" % [index, choice])
			index += 1

func _on_blink_down():
	if blink_index >= 0:
		_select_choice(blink_index)

func _on_blink_up():
	if unblink_index >= 0:
		_select_choice(unblink_index)

func _on_timer():
	print("timer happened")
	if timer_index >= 0:
		_select_choice(timer_index)

func _ended():
	print("The End")


func _select_choice(index):
	# Note: clear after each choice, to fit with blink theme
	text_target.clear()
	# Reset any blinks:
	blink_index = -1
	unblink_index = -1
	
	# Remove timer if necessary
	timer_index = -1
	if choice_timer:
		choice_timer.queue_free()
		choice_timer = null
	
	_ink_player.choose_choice_index(int(index))
	_ink_player.continue_story()

func play_sound(sound_name):
	var audio_player = get_node("SFX/%s" % sound_name)
	if audio_player:
		audio_player.play()
