# asrd_tk_counter

Server-side teamkill counter with ranks, on-disk persistence, and a chat leaderboard.

**Version:** `tk_counter/version.nut` (currently **1.3.0**), also shown in the `mapspawn` banner and `!tkc_help`. History: [`CHANGELOG.md`](CHANGELOG.md).

No client files required: announcements use `ClientPrint` / `game_text`.

## Features

- Works with no challenge selected, or with any challenge (mapspawn scenario)
- Or only while the **TK Counter** challenge is selected (challenge scenario)
- Persists across sessions under `save/vscripts/tk_counter/`
- Configurable ranks / breakpoints (0–1001 by default)
- Configurable admin whitelist
- i18n (built-in RU / EN)
- Configurable announcement format (color, position, template; default `${nickname}: ${killcount}${rank}`)
- Admin stats reset (one player or all)
- Per-player toggle to hide teamkill announcements (`!tkc_on` / `!tkc_off`)

## Which install scenario?

| Scenario | When to use | Survives challenge changes? |
|----------|-------------|-----------------------------|
| **A. Always-on (mapspawn)** | Counter should always run on the server | Yes |
| **B. Challenge only** | Enable manually from the lobby like a normal challenge | No — only while TK Counter is selected |

Prefer **A** if the server rotates challenges often.

For both scenarios, copy from the repo’s `nut/reactivedrop/` into the server game folder:

```
...\Alien Swarm Reactive Drop\reactivedrop\
```

---

## Scenario A — always on (mapspawn)

The counter starts on every map (including lobby), regardless of the selected challenge.

### 1. Copy the core

From `nut/reactivedrop/` into the server’s `reactivedrop/`:

```
scripts/vscripts/tk_counter/     — entire folder (tk_counter.nut, ranks, admins, announce, version)
```

### 2. Enable mapspawn

In `reactivedrop/cfg/autoexec.cfg` (create the file if needed), add:

```
sv_mapspawn_nut_exec 1
```

### 3. Install the mapspawn loader

**If the server has no** `scripts/vscripts/mapspawn.nut` yet:

- Copy `scripts/vscripts/mapspawn.nut` from the repo as-is.

**If `mapspawn.nut` already exists** (another always-on mod):

1. **Do not overwrite** the existing file.
2. Append the contents of `scripts/vscripts/mapspawn.merge-snippet.nut` to the **end** of the current `mapspawn.nut`.

The snippet loads TK Counter and chains existing `player_say` / `player_activate` / `entity_killed` handlers.

### 4. Restart

Change map or restart the server. The console should show a `TK Counter  v…` banner.

No challenge menu entry is required for this scenario. You can skip `resource/challenges/tk_counter.txt` and `challenge_tk_counter.nut`.

---

## Scenario B — challenge only

The counter runs only while the lobby challenge **TK Counter** is selected. Switching challenges stops the module.

### 1. Copy core + challenge

```
scripts/vscripts/tk_counter/              — entire folder
scripts/vscripts/challenge_tk_counter.nut
resource/challenges/tk_counter.txt
```

### 2. mapspawn and autoexec

**Not required.** `sv_mapspawn_nut_exec` and `mapspawn.nut` are unnecessary for this scenario.

### 3. Enable in-game

In the lobby, select challenge **TK Counter (optional)** and start the mission.

---

## After install — configuration

Edit these without touching the core:

| File | Purpose |
|------|---------|
| `scripts/vscripts/tk_counter/ranks.nut` | Rank thresholds and titles |
| `scripts/vscripts/tk_counter/admins.nut` | Whitelist for `!tkc_reset` |
| `scripts/vscripts/tk_counter/announce.nut` | Red text template, color, position, stack |
| `scripts/vscripts/tk_counter/version.nut` | Version number (banner + `!tkc_help`) |

### Admins for reset

SteamIDs in the usual form (as in `status` / `admins_simple.ini`):

```squirrel
::g_TkAdmins <- [
    "STEAM_1:0:12345678",
]
```

Find an ID with `status` in the server console, or `!tkc` (name and SteamID in chat).  
Example: `!tkc_reset STEAM_1:0:12345678`  
`[U:1:…]` is also accepted. `STEAM_0` and `STEAM_1` with the same digits are the same account.

VScript cannot read SourceMod admins — keep this list in sync yourself if needed.

### Announcement template

Squirrel has no JS-style template expressions inside `${...}` — only field substitution:

```squirrel
rank_on_every_kill = false,  // rank only when the player ranks up
rank_prefix = " — ",

template_kill = {
    ru = "${nickname}: ${killcount}${rank}",
    en = "${nickname}: ${killcount}${rank}",
},
template_rankup = {
    ru = "${nickname} → ${rank}",
    en = "${nickname} → ${rank}",
},
```

On a normal kill, `${rank}` is `""` or `" — Title"` depending on the flag.  
Placeholders: `${nickname}`, `${killcount}`, `${rank}`. Also configurable: `color`, `y`, `holdtime`, `stack_slots`.

## Commands

Prefix: `!tkc`.

| Command | Who | What it does |
|---------|-----|--------------|
| `!tkc` | anyone | your score and rank |
| `!tkc_top` | anyone | top 10 |
| `!tkc_next` | anyone | next rank |
| `!tkc_ranks` | anyone | list of thresholds and ranks |
| `!tkc_lang` | anyone | show language |
| `!tkc_lang ru` / `!tkc_lang en` | anyone | set rank language |
| `!tkc_on` | anyone | enable teamkill announcements |
| `!tkc_off` | anyone | disable teamkill announcements |
| `!tkc_reset STEAM_1:0:12345` | whitelist | reset one player’s count to 0 |
| `!tkc_reset all` | whitelist | reset all players’ counts |
| `!tkc_help` | anyone | help (version + author) |

`!tkc_off` only hides auto-announcements. On-demand commands and counting still work.

Command replies are **only** visible to the requester. Auto-announcements go to players with `!tkc_on`. Chat commands do not show red center text.

## Data files

On the server the script writes stats here:

```
reactivedrop/save/vscripts/tk_counter/
  index.txt        — account ids of all tracked players
  <accountId>.txt  — one player’s data
```

Each `<accountId>.txt` is one line with four `|`-separated fields:

```
count|name|lang|notify
```

Example:

```
42|Vasya|ru|1
```

| Field | Example | Meaning |
|-------|---------|---------|
| `count` | `42` | teamkill count |
| `name` | `Vasya` | last known nickname |
| `lang` | `ru` / `en` | rank language (`!tkc_lang`) |
| `notify` | `1` / `0` | show auto teamkill announcements: `1` = yes (`!tkc_on`), `0` = no (`!tkc_off`) |

You normally do not edit these by hand — the counter updates them. Back up `save/vscripts/tk_counter/` with the server.

## Notes

- Suicide does not count; alien → marine does not count; a bot victim counts if the killer is a player.
- `FileToString` is limited to ~16 KB per file — hence one file per player plus an index.
- After upgrading from 1.1.x, delete the old standalone `scripts/vscripts/tk_counter.nut` if it still sits in the `vscripts` root.

## Repository layout

```
asrd_tk_counter/
  README.md
  CHANGELOG.md
  nut/reactivedrop/
    cfg/autoexec.cfg
    resource/challenges/tk_counter.txt
    scripts/vscripts/
      mapspawn.nut                 — scenario A
      mapspawn.merge-snippet.nut   — scenario A if mapspawn already exists
      challenge_tk_counter.nut     — scenario B
      tk_counter/
        tk_counter.nut
        ranks.nut
        admins.nut
        announce.nut
        version.nut
```
