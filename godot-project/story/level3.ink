
=== third_chamber ===
# AUDIO: portal_jump
# AUDIOLOOP: level3
# BG: rain
VAR ferryman_summoned = false
-> swamp

= swamp
You {find yourself|are} on the swampy shores of a vast estuary.  {~Ghostly lights flicker in the distance.|The stench of rot and decay fills the air.|Damp fog hangs in the stagnant air.}
A {~rickety|rotting|ancient} wooden dock juts out into the water.
{not ferryman_summoned:
    An iron bell hangs from a {~gnarled|half-dead|hunched-over} oak tree.
- else:
    A spectral hooded figure hovers above the dock.
}
+ {not ferryman_summoned}[Ring the bell]
    # AUDIO: bell
    ~ferryman_summoned = true
    A spectral, hooded figure appears before your eyes.
    <- vanish
    ++ [Speak to the apparition]
        -> speak
    ++ [Ignore the apparition]
        -> swamp
+ {ferryman_summoned}[Speak to the hooded figure]
  -> speak

= speak
"Greetings, traveller.  I am the ferryman.
But I will not take you across the estuary."
- (ferryman_root)
<- clarifying_questions
<- vanish
+ (take_me_across)[Why won't you take me across the estuary?]
    "You lack true strength."
    <- vanish
    ++ [What is true strength?]
    --
    "If you had it, you would already know."
    <- vanish
    ++ [We all have our own definition of strength.]
    --
    "True.  What is strength to you?"
    <- vanish
    ++ [True strength is the power of persuasion.]
        "Then you have not yet demonstrated true strength."
    ++ [True strength is the ability to stare death in the face, unblinking.]
        "And are you strong in this sense?"
        <- vanish
        +++ [No.]
            "Then I will not take you across the estuary."
        +++ [Yes.]
            "Prove it."
            The ferryman's hollow eyes stare deeply into your own.
            <br>
            <br>
            [center][img]icon.png[/img]  [img]icon.png[/img][/center]
            TODO If we can show player's eyes somewhere, it should be here.
            ++++ [{BLINK}]
                The ferryman suddenly fades out of existence.
                On the wind, you hear a final taunt:
                "By your own standards, you are weak."
                ~ferryman_summoned = false
                -> continue -> swamp
            ++++ [{timer(10)}]
                TODO balancing the timing here
                "...Very impressive, I admit."
                -> success
    ++ [True strength means forging your own path.]
        "Then you can find your own path across the estuary."
+ {take_me_across}[Take me across or I'll kill you.]
    "You cannot threaten the dead with death."
    <- vanish
    ++ [I just did.]
        "You tried."
    ++ [If I blink, you will disappear.]
        "Disappearing is not the same as death."
        <- vanish
        +++ [Are you sure?]
        ---
        "Not entirely.  But you will blink eventually, regardless of what I do."
        <- vanish
        +++ [You have a point.]
            I always do.
        +++ [I might not. It depends when the simulation ends.]
            "I know not what this means. But I suppose... it may be worth finding out."
            -> success
+ [Walk away]
    -> swamp
- -> continue -> swamp

= success
The ferryman finally relents, and begins leading you to a small boat.
+ [{BLINK}]
    The ferryman finally relents, and begins leading you to a small boat.
    <br>
    But just as you step into the boat, you blink and he vanishes again, leaving you stranded.
    -> stranded
    ~ferryman_summoned = false
    -> continue -> swamp
+ [Enter the ferry]
    The boat pulls out into the waters of the estuary...
    ++ [{BLINK}]
        The boat pulls out into the waters of the estuary.
        But before you reach the other side, you blink and the ferryman vanishes, leaving you stranded.
        -> stranded
    ++ [{timer(3)}]
    -- 
    -> level3_success

= stranded
+ [Wait]
- (alone)
You are alone, floating in a vast expanse of {&water|oil|tears|wine|ichor|blood|vitreous humor}...
+ [{BLINK}]
    -> alone
+ [{timer(2.5)}]
    -> level3_failure

= level3_success
~level_success += L3
-> enter_portal ->
THIRD CHAMBER COMPLETE
-> level3_debrief

= level3_failure
-> enter_portal ->
ADVERSE EVENT DETECTED
THIRD CHAMBER ABORTED
-> level3_debrief

= level3_debrief
-> enter_portal ->
What happened in the third chamber?
+ [I was in a swamp.]
- (top)
What {|else} do you remember about the swamp?
<- swamp_questions(-> top)
<- debrief_questions(-> top, -> fourth_chamber)
-> DONE


= swamp_questions(-> back)
* [It was on the shores of an estuary.]
    Okay.
    -> back
* [There was a ghostly ferryman.]
    Did he take you across the estuary?
    ** {level_success? L3}[Yes.]
        Interesting.
        -> back
    ** {level_success!? L3}[Sorta.]
    --
    What do you mean by that?
    ** [He disappeared and abandoned me partway across.]
    --
    You need to be more careful.
    -> back
-> DONE

= vanish
+ [{BLINK}]
    As you blink, the hooded figure suddenly fades out of existence.
    ~ferryman_summoned = false
    //# AUDIO: ghost_leave
    -> continue -> swamp

= clarifying_questions
+ {not finished_clarification}{speak > 1}[Didn't you already say that?]
    Perhaps.
    <- vanish
    ++ [Can't you remember?]
    --
     "I remember that I was a ferryman in life, as I am now in death.  That is all I remember."
    <- vanish
    ++ [I see...]
    -- (finished_clarification) -> ferryman_root


