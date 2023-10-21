# Example

extends RichTextLabel

var _callback_ref = JavaScript.create_callback(self, "_my_callback")

# Called when the node enters the scene tree for the first time.
func _ready():
	# set up doGodotBlink() to be called from the JS
	EyeTracker.connect("blink_down",self,"_on_blink_down")
	EyeTracker.connect("blink_up",self,"_on_blink_up")
	EyeTracker.connect("left_eye_down",self,"_on_left_down")
	EyeTracker.connect("left_eye_up",self,"_on_left_up")
	EyeTracker.connect("right_eye_down",self,"_on_right_down")
	EyeTracker.connect("right_eye_up",self,"_on_right_up")
	append_bbcode("\nStarted")

func _on_blink_down():
	append_bbcode("\nBlinked Down")
	
func _on_blink_up():
	append_bbcode("\nBlinked Up")
	
func _on_left_down():
	append_bbcode("\nLeft Down")
	
func _on_left_up():
	append_bbcode("\nLeft Up")
	
func _on_right_down():
	append_bbcode("\nRight Down")
	
func _on_right_up():
	append_bbcode("\nRight Up")
