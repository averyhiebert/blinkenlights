
=== start ===
# CLEAR
Thank you for your interest in our study.
We will be observing your behaviour within The Labyrinth, a perfectly safe, digitally-simulated environment.
This experiment will gather valuable information about human behaviour.
Do you consent to participate in this experiment?
 * [I will participate.]
    Excellent.
 * [I will not participate.]
    There has been a misunderstanding. You [i]will[/i] participate.
    We are merely asking for your informed consent, as required for ethics board approval.
    ** [I consent.]
        Excellent.
    ** [I do not consent.]
        Understandable.
        Please blink to indicate when you have changed your mind.
        -> blink_continue ->
        Thank you for your cooperation.
-
-> continue ->
~temp blink_count = 0
- (sync1)
We must begin the syncing procedure.
Please blink twice in a row.
 * {blink_count == 2} ->
    # CLEAR
    ~blink_count = 0
 + {blink_count < 2}[{BLINK}]
    ~blink_count += 1
    // TODO Add a timer or something, so we only accept 3 blinks in rapid concession.
    -> sync1
 + {blink_count < 2}[{timer(1)}]
    // Reset blink count
    ~blink_count = 0
    -> sync1
- (sync2)
Please blink 3 times in a row.
 * {blink_count == 3} ->
    # CLEAR
 + {blink_count < 3}[{BLINK}]
    ~blink_count += 1
    -> sync2
 + {blink_count < 3}[{timer(1.5)}]
    // Reset blink count
    ~blink_count = 0
    -> sync2
- (intro_close_eyes)
Please close your eyes for 5 seconds.
// TODO Timer
+ [{BLINK}]
    Please close your eyes for 5 seconds.
    ++ [{UNBLINK}]
        -> intro_close_eyes
    ++ [{timer(4.5)}]
        -> sync_done
- (sync_done)
TODO Major background change/some sort of swirly vortex shader thing.
SYNC COMPLETE
+ [Enter the labyrinth...]
    -> first_chamber

=== first_chamber ===
-> garden

VAR path_NS = true
= garden
You find yourself in a{~ strange| beautiful| forgotten|n ancient| tranquil} garden.
A {~cobblestone|marble|tiled} path runs from {path_NS:north to south|east to west}, lined with {~lillies|tulips|roses|stone lanterns|mossy stones|human skulls|poplar trees|cyprus trees}.
+ [{BLINK}]
    ~path_NS = not path_NS
    -> garden
+ {path_NS}[North]
  -> garden_north
+ {path_NS}[South]
  -> garden_south
+ {not path_NS}[East]
  -> garden_east
+ {not path_NS}[West]
  -> garden_west

VAR portcullis_raised = false
= garden_north
You stand before an imposing wall covered with {~flowing calligraphy in a forgotten script|the scars of a thousand forgotten battles|thick ivy choking the already-dead stones}.
The only exit is a massive gate with a heavy iron portcullis.  The portcullis is {portcullis_raised: now in the raised position, offering free passage| firmly shut}.
+ [{BLINK}]
    -> garden_north
+ [Go back]
    -> garden
+ {portcullis_raised}[Exit via portcullis]
    -> level1_debrief

LIST water_temp = cold, (normal), hot
= garden_south
You stand before a giant marble basin.
{water_temp:
 - hot:
    A copious amount of steam rises continuously from the near-boiling water.
 - cold:
    The surface of the water is frozen solid, at least an inch thick.
 - normal:
    The surface of the water shimmers, disturbed by water-walking insects.
}
{inventory !? golden_key:You see a golden key glinting at the bottom of the basin.}
// contains golden key
+ [{BLINK}]
    ~random_switch(water_temp)
    -> garden_south
+ {inventory !? golden_key} [Try to grab the key]
    {water_temp:
    - hot:
        {player_status ? scalded_hand:
            You know better than to reach into the scalding water again.
        - else:
            You immediately yank your hand back as it touches the scalding water.
            Your hand is now visibly burned.
            ~player_status += scalded_hand
        }
        -> continue -> garden_south
    - cold:
        The ice is too thick to break.
        -> continue -> garden_south
    - normal:
        You easily reach into the water and grab the golden key.
        ~inventory += golden_key
        -> continue -> garden_south
    }
+ [Go back]
    -> garden

= garden_east
You see a sprawling banyan tree casting shade over a wide area.
+ [Go back]
    -> garden
// Maybe a bonus "secret"/warning for the player? A la portal?

LIST door_type = (golden),oaken,iron
VAR west_door_locked = true
= garden_west
You see a small house-like building with an elaborate conical roof.
The {door_type} door is {west_door_locked:locked|unlocked}.
+ [{BLINK}]
    ~random_switch(door_type)
    -> garden_west
+ {inventory ? golden_key}{west_door_locked}[Try the key in the door]
    {door_type == golden:
        The golden key unlocks the golden door easily.
        ~west_door_locked = false
    -else:
        The key does not fit whatsoever.
    }
    -> continue -> garden_west
+ {not west_door_locked}[Go inside]
    {door_type:
    - golden:
        -> treasure_room
    - oaken:
        -> lever_room
    - iron:
        -> dungeon
    }
+ [East]
    -> garden

VAR treasure_room_empty = false
= treasure_room
{The golden door opens into|You are once again in} a room filled with treasure - elaborate rugs, porcelain vases, silken garments, and more.
* [Pocket something valuable]
    You grab a platinum pocket-watch.
    ~inventory += pocket_watch
    -> continue -> treasure_room
+ [Exit] -> garden_west

= lever_room
{The oaken door leads to|You are in} a room filled with machinery and tools.
There is a prominent lever on the wall, in the {portcullis_raised:up|down} position.
+ [Flip the lever]
    The rusty lever reluctantly slides into the other position.
    ~portcullis_raised = !portcullis_raised
    -> continue -> lever_room
+ [Exit] -> garden_west

= dungeon
{The iron door creaks open, revealing|You once again find yourself inside} a damp, unlit, mostly empty room.  You see only a cot and some rusty chains attached to a ring in the wall.
+ [Exit] -> garden_west


=== level1_debrief
FIRST CHAMBER COMPLETE
Tell us, what did you see in the first chamber?


