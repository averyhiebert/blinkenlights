
=== start ===
# CLEAR
Thank you for your interest in our study.
We will be observing your behaviour within a series of perfectly safe, digitally-simulated environments which we call The Labyrinth.
This experiment will gather valuable information about human behaviour.
Do you consent to participate in this experiment?
 * [I will participate.]
    Excellent.
 * [I will not participate.]
    There has been a misunderstanding. You [i]will[/i] participate.
    We are merely asking for your consent, as required for ethics board approval.
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



