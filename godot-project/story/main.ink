INCLUDE experimental.ink
INCLUDE prologue.ink
INCLUDE utils.ink
INCLUDE player.ink

INCLUDE level1.ink
INCLUDE level2.ink
INCLUDE level3.ink
INCLUDE debrief_questions.ink
INCLUDE level4.ink






VAR DEBUG = false

{DEBUG:
    -> debug_scene
}


-> start

=== debug_scene ===
# AUDIOLOOP: level2
This is a debug screen
+ [{timer(5)}]
-
Music should change now
# AUDIOLOOP: level4
+ [{timer(5)}]
-
#AUDIOLOOP: silence
Now fading to silence
+ [{timer(5)}]
-
Now back to music
# AUDIOLOOP: level2
-> END