--Debiddo bootstrap
DebiddoSharedMaterials = true

--[[
		The ideia behind everything here is use a table to be indexed at end of all lua files that match, being called a single time, but... I'm still figuring how to do it on LUA with GLUA libs
			Also due most GMod community like official Discord server are mostly dick people with behaviour of a "self-disorder complex" that look to entertain theirselves. It's hard to just understand their messy workarounds at my free time.
			It may looks rude, but is what you read at their daily messages
--]]
DebiddoNAME       = {}
DebiddoCATEGORY   = {}
DebiddoID         = {}
DebiddoWORKSHOPID = {}
DebiddoVM         = {}
DebiddoPREFIX     = "models/debiddo/"

--[[
		Allow edit NPCs base HP that use out CVar
--]]
CreateConVar( "sv_debiddo_npc_base_health", 100, FCVAR_GAMEDLL, "Changes the base health for the newler HL2 based NPCs by Debiddo\nUsually Citizens have: <base>*0.8\nCombine NPCs have <base>*1.1\n", 1, 2147483648 )
local sv_debiddo_npc_base_health = GetConVar( "sv_debiddo_npc_base_health" )

--[[
		To add Player Models under "models/debiddo" that have a specific file names to each one, you can override it with local variable
--]]
function DebiddoPM( NAME, ID )
	list.Set( "PlayerOptionsModel", NAME, DebiddoPREFIX..ID.."/pm.mdl" )
	player_manager.AddValidModel( NAME, DebiddoPREFIX..ID.."/pm.mdl" )
	player_manager.AddValidHands( NAME, DebiddoPREFIX..ID.."/c_arms.mdl", 0, 0 )
end

--[[
		To add NPCs by a list sheet
--]]
local function DebiddoHL2NPC( t, class )
	list.Set( "NPC", class or t.Class, t )
end


--[[
		This add both HL2's Citizen and Combine based NPCs into a single preset
--]]
function DebiddoNPC( NAME, ID, CATEGORY )
	DebiddoHL2NPC( {
		Name = NAME.." (Friendly)",
		Class = "npc_citizen",
		KeyValues = { citizentype = CT_REBEL, SquadName = "Rebel" },
		Model = DebiddoPREFIX..ID.."/npc.mdl",
		Weapons = {
			"weapon_crowbar",
			"weapon_stunstick",
			"weapon_pistol",
			"weapon_357",
			"weapon_smg1",
			"weapon_ar2",
			"weapon_shotgun",
			"weapon_rpg"
		},
		Health = ( sv_debiddo_npc_base_health:GetInt() * 0.88 ),
		Category = CATEGORY
	}, "npc_"..ID.."_f" )
	DebiddoHL2NPC( {
		Name = NAME.." (Hostile)",
		Class = "npc_combine_s",
		KeyValues = {
			SquadName = "overwatch"
		},
		Model = DebiddoPREFIX..ID.."/npc_c.mdl",
		Weapons = {
			"weapon_stunstick",
			"weapon_pistol",
			"weapon_357",
			"weapon_smg1",
			"weapon_ar2",
			"weapon_shotgun"
		},
		Health = ( sv_debiddo_npc_base_health:GetInt() * 1.1 ),
		Numgrenades = "4",
		Category = CATEGORY
	}, "npc_"..ID.."_h" )
end


--[[
		This add both Player Model and NPC into a single call
--]]
function DebiddoAdd( NAME, ID, WORKSHOPID, CATEGORY )

	if SERVER then resource.AddWorkshop( WORKSHOPID ) end
	DebiddoPM( NAME, ID )
	DebiddoNPC( NAME, ID, CATEGORY )

end
