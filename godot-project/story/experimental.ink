

VAR night = false
=== test ===
# CLEAR
You are in a garden.
{night:
The full moon hangs low in the night sky.
- else:
The hot summer sun glares down upon you.
}
+ [BLINK]
    ~night = !night
    -> test
+ [Go to river.]
    -> river

=== river ===
# CLEAR
You are by the river.
 + [test]
    -> test