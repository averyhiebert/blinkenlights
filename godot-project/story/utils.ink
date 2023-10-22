// For standardized "blink" choice strings
CONST BLINK = "BLINK"
CONST UNBLINK = "UNBLINK"
CONST EYES_OPEN = "EYES_OPEN" // automatically picked if eyes open

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


// Select one item from a list of items.
// Use as a tunnel
VAR ITEM_SELECTED = ()
=== choose_from(candidates)
<- choice_for_each(candidates)
-> DONE
= choice_for_each(candidates)
    {LIST_COUNT(candidates) == 0:
        -> DONE
    }
    ~temp curr = LIST_MIN(candidates)
    <- choice_for_each(candidates - curr)
    + [{curr}]
        ~ITEM_SELECTED = curr
        ->->
    -> DONE

// Handy list functions, from ink documentation

=== function pop(ref _list) 
    ~ temp el = LIST_MIN(_list) 
    ~ _list -= el
    ~ return el

=== function random_pop(ref _list)
    ~ temp el = LIST_RANDOM(_list) 
    ~ _list -= el
    ~ return el
    
=== function listWithCommas(list, if_empty)
    {LIST_COUNT(list):
    - 2:
        	{LIST_MIN(list)} and {listWithCommas(list - LIST_MIN(list), if_empty)}
    - 1:
        	{list}
    - 0:
			{if_empty}
    - else:
      		{LIST_MIN(list)}, {listWithCommas(list - LIST_MIN(list), if_empty)}
    }