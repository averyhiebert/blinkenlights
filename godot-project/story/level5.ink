=== fifth_chamber ===
# AUDIOLOOP: silence
# BG: dark
-> top
= top
You are at one end of a hallway in what appears to be an abandoned art gallery.<br>
-> statue_progress ->
+ [{BLINK}]
    -> top




= statue_progress
* ->
    A faceless statue stands at the far end of the hallway.
* ->
    A faceless statue stands near the far end of the hallway.
* ->
    The faceless statue is now close to the middle of the hallway.
* ->
    The faceless statue is now only a few metres away.
* ->
    The featureless face of the statue stares directly into your eyes, mere inches from your face.
* -> 
    TODO Specific jumpscare image.
    # CLEAR
    # AUDIO: horrid_sight
    -> death("FIFTH")
-
->->

=== death(chamber_str) ===
-> enter_portal ->
ADVERSE EVENT DETECTED
{chamber_str} CHAMBER ABORTED
+ [{BLINK}]
+ [{timer(1)}]
-
# BG: dark
# AUDIOLOOP: silence
# AUDIO: horrid_sight
ERROR
UNSTABLE EVENT
RE-ENTERING CHAMBER
+ [{BLINK}]
+ [{timer(1)}]
-
TODO Something visually scary
-> enter_portal ->
ADXERSX EVENX DETXCTEDX
KERNEL PANIC
+ [{BLINK}]
+ [{timer(1)}]
-
# AUDIOLOOP: silence
# BG: dark
# AUDIO: horrid_sight
You are violently thrust back into the real world, traumatized by whatever it is you just saw.
You resolve never to open your eyes again.
+ [{BLINK}]
-
+ [{timer(5)}]
-
+ [...try again?]
    # RESTART
    Restarting...
    -> DONE

