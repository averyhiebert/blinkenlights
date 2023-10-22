INCLUDE experimental.ink
INCLUDE prologue.ink
INCLUDE utils.ink
INCLUDE player.ink

INCLUDE level1.ink
INCLUDE level2.ink
INCLUDE debrief_questions.ink




VAR DEBUG = true

{DEBUG:
    ~ player_status += scalded_hand
    -> second_chamber
}


-> start
