extends Node

signal blink_down
signal blink_up
signal left_eye_down
signal left_eye_up
signal right_eye_down
signal right_eye_up

var bd_cb = JavaScript.create_callback(self, "_blink_down")
var bu_cb = JavaScript.create_callback(self, "_blink_up")
var ld_cb = JavaScript.create_callback(self, "_left_eye_down")
var lu_cb = JavaScript.create_callback(self, "_left_eye_up")
var rd_cb = JavaScript.create_callback(self, "_right_eye_down")
var ru_cb = JavaScript.create_callback(self, "_right_eye_up")

# Variables for fake non-JS blinking
var spacebar_blink = true # Actually, let's have this always be enabled
var fake_eyes_open = true

var eyes_open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up all API calls for the JS frontend to communicate with Godot
	#var console = JavaScript.get_interface("console")
	#console.log("eye tracker loaded?");
	if OS.has_feature('JavaScript'):
		var window = JavaScript.get_interface("window")
		window.blinkDown = bd_cb
		window.blinkUp = bu_cb
		window.leftEyeDown = ld_cb
		window.leftEyeUp = lu_cb
		window.rightEyeDown = rd_cb
		window.rightEyeUp = ru_cb
	else:
		print("Javascript not available. Using space to blink.")
		spacebar_blink = true

func _process(delta):
	if Input.is_action_pressed("blink") and fake_eyes_open:
		fake_eyes_open = false
		_blink_down(null)
	elif not Input.is_action_pressed("blink") and not fake_eyes_open:
		fake_eyes_open = true
		_blink_up(null)


func _blink_down(args):
	eyes_open = false
	emit_signal("blink_down")
	
func _blink_up(args):
	eyes_open = true
	emit_signal("blink_up")

func _left_eye_down(args):
	emit_signal("left_eye_down")
	
func _left_eye_up(args):
	emit_signal("left_eye_up")
	
func _right_eye_down(args):
	emit_signal("right_eye_down")

func _right_eye_up(args):
	emit_signal("right_eye_up")
