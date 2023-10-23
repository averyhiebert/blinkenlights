CONST GORGON_WARNING_TIME = 3 // How much warning before eyes MUST be closed?
CONST GORGON_DANGER_TIME = 9  // How long does the gorgon stay in view?

LIST gorgon_location = (_cave2), _cave_left, _cave_right, _cave_forest
VAR gorgon_passed = false
VAR found_secret = false
=== fourth_chamber ===
# AUDIO: portal_jump
# AUDIOLOOP: level4
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
TODO Make it require at least a second before secret passage shows up.
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
You see a scrap of a notebook left behind.
+ [Notebook]
    ~found_secret = true
    "To whoever finds this:"
    -> continue ->
    "It's too late for me.  I've lived here for too long.  The Gorgon knows my scent."
    -> continue ->
    "The previous subjects have all suffered a terrible fate."
    "But you can escape.  They can let you out of the testing apparatus, if you convince them."
    -> continue ->
    "I have discovered that there is a self-destruct code for the apparatus."
    "Threaten to say it out loud, and they will have to release you."
    -> continue ->
    - (illegible)
    "The code is {ILLEGIBLE|SMUDGED|RIPPED|MISSING}."
    + [{BLINK}] -> illegible
    + [This is the end of the message.]
        -> secret_room
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
# INTERRUPT_MONSTER
# AUDIO: horrid_sight
THE GORGON IS A TERRIBLE SITE TO BEHOLD
YOU IMMEDIATELY REGRET THIS
-> blink_continue -> gorgon_bad_ending

=== gorgon_bad_ending
-> enter_portal ->
ADVERSE EVENT DETECTED
FOURTH CHAMBER ABORTED
+ [{timer(1)}]
-
ERROR
UNSTABLE EVENT
RE-ENTERING CHAMBER
TODO story here.

=== level4_debrief
-> enter_portal ->
FOURTH CHAMBER COMPLETE
Congratulations! You are the first subject to survive the fourth chamber without an adverse event.
+ [Thanks?]
-
The fifth chamber awaits.  We are excited to see what lies inside.
+ [Me too.]
    Excellent. Please blink to begin.
    -> blink_continue -> fifth_chamber
+ [Wait.  Shouldn't you already know what's in the fifth chamber?]
-
...Of course.
We are excited to see what lies in your future, inside the safe simulated chamber whose contents we created.
+ [That's not what you said.  You said "what lies inside."]
-
You are overthinking things.
+ [No I'm not.  I demand to know what's going on here.]
-
...
+ [{timer(2)}]
-
...Fine.  It won't make any difference.
I hope you will still see fit to help us.
-> continue ->
We did not create the Labyrinth.  It has existed for an unknown length of time.
It may predate the human species entirely.
-> continue ->
When we first discovered it, several of our personnel entered the Labyrinth themselves, in an attempt to understand it.  None of them returned.
-> continue ->
So we built this testing apparatus, to send subjects in and pull them out again safely.
-> continue ->
Well, "safely."
-> continue ->
So far, all of our subjects have suffered from adverse events in the fourth chamber or earlier.
Many of them now refuse to open their eyes, and experience other mental... anomalies.
-> continue ->
But you are different.  You exited the fourth chamber intact.
Perhaps you can learn the secrets of the Labyrinth?
+ [Perhaps I can...]
    Then will you agree to enter the fifth chamber for us?
    ++ [Yes.] -> good_luck_continue
    ++ [No.]
+ [I'd rather just survive.]
- (continue_persuading)
Perhaps you can find our lost employees, or a cure for the other test subjects.
You would be a hero.
+ [I'd be dead. Or something like it.]
+ [Ok.  I'll do it.] -> good_luck_continue
-
You could go down in history as the brave soul who conquered the Labyrinth.
+ [Fine.  I'll do it.] -> good_luck_continue
+ [The answer is still no!]
-
I'm afraid you have no choice.
Only we can release you from the testing apparatus.
Please blink to continue to the fifth chamber.
+ [{BLINK}] -> fifth_chamber
+ {found_secret}[If you don't release me, I'll say the self-destruct codephrase.]
-
...
+ [{timer(2)}]
-
...Fine.  You win.
-> exit_labyrinth


= good_luck_continue
Excellent.  Good luck, we're all counting on you.
Please blink to begin...
-> blink_continue ->
# AUDIO: portal_jump
-> fifth_chamber

= exit_labyrinth
Disengaging testing apparatus.
Please close your eyes for 5 seconds to continue.
+ [{BLINK}]
-
+ [{UNBLINK}] -> exit_labyrinth
+ [{timer(4.5)}] -> escape_ending

= escape_ending
# AUDIO: portal_jump
# AUDIOLOOP: silence
TODO write escape ending
Congrats! You escaped with your life.

Chambers cleared without adverse events: {LIST_COUNT(level_success)}/4.
{inventory? pocket_watch:You also got a platinum pocket watch, I guess.}
{player_status? scalded_hand:Your hand is still burned.}

Let us know what you thought in the comments, and consider donating using the "support this game" button below!
-> END


















