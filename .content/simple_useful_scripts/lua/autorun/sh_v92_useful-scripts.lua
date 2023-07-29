
AddCSLuaFile( )

if not ConVarExists( "vnt_sus_sv_suicide_toggle" ) then CreateConVar( "vnt_sus_sv_suicide_toggle" , "0" , { FCVAR_ARCHIVE } , "(BOOL) Toggle the vanilla suicide option" , 0 , 1 ) end
if not ConVarExists( "vnt_sus_sv_suicide_silent_toggle" ) then CreateConVar( "vnt_sus_sv_suicide_silent_toggle" , "0" , { FCVAR_ARCHIVE } , "(BOOL) Toggle the silent suicide option" , 0 , 1 ) end
if not ConVarExists( "vnt_sus_cl_use" ) then CreateConVar( "vnt_sus_cl_use" , "1" , { FCVAR_REPLICATED , FCVAR_ARCHIVE , FCVAR_USERINFO } , "(INT) Which use animation to play" , 0 , 4 ) end
if not ConVarExists( "vnt_sus_cl_drop" ) then CreateConVar( "vnt_sus_cl_drop" , "3" , { FCVAR_REPLICATED , FCVAR_ARCHIVE , FCVAR_USERINFO } , "(INT) Which drop weapon animation to play" , 0 , 4 ) end
if not ConVarExists( "vnt_sus_sv_drop_death" ) then CreateConVar( "vnt_sus_sv_drop_death" , "0" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } , "(BOOL) Drop weapon on death" , 0 , 1 ) end
if not ConVarExists( "vnt_sus_sv_knock" ) then CreateConVar( "vnt_sus_sv_knock" , "1" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } , "(BOOL) Toggle Knock-Knocking" , 0 , 1 ) end
if not ConVarExists( "vnt_sus_sv_cic_auto" ) then CreateConVar( "vnt_sus_sv_cic_auto" , "0" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } , "(BOOL) Toggle Crap Item Cleanup at map load" , 0 , 1 ) end

if CLIENT then

	-------------------------
	-------------------------
	-- Options Panel
	-------------------------
	-------------------------

	hook.Add( "PopulateToolMenu", "vntSimpleUsefulMenuIndex", function()

		spawnmenu.AddToolMenuOption( "Options" , "V92" , "vntSimpleUsefulMenu" , "Simple Useful Scripts" , "" , "" , function( Panel )

			Panel:ControlHelp( "SUS Mod Options" )

			Panel:Help( "Options to control the functions of the SUS mod.\n\nSee the mod page for more info:\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=136546465" )

			-- Presets
			local Default = {

				["vnt_sus_sv_suicide_toggle"] = 0 ,
				["vnt_sus_sv_suicide_silent_toggle"] = 1 ,
				["vnt_sus_cl_use"] = 1 ,
				["vnt_sus_cl_drop"] = 3 ,
				["vnt_sus_sv_drop_death"] = 0 ,
				["vnt_sus_sv_knock"] = 1 ,
				["vnt_sus_sv_knock"] = 0 ,

			}
			local presetV92 = {

				["vnt_sus_sv_suicide_toggle"] = 0 ,
				["vnt_sus_sv_suicide_silent_toggle"] = 0 ,
				["vnt_sus_cl_use"] = 1 ,
				["vnt_sus_cl_drop"] = 4 ,
				["vnt_sus_sv_drop_death"] = 1 ,
				["vnt_sus_sv_knock"] = 1 ,
				["vnt_sus_sv_cic_auto"] = 1 ,

			}

			-- Presets
			Panel:AddControl( "ComboBox" , { ["MenuButton"] = 1 , ["Folder"] = "vnt_sus" , ["Options"] = { ["#preset.default"] = Default , ["V92"] = presetV92 } , ["CVars"] = table.GetKeys( Default ) } )

			Panel:Help( "--------------------\nKnock Functions\n--------------------" )

			Panel:CheckBox( "Knock-Knocking" , "vnt_sus_sv_knock" )
			Panel:ControlHelp( "Toggle the ability to knock-knock. Doesn't stop the crappy jokes." )

			Panel:Button( "Knock" , "knock" , { } )

			Panel:Help( "--------------------\nSuicide Functions\n--------------------" )

			Panel:CheckBox( "Disable Vanilla Suicides" , "vnt_sus_sv_suicide_toggle" )
			Panel:ControlHelp( "Toggle vanilla suicide ability" )

			Panel:Button( "Suicide" , "kill" , { } )

			Panel:CheckBox( "Disable Silent Suicides" , "vnt_sus_sv_suicide_silent_toggle" )
			Panel:ControlHelp( "Toggle silent suicide ability" )

			Panel:Button( "Silent Suicide" , "killsilent" , { } )

			Panel:Help( "--------------------\nUse Functions\n--------------------" )

			local comboUseAnim = Panel:ComboBox( "Use Animations" , "vnt_sus_cl_use" )
			comboUseAnim:AddChoice( "Disabled" , 0 )
			comboUseAnim:AddChoice( "Give" , 1 )
			comboUseAnim:AddChoice( "Drop" , 2 )
			comboUseAnim:AddChoice( "Place" , 3 )
			comboUseAnim:AddChoice( "Throw" , 4 )
			Panel:ControlHelp( "Set which animation you want to use for using" )

			Panel:Help( "--------------------\nDrop Functions\n--------------------" )

			Panel:CheckBox( "Drop Weapon on Death" , "vnt_sus_sv_drop_death" )

			Panel:Button( "Drop Current Weapon" , "dropweapon" , { } )
			local comboUseAnim = Panel:ComboBox( "Drop Animations" , "vnt_sus_cl_drop" )
			comboUseAnim:AddChoice( "Disabled" , 0 )
			comboUseAnim:AddChoice( "Give" , 1 )
			comboUseAnim:AddChoice( "Drop" , 2 )
			comboUseAnim:AddChoice( "Place" , 3 )
			comboUseAnim:AddChoice( "Throw" , 4 )
			Panel:ControlHelp( "Set which animation you want to use for dropping" )

			Panel:Help( "--------------------\nCleanup Functions\n--------------------" )

			Panel:Button( "Clear Item Spawns" , "cleanupitems" , { } )
			Panel:ControlHelp( "Removes all map-spawned weapons & items." )

			Panel:CheckBox( "Auto-Clean" , "vnt_sus_sv_cic_auto" )
			Panel:ControlHelp( "Check this box to make items be automatically removed on map load & admin cleanup." )

		end )

	end )

end

if SERVER then

	-------------------------
	-------------------------
	-- Drop Weapon On Death
	-------------------------
	-------------------------

	local function vntDropOnDeath( ply )

		-- If for some reason the convar isn't valid, fuck off
		if not ConVarExists( "vnt_sus_sv_drop_death" ) then return false end

		-- If the toggle is on...
		if GetConVarNumber( "vnt_sus_sv_drop_death" ) == 1 then

			-- print("check 1")
			-- and their weapon is valid...
			if IsValid( ply:GetActiveWeapon( ) ) and ( ply:GetActiveWeapon():GetClass() != ( "gmod_tool" or "weapon_physgun" or "gmod_camera" ) ) then

				-- print("check 2")
				-- Drop it like it's hot
				ply:ShouldDropWeapon( true )

			end

		-- Toggle isn't on
		else

			-- print("check 0")
			-- No free admin guns for you, scrublord
			ply:ShouldDropWeapon( false )

		end

	end
	hook.Add( "DoPlayerDeath" , "vntDropOnDeath" , vntDropOnDeath )

	-------------------------
	-------------------------
	-- Block Vanilla Suicide
	-------------------------
	-------------------------

	local function vntBlockSuicide( ply )

		-- If the caller isn't valid, isn't alive, or isn't even a player, kindly fuck off
		if not IsValid( ply ) or !ply:Alive( ) or !ply:IsPlayer( ) then return false end

		if ConVarExists( "vnt_sus_sv_suicide_toggle" ) and GetConVarNumber( "vnt_sus_sv_suicide_toggle" ) == 1 then

			ply:ChatPrint( "No easy way out this time..." )

			return false

		end

	end
	hook.Add( "CanPlayerSuicide" , "vntBlockSuicide" , vntBlockSuicide )

	-------------------------
	-------------------------
	-- Silent Suicide
	-------------------------
	-------------------------

	local function vntKillSilent( ply )

		-- If the caller isn't valid, isn't alive, or isn't even a player, kindly fuck off
		if not IsValid( ply ) or !ply:Alive( ) or !ply:IsPlayer( ) then return false end

		if ConVarExists( "vnt_sus_sv_suicide_silent_toggle" ) then

			if GetConVarNumber( "vnt_sus_sv_suicide_silent_toggle" ) == 0 then

				ply:KillSilent( )

				return false

			else

				ply:ChatPrint( "No easy way out this time..." )

				return false

			end

		end

	end
	concommand.Add( "killsilent" , vntKillSilent )

	-------------------------
	-------------------------
	-- Use Animation
	-------------------------
	-------------------------

	local function vntUseAnimations( ply , ent )

		-- If the CVar exists and it's not disabled...
		if ConVarExists( "vnt_sus_cl_use" ) and GetConVarNumber( "vnt_sus_cl_use" ) != 0 then

			if IsValid( ply ) and ply:Alive( ) and ply:IsPlayer( ) then

				if GetConVarNumber( "vnt_sus_cl_use" ) == 1 then

					ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_GIVE )

				elseif GetConVarNumber( "vnt_sus_cl_use" ) == 2 then

					ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_DROP )

				elseif GetConVarNumber( "vnt_sus_cl_use" ) == 3 then

					ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_PLACE )

				elseif GetConVarNumber( "vnt_sus_cl_use" ) == 4 then

					ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_THROW )

				end

			end
	
		end

	end	
	hook.Add( "PlayerUse" , "vntUseAnimations" , vntUseAnimations )

	-------------------------
	-------------------------
	-- Drop Weapon
	-------------------------
	-------------------------

	-- Yes, this is needed.
	local dropDelay = true

	local function vntDropWeapon( ply )

		-- If the CVar exists and it's not disabled...
		if ConVarExists( "vnt_sus_cl_drop" ) and GetConVarNumber( "vnt_sus_cl_drop" ) != 0 then

			if IsValid( ply ) and ply:Alive( ) and ply:IsPlayer( ) and IsValid( ply:GetActiveWeapon( ) ) and dropDelay == true then

				if IsValid( ply ) and ply:Alive( ) and ply:IsPlayer( ) then

					-- Flip the fuckin' coin!
					dropDelay = false

					-- On the RARE chance the player's weapon has an ACT_VM_HOLSTER sequence...
					ply:ConCommand( "impulse 200" ) 

					-- local throwVector

					-- Choose your fucky throw, boyos!
					if GetConVarNumber( "vnt_sus_cl_drop" ) == 1 then

						ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_GIVE )
						-- throwVector = Vector( 0 , 0 , 0 )

					elseif GetConVarNumber( "vnt_sus_cl_drop" ) == 2 then

						ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_DROP )
						-- throwVector = Vector( 50 , 0 , 0 )

					elseif GetConVarNumber( "vnt_sus_cl_drop" ) == 3 then

						ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_PLACE )
						-- throwVector = Vector( 0 , 0 , 0 )

					elseif GetConVarNumber( "vnt_sus_cl_drop" ) == 4 then

						ply:DoAnimationEvent( ACT_GMOD_GESTURE_ITEM_THROW )
						-- throwVector = Vector( 0 , 0 , 0 )

					end

					-- Delay timer, because of the animation time
					timer.Simple( 0.9 , function( ) 

						-- ply:DropWeapon( ply:GetActiveWeapon( ) , throwVector ) 
						ply:DropWeapon( ply:GetActiveWeapon( ) ) 
						dropDelay = true

					end )

				end
	
			end

		end

	end
	concommand.Add( "dropweapon" , vntDropWeapon )

	-------------------------
	-------------------------
	-- Knock-Knock
	-------------------------
	-------------------------

	local knockDelay = CurTime()
	local function vntKnockKnock( ply )

		if ConVarExists( "vnt_sus_sv_knock" ) and GetConVarNumber( "vnt_sus_sv_knock" ) != 0 then

			if IsValid( ply ) and ply:Alive( ) and ply:IsPlayer( ) and IsValid( ply:GetActiveWeapon( ) ) and knockDelay <= CurTime() then

				if IsValid( ply ) and ply:Alive( ) and ply:IsPlayer( ) then

					if not IsFirstTimePredicted then return false end

					local Trace = util.TraceLine( util.GetPlayerTrace( ply , ply:GetAimVector() ) )

					if ( Trace.HitSky or ( ply:EyePos( ) - Trace.HitPos ):Length( ) > 48 ) or not Trace.Hit then return false end

					local KnockSoundType = KnockSoundType or "Default.ImpactSoft"

					if Trace.MatType == ( MAT_ALIENFLESH or MAT_ANTLION or MAT_BLOODYFLESH or MAT_FLESH or MAT_EGGSHELL ) then

						KnockSoundType = "Flesh.ImpactSoft"

					elseif Trace.MatType == ( MAT_COMPUTER ) then

						KnockSoundType = "Computer.ImpactSoft"

					elseif Trace.MatType == ( MAT_PLASTIC or MAT_TILE ) then

						KnockSoundType = "Plastic_Box.ImpactSoft"

					elseif Trace.MatType == ( MAT_TILE ) then

						KnockSoundType = "Tile.BulletImpact"

					elseif Trace.MatType == ( MAT_GRATE ) then

						KnockSoundType = "MetalGrate.ImpactSoft"

					elseif Trace.MatType == ( MAT_VENT ) then

						KnockSoundType = "MetalVent.ImpactHard"

					elseif Trace.MatType == ( MAT_METAL ) then

						KnockSoundType = "Metal_Box.BulletImpact"

					elseif Trace.MatType == ( MAT_FOLIAGE ) then

						KnockSoundType = "Wood_Solid.ImpactSoft"

					elseif Trace.MatType == ( MAT_WOOD ) then

						KnockSoundType = "Wood_Panel.ImpactSoft"

					elseif Trace.MatType == ( MAT_GLASS ) then

						KnockSoundType = "Glass.ImpactSoft"

					elseif Trace.MatType == ( MAT_CONCRETE ) then

						KnockSoundType = "Concrete.ImpactSoft"

					else
						KnockSoundType = "Default.ImpactSoft"

					end

					timer.Create( "vntKnockKnockTimer" , 0.2 , 3 , function( )

						ply:EmitSound( KnockSoundType )
						ply:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )

						knockDelay = CurTime() + 1

					end )

				end
	
			end

		end

	end
	concommand.Add( "knock" , vntKnockKnock )

	-------------------------
	-------------------------
	-- Crap Item Cleanup
	-------------------------
	-------------------------

	local function vntCrapItemCleanup( )

		local crapItemTbl = {}

		for k, v in ipairs( ents.FindByClass( "item_*" ) ) do

			if !v:GetOwner():IsPlayer() then

				table.insert( crapItemTbl , v )

			end

		end

		for k, v in ipairs( ents.FindByClass( "weapon_*" ) ) do

			if !v:GetOwner():IsPlayer() then

				table.insert( crapItemTbl , v )

			end

		end

		for k, v in pairs( crapItemTbl ) do

			SafeRemoveEntity( v )

		end


	end

	local function vntCrapItemCleanupManual( caller )

		-- If the caller isn't valid, isn't alive, isn't even a player, and isn't an admin, kindly fuck off
		if not IsValid( caller ) or !caller:Alive( ) or !caller:IsPlayer( ) and !table.HasValue( { "superadmin" , "admin" } , caller:GetNWString( "usergroup" ) ) then 

			return 

		end

		vntCrapItemCleanup( )

	end

	local function vntCrapItemCleanupAuto( caller )

		-- If the boolean isn't set, deny and fuck off.
		if GetConVarNumber("vnt_sus_sv_cic_auto") != 1 then 

			return 

		end

		vntCrapItemCleanup( )

	end

	concommand.Add( "cleanupitems" , vntCrapItemCleanupManual )
	hook.Add( "InitPostEntity" , "vntCrapItemCleanupLoaded" , vntCrapItemCleanupAuto )
	hook.Add( "PostCleanupMap" , "vntCrapItemCleanupReset" , vntCrapItemCleanupAuto )

end
