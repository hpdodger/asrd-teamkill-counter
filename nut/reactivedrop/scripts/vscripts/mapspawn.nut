// TK Counter — loaded at the start of every map (including lobby)
// Requires: sv_mapspawn_nut_exec 1  (see cfg/autoexec.cfg)
//
// If mapspawn.nut already exists on the server, append mapspawn.merge-snippet.nut
// instead of overwriting.

if ( "TkCounterLoaded" in getroottable() )
    return
getroottable().TkCounterLoaded <- true

IncludeScript( "tk_counter/version" )

printl( "─────────────────────────────────────────" )
printl( "  TK Counter  v" + ::g_TkVersion )
printl( "  Author: typical russian (https://steamcommunity.com/id/w_asd/)" );
printl( "─────────────────────────────────────────" )

hWorldTk <- Entities.FindByClassname( null, "worldspawn" )
hWorldTk.ValidateScriptScope()
IncludeScript( "tk_counter/tk_counter", hWorldTk.GetScriptScope() )

OnGameEvent_entity_killed <- function( params ) {
    hWorldTk.GetScriptScope()._OnEntityKilled( params )
}

OnGameEvent_player_activate <- function( params ) {
    local hPlayer = GetPlayerFromUserID( params["userid"] )
    if ( !hPlayer ) return
    hWorldTk.GetScriptScope()._OnPlayerActivate( hPlayer )
}

OnGameEvent_player_say <- function( params ) {
    hWorldTk.GetScriptScope()._OnPlayerSay( params )
}
