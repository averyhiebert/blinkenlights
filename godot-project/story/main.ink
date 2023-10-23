INCLUDE experimental.ink
INCLUDE prologue.ink
INCLUDE utils.ink
INCLUDE player.ink

INCLUDE level1.ink
INCLUDE level2.ink
INCLUDE level3.ink
INCLUDE level4.ink
INCLUDE level5.ink
INCLUDE debrief_questions.ink
INCLUDE menu.ink







VAR DEBUG = false

{DEBUG:
    ~found_secret = true
    -> third_chamber
    -> fourth_chamber
    -> cave_entrance.cave1
    -> level4_debrief
}


-> main_menu

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