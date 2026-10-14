// TK Counter — red on-screen announcement (game_text) layout.
//
// Placeholders in template (both ${...} and {...} work):
//   ${nickname}  / ${name}       — player name
//   ${killcount} / ${count}      — TK count
//   ${rank}      / ${title}      — rank title in the player's language
//
// Examples:
//   "${nickname}: ${killcount} — ${rank}"
//   "${nickname} - ${killcount} - ${rank}"
//   "TK ${killcount} | ${rank}"

::g_TkAnnounce <- {
    template = {
        ru = "${nickname}: ${killcount} — ${rank}",
        en = "${nickname}: ${killcount} — ${rank}",
    },

    // game_text look (y: 0 = top, 1 = bottom, -1 = center)
    color    = "255 40 40 255",
    color2   = "255 40 40 255",
    y        = "0.38",
    x        = "-1",
    holdtime = "4",
    fadein   = "0.15",
    fadeout  = "0.35",
    channel  = "3",
    effect   = "0",
}
