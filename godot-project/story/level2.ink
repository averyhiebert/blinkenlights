LIST water_level = (very_low), low, medium, high, sunk, resolved
=== second_chamber ===
# AUDIO: portal_jump
# AUDIOLOOP: level2
# BG: rain
~randomize_lights()
-> the_bridge


LIST colours = blue, green, red, orange, yellow, white
VAR lights_on = ()
=== function randomize_lights
    ~temp all_possible = LIST_ALL(colours)
    ~lights_on = ()
    ~lights_on += random_pop(all_possible)
    ~lights_on += random_pop(all_possible)
    ~lights_on += random_pop(all_possible)

=== blink_randomize_lights(-> next) ===
+ [{BLINK}]
    ~randomize_lights()
    -> next

    

=== the_bridge ===
{water_level:
-sunk:
    -> sinking
-resolved:
    -> survived
}
You are on the bridge of a sinking cargo ship.  Alarms are blaring.
The only person in sight is the Captain, who is {|still} struggling with some sort of control console.
<- blink_randomize_lights(->the_bridge)
+ [Talk to the Captain]
    -> talk_captain ->
    -> the_bridge
+ [To Hallway] -> hallway
+ [DEBUG show light sequence]
    // For debugging
    {lights_on}.  
    -> the_bridge

= hallway
The hallway is dark and narrow.  The only light source is {~a small porthole|a failing incandescent bulb|the glow of a red warning light}.
<- blink_randomize_lights(->hallway)
+ [To the bridge] -> the_bridge
+ [Down the ladder] -> engine_room


= engine_room
The engine room is filled with the scent of {water_level <= low:diesel|seawater and diesel}.
{water_level:
- very_low:
    The floor is covered in an inch or two of salt water, seeping in from somewhere below.
- low:
    The ship is taking on water rapidly; it's up to your knees already.
- medium:
    The water is now waste-high, and it's getting difficult to walk in here.
- high:
    You are submerged in icy water up to your chest.
}
<- blink_randomize_lights(->engine_room)
+ [Up the ladder] -> hallway
+ [Check indicator panel] -> indicator_panel

= indicator_panel
The {listWithCommas(lights_on,"")} lights are on.
<- blink_randomize_lights(->indicator_panel)
+ [Ok.] -> engine_room

= sinking
"You idiot! You've doomed us both!"
The ship suddenly tilts, and both you and the captain are dumped into the hallway, which is already filled with water.
-> continue ->
Cold water covers your head and the mammalian dive reflex kicks in.
You instinctively close your eyes.
+ [{timer(1.5)}]
    Cold water covers your head and the mammalian dive reflex kicks in.
    You instinctively close your eyes.
    PLEASE INSTINCTIVELY CLOSE YOUR EYES.
    + [{BLINK}]
    -
    + [{timer(1)}]
    + [{UNBLINK}]
    - -> level2_debrief
+ [{BLINK}] -> level2_debrief

= survived
~level_success += L2
Deep within the ship, you hear dozens of pumps roar into operation.
"Finally!"
The Captain breathes a sigh of relief as the ship slowly begins to right itself.
-> continue -> level2_debrief


=== talk_captain ===
{talk_captain == 1:
    -> first_conversation
-else:
    -> waiting_for_answer
}

= first_conversation
TODO what if you already went to the engine room?
"Hey, you! I need your help."
- (captain_ask)
* [What do you need me to do?]
    "At the end of the hallway, there's a ladder down to the engine room."
    ** [Ok...]
    --
    "In the engine room, there should be a display with several lights on it."
    ** [Ok...]
    --
    "I need you to go there, check those indicator lights, come back, and tell me which lights are ON.  Can you do that?"
    ** [Sure.]
    --
    "Great.  Get a move on, we don't have all day."
    -> continue ->->
* [Why me?]
    "Do you see anyone else on this godforsaken ship?"
    ** [No.]
    --
    "Then it'll have to be you.  Unless you'd rather that we both drown?"
    ** [Of course not.]
        "Thought so."
    ** [Maybe.  This is just a simulation, isn't it?]
        "I don't have time for jokes, buddy."
    --
    -> captain_ask

// TODO Proper blinking during conversation
= waiting_for_answer
{water_level == very_low:
    "You're back.  Did you check which lights are on in the engine room?"
    + [No.]
        "Then quit wasting my time and go do it already!"
        -> continue ->->
    + [Yes.]
        -> specify_lights
-else:
    "Which lights are on? You'd better get it right this time."
    -> specify_lights
}

= specify_lights
~temp candidates = LIST_ALL(colours)
~temp selection = ()
The lights that were on were...
-> choose_from(candidates) ->
~ selection += ITEM_SELECTED
~ candidates -= selection
-> choose_from(candidates) ->
~ selection += ITEM_SELECTED
~ candidates -= selection
-> choose_from(candidates) ->
~ selection += ITEM_SELECTED
~ candidates -= selection
The captain enters {listWithCommas(selection,"")} on the command console...
-> continue ->
{selection == lights_on:
    ~water_level = resolved
    ->->
-else:
    -> wrong_answer
}


= wrong_answer
{water_level:
- very_low:
    Nothing happens.
    The captain grumbles.
    "That wasn't right at all.  Go double-check the indicator panel."
    ~water_level = low
- low:
    A second alarm starts to go off.
    "Get your shit together and try that one more time."
    ~water_level = medium
- medium:
    # AUDIO: explosion
    Something in the depths of the ship explodes, startling the captain.
    "Do you understand the situation we're in? You have one chance to get this right, or we're both dead!"
    ~water_level = high
- high:
    # AUDIO: explosion
    Another loud explosion echoes throughout the ship.
    ~water_level = sunk
}
-> continue ->->

=== level2_debrief
-> enter_portal ->
{level_success? L2:
    SECOND CHAMBER COMPLETE
- else:
    ADVERSE EVENT DETECTED
    SECOND CHAMBER ABORTED
}
Tell us, what happened in the second chamber?
+ [I was on a sinking ship.]
- (top)
What {|else} do you remember about this ship?
<- ship_questions(-> top)
<- debrief_questions(-> top, -> third_chamber)
-> DONE

= ship_questions(-> back)
* {level_success? L2}[I helped the Captain rescue the ship.]
    Interesting.
    -> back
* {level_success !? L2}[The ship sank.]
    Was it your fault?
    ** [Yes.]
    ** [No.]
    ** [Maybe?]
    --
    Did you drown?
    ** [Yes.]
    ** [No.]
    ** [Maybe?]
    --
    Interesting.
    -> continue -> back
-> DONE


