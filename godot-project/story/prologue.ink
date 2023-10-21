
=== start ===
# CLEAR
Congratulations.  You have been selected to perform a great service to humanity.
Through observing your actions in a simulated environment we will come closer to understanding the interplay of human nature with the grand totality of the universe.
Will you participate willingly?
 * [I will participate.]
    Excellent.
 * [I will not participate.]
    There has been a misunderstanding. You [i]will[/i] participate.
    Will you participate [i]willingly[/i]?
    ** [Yes.]
        Excellent.
    ** [No.]
        Please blink to indicate when you have changed your mind.
        -> blink_continue ->
        Thank you for your cooperation.
-
~temp blink_count = 0
- (sync1)
We must begin the syncing procedure.
Please blink twice.
 * {blink_count == 2} ->
    ~blink_count = 0
 + {blink_count < 2}[{BLINK}]
    ~blink_count += 1
    // TODO Add a timer or something, so we only accept 3 blinks in rapid concession.
    -> sync1
- (sync2)
Please blink 3 times.
 * {blink_count == 3} ->
 + {blink_count < 3}[{BLINK}]
    ~blink_count += 1
    -> sync2
-
Please close your eyes for 5 seconds.
// TODO Timer
+ [{BLINK}]
-
TODO Major background change/some sort of swirly vortex shader thing.
SYNC COMPLETE
+ [Enter the labyrinth...]
    -> first_chamber

=== first_chamber ===
Story start here.


