// TK Counter — red on-screen announcement (game_text) layout.
//
// Placeholders in template (both ${...} and {...} work):
//   ${nickname}  / ${name}       — player name
//   ${killcount} / ${count}      — TK count
//   ${rank}      / ${title}      — rank title in the player's language
//
// Simultaneous TKs: stack_slots lines with different y + channel
// so messages do not overwrite each other.

::g_TkAnnounce <- {
    template = {
        ru = "${nickname}: ${killcount} — ${rank}",
        en = "${nickname}: ${killcount} — ${rank}",
    },

    // game_text look (y: 0 = top, 1 = bottom, -1 = center)
    color    = "255 40 40 255",
    color2   = "255 40 40 255",
    x        = "-1",
    // Base line for the first stack slot (then + y_step each)
    y        = "0.32",
    y_step   = "0.055",
    holdtime = "4",
    fadein   = "0.15",
    fadeout  = "0.35",
    // game_text effect: 0 = fade, 1 = credits (typewriter), 2 = scan-out
    effect   = "0",

    // How many simultaneous red lines; channels = channel_base .. channel_base+slots-1
    stack_slots  = 4,
    channel_base = 1,
}

// Runtime: when each stack slot becomes free again (Time()). Max 6 slots.
::g_TkAnnounceSlotFreeAt <- [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]
