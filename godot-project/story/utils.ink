// For standardized "blink" choice strings
CONST BLINK = "BLINK"
CONST UNBLINK = "UNBLINK"

=== blink_continue ===
+ [{BLINK}] ->->

=== continue ===
+ [Continue...] ->->

=== function timer(seconds) ===
// format the "timer" choice text
~return "TIMER " + seconds

=== function random_switch(ref list) ==
// Randomly CHANGE (i.e. may not stay same) the state of a list
~list = LIST_RANDOM(LIST_ALL(list) - list)
