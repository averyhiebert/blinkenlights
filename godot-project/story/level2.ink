
=== second_chamber ===

-> the_bridge



=== the_bridge ===
You are on the bridge of a sinking cargo ship.  Alarms are blaring.
The only person in sight is the Captain, who is struggling with some sort of control console.
+ [Talk to the Captain]
+ [To Hallway]




=== captain ===
* ->
    No time to talk! I need your help.
    - (captain_ask)
    ** [What do you need?]
    ** [Why me?]
        Do you see anyone else on this godforsaken ship?
        *** [No.]
        ---
        Then it'll have to be you.  Unless you'd rather drown?
        *** [Of course not.]
        *** [Maybe.  This is just a simulation, isn't it?]
            You need to stop believing everything some asshole in a lab coat tells you.
        ---
    --
-

= wrong_answer
pass
-> END