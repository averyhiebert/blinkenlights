# warning-ignore-all:return_value_discarded

extends Node2D

var _ink_player = null
onready var text_target:RichTextLabel = $CanvasLayer/VBoxContainer/RichTextLabel

var blink_index = -1 # Which index is the "blink" option?

func _ready():
	text_target.clear()
	text_target.connect("meta_clicked", self, "_select_choice")
	
	EyeTracker.connect("blink_down",self,"_on_blink")
	
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
			else:
				# (note: I adopt the convention that (( )) means a text-mode-only option
				text_target.append_bbcode("\n[center][url=%d]%s[/url][/center]\n" % [index, choice])
				#text_target.append_bbcode("[url=%d]%s[/url]\n\n" % [index, choice])
			index += 1

func _on_blink():
	if blink_index >= 0:
		_select_choice(blink_index)

func _ended():
	print("The End")


func _select_choice(index):
	# Note: clear after each choice, to fit with blink theme
	text_target.clear()
	blink_index = -1
	
	_ink_player.choose_choice_index(int(index))
	_ink_player.continue_story()
