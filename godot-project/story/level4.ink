CONST GORGON_WARNING_TIME = 3 // How much warning before eyes MUST be closed?
CONST GORGON_DANGER_TIME = 5  // How long does the gorgon stay in view?

LIST gorgon_location = (_cave2), _cave_left, _cave_right, _cave_forest
VAR gorgon_passed = false
=== fourth_chamber ===
~gorgon_location = LIST_RANDOM(LIST_ALL(gorgon_location))
-> cave_entrance

=== cave_entrance ===

You arrive at the entrance to a vast cavern.
Your local guide stops just outside.
"You will find what you seek in there."
- (first_convo)
* [And what do I seek?]
    "You would know better than I.  But I assure you, if you seek it, you will find it here."
    -> first_convo
+ [Let's enter, then.]
+ [Won't you lead me the rest of the way?]
-
"This is as far as I dare take you.  No treasure is worth the risk of encountering the Gorgon."
+ [What is the Gorgon?]
    "To gaze upon it is a curse of the highest order.
+ [I do not fear the Gorgon.]
    "Then you are a fool.
    To see the Gorgon is a curse of the highest order.
-
If you hear it approaching, SHUT YOUR EYES until it has passed."
+ [I don't believe in such superstitions.]
    "What do you believe in? Do you trust your own eyes?"
    ++ [Yes.]
        "Your eyes have deceived you before, and they will again."
    ++ [No.]
        "Then perhaps nothing can be trusted."
+ [I'm safe here.  This is just a simulation.]
    "Others before you have said this.  I don't know what it means.
    Some of them saw the Gorgon and have never opened their eyes since."
-
+ [Ok]
-
"Once again, I warn you:
When you hear the Gorgon approaching, SHUT YOUR EYES."
+ [I will.]
+ [If you say so...]
-
The guide leaves you alone at the cavern entrance.
+ [Enter the cavern]
  -> cave1

= cave1
You are in a dark, narrow tunnel.  The light of your {~lantern|candle|flashlight} flickers feebly.
+ [{BLINK}] -> cave1
+ [Go deeper]
-
-> cave2

= cave2
The cave opens out into a wider chamber here.
{~Dagger-like stalactites|Gnarled, ancient roots|Dozens of sleeping bats} hang from the ceiling.
Long, winding tunnels stretch away to the left and right.
<- gorgon_options(_cave2,-> cave2)
{has_gorgon(_cave2): -> DONE}
+ [{BLINK}] -> cave2
+ [Left]
  -> cave_left
+ [Right]
  -> cave_right

= cave_left
In this chamber, a pool of still water reflects the nothingness of the cave.
<- gorgon_options(_cave_left, -> cave_left)
{has_gorgon(_cave_left): -> DONE}
+ [Go deeper]
    -> cave_forest
+ [Go back]
    -> cave2


= cave_right
The ground in here is covered with {~bones|sharp stones|bat guano}.
<- gorgon_options(_cave_right, -> cave_right)
{has_gorgon(_cave_right): -> DONE}
+ [{BLINK}]
    -> cave_right
+ [Go deeper]
    -> cave_key
+ [Go back]
    -> cave2

= cave_key
You find yourself at a dead end.
{inventory !? iron_key:There is a large iron key lying on the floor.}
You also see an inscription scratched into one of the cave walls.
+ [{BLINK}]
    -> cave_key_closed
+ [Read the inscription]
    "EYES = LIES!
    Close your eyes to open your mind!"
    The inscription appears to have been left recently.
    -> continue -> cave_key
+ {inventory !? iron_key}[Grab the key]
    You pick up the iron key.
    ~inventory += iron_key
    -> continue -> cave_key
+ [Go back]
    -> cave_right

= cave_key_closed
You find yourself at a dead end.
{inventory !? iron_key:There is a large iron key lying on the floor.}
You also see an inscription scratched into one of the cave walls.
+ [Secret Passage]
    -> secret_room
+ [{UNBLINK}]
    -> cave_key

= cave_forest
In this area of the cave you can barely move due to a dense forest of {~massive stalagmites|giant mushrooms|giant salt crystals}.
<- gorgon_options(_cave_forest, -> cave_forest)
{has_gorgon(_cave_forest): -> DONE}
+ [{BLINK}]
    -> cave_forest
+ [Go deeper]
    -> cave_final
+ [Go back]
    -> cave_left

= cave_final
You finally arrive at the end of the tunnel.
You see a crumbling wooden door inset deeply into the cavern wall.
+ [Exit via the door]
    {inventory !? iron_key:
        The door is locked.
        -> continue -> cave_final
    - else:
        The iron key you found fits the door perfectly.
        -> continue -> level4_debrief
    }
+ [Go back]
    -> cave_forest

= secret_room
You find yourself in a tiny chamber containing a sleeping bag, some canned food, and other items scattered around haphazardly.
Someone was living here recently, although they seem to have left in a hurry.
They left behind a notebook.
+ [Notebook]
    TODO Part of finale/ interstitial story
    WRITE CONTENT FOR NOTEBOOK
    -> continue -> secret_room
+ [Go back]
    -> cave_key

// True if cave does not have gorgon currently
=== function has_gorgon(cave_id) ===
~return (cave_id == gorgon_location) and (not gorgon_passed)

=== gorgon_options(cave_id, -> which_cave)
{not has_gorgon(cave_id):->DONE}
You hear the gorgon approaching!!!!! # AUDIO: monster
+ [{timer(GORGON_WARNING_TIME)}]
-
TODO Scary visual effect
THE GORGON IS A TERRIBLE SITE TO BEHOLD
YOU IMMEDIATELY REGRET THIS
+ [{timer(GORGON_DANGER_TIME)}]
    //~gorgon_passed = true
    ~random_switch(gorgon_location)
    The gorgon has gone, although its stench still lingers.
    -> continue -> which_cave
+ [{EYES_OPEN}]
+ [{UNBLINK}]
-
THE GORGON IS A TERRIBLE SITE TO BEHOLD
YOU IMMEDIATELY REGRET THIS
-> blink_continue -> gorgon_bad_ending

=== gorgon_bad_ending
FOURTH CHAMBER COMPLETE
+ [{timer(1)}]
-
ERROR
UNSTABLE EVENT
RE-ENTERING CHAMBER
TODO story here.

=== level4_debrief
FOURTH CHAMBER COMPLETE
TODO interstitial




