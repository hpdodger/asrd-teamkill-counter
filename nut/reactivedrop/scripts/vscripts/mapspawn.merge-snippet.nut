// --- begin TK Counter merge snippet ---
// Paste into an EXISTING mapspawn.nut. Do not use as a standalone file.

if ( !( "TkCounterLoaded" in getroottable() ) ) {
    getroottable().TkCounterLoaded <- true

    printl( "[TK Counter] merging into mapspawn" )

    IncludeScript( "tk_counter/version" )
    printl( "─────────────────────────────────────────" )
    printl( "  TK Counter  v" + ::g_TkVersion )
    printl( "  Author: typical russian (https://steamcommunity.com/id/w_asd/)" );
    printl( "─────────────────────────────────────────" )

    hWorldTk <- Entities.FindByClassname( null, "worldspawn" )
    hWorldTk.ValidateScriptScope()
    IncludeScript( "tk_counter/tk_counter", hWorldTk.GetScriptScope() )

    // Chain with existing handlers if present
    if ( !( "TkPrev_entity_killed" in getroottable() ) && ( "OnGameEvent_entity_killed" in getroottable() ) )
        getroottable().TkPrev_entity_killed <- OnGameEvent_entity_killed
    if ( !( "TkPrev_player_activate" in getroottable() ) && ( "OnGameEvent_player_activate" in getroottable() ) )
        getroottable().TkPrev_player_activate <- OnGameEvent_player_activate
    if ( !( "TkPrev_player_say" in getroottable() ) && ( "OnGameEvent_player_say" in getroottable() ) )
        getroottable().TkPrev_player_say <- OnGameEvent_player_say

    OnGameEvent_entity_killed <- function( params ) {
        if ( "TkPrev_entity_killed" in getroottable() && TkPrev_entity_killed != null )
            TkPrev_entity_killed( params )
        hWorldTk.GetScriptScope()._OnEntityKilled( params )
    }

    OnGameEvent_player_activate <- function( params ) {
        if ( "TkPrev_player_activate" in getroottable() && TkPrev_player_activate != null )
            TkPrev_player_activate( params )
        local hPlayer = GetPlayerFromUserID( params["userid"] )
        if ( hPlayer )
            hWorldTk.GetScriptScope()._OnPlayerActivate( hPlayer )
    }

    OnGameEvent_player_say <- function( params ) {
        if ( "TkPrev_player_say" in getroottable() && TkPrev_player_say != null )
            TkPrev_player_say( params )
        hWorldTk.GetScriptScope()._OnPlayerSay( params )
    }
}
// --- end TK Counter merge snippet ---
