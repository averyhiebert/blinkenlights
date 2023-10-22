
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
    -> debrief

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


= debrief
FIRST CHAMBER COMPLETE
Tell us, what happened in the first chamber?
+ [I was in a garden]
    Of course. Obviously.
- (garden_updates)
What {|else} to you remember about the garden?
<- garden_questions
<- debrief_questions(-> garden_updates, -> second_chamber)
-> DONE

= garden_questions
* {garden_east}[There was a large banyan tree.]
    Interesting.
* {dungeon}[I think I found some sort of prison cell?]
    What makes you say that?
    ** [It had an iron door and chains on the walls.]
        I think you might be overthinking this.
    ** [On second thought, never mind.]
* {treasure_room}[I found some sort of treasure-room.]
    Did you take anything from it?
    ~temp lied = false
    ** [Yes.]
        ~lied = (inventory !? pocket_watch)
    ** [No.]
        ~lied = (inventory ? pocket_watch)
    --
    {lied:
        Please do not lie to us.  This is a scientific experiment.
    - else:
        Interesting.
    }
- -> garden_updates






