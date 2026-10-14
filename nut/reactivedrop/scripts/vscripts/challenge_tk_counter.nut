// Optional challenge entry point.
// Prefer mapspawn.nut so TK tracking works while ANY other challenge is selected.
// This file only helps if you explicitly select "TK Counter" in the lobby.

if ( "TkCounterLoaded" in getroottable() )
    return
getroottable().TkCounterLoaded <- true

printl( "[TK Counter] loaded via challenge (mapspawn preferred for always-on)" )

hWorldTk <- Entities.FindByClassname( null, "worldspawn" )
hWorldTk.ValidateScriptScope()
IncludeScript( "tk_counter/tk_counter", hWorldTk.GetScriptScope() )

function OnGameEvent_entity_killed( params ) {
    hWorldTk.GetScriptScope()._OnEntityKilled( params )
}

function OnGameEvent_player_activate( params ) {
    local hPlayer = GetPlayerFromUserID( params["userid"] )
    if ( !hPlayer ) return
    hWorldTk.GetScriptScope()._OnPlayerActivate( hPlayer )
}

function OnGameEvent_player_say( params ) {
    hWorldTk.GetScriptScope()._OnPlayerSay( params )
}
