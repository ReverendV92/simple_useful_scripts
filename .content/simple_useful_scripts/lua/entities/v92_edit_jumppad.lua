
---------------------------------------------
---------------------------------------------
-- Editable Jump Pad Entity
---------------------------------------------
-- V92: Code
-- Valve: Faith Plate Icon
---------------------------------------------
-- It's like the ones in HL1, but without the
-- func_door fuckery.
--
-- Use the context menu in-game and right 
-- click on the entity to open the editor.
---------------------------------------------
---------------------------------------------

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Spawnable = true -- Spawnable?
ENT.AdminOnly = false -- Limited to admins?
ENT.Editable = true -- Editable?

if CLIENT then

	ENT.Category		= "Editors"
	ENT.PrintName		= "Jump Pad"
	ENT.Author			= "V92"
	ENT.Contact			= "Steam"
	ENT.Purpose			= "Vertical Supremacy"
	ENT.Instructions	= "Touch to jump, context menu to edit"
	
	language.Add("v92_edit_jumppad", "Jump Pad")
	function ENT:Draw() self:DrawModel() end

end

function ENT:SetupDataTables()

	-- These are the public keys passed to the editable entity function.
	self:NetworkVar( "String" ,	0 , "CustomModel" , { ["KeyName"] = "CustomModel" , ["Edit"] = { ["title"] = "Custom Model" , ["order"] = 1 , ["type"] = "String" , ["waitforenter"] = true } } )
	self:NetworkVar( "String" ,	1 , "CustomSound" , { ["KeyName"] = "CustomSound" , ["Edit"] = { ["title"] = "Custom Sound" , ["order"] = 2 , ["type"] = "String" , ["waitforenter"] = true } } )
	self:NetworkVar( "Int" ,	0 , "BouncePower" , { ["KeyName"] = "BouncePower" , ["Edit"] = { ["title"] = "Bounce Power" , ["order"] = 3 , ["type"] = "Int" , ["min"] = 0 , ["max"] = 15000 , ["waitforenter"] = false } } )

	if SERVER then

		-- Set the default keys for the data table. Change them here if you want to edit the entity's defaults.
		self:SetCustomModel( "models/props_junk/trashdumpster02b.mdl"  )
		self:SetCustomSound( "weapons/crossbow/fire1.wav"  )
		self:SetBouncePower( 500 )

	end

end

if SERVER then

	function ENT:Initialize()

		-- Get the model from the data table keys and set it.
		self:SetModel( self:GetCustomModel() )

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetTrigger( true ) -- Required to use Touch functions

		self:GetPhysicsObject():Wake()
		self:DropToFloor()

	end

	-- TOUCH! Patrick, don't touch!
	function ENT:StartTouch( Toucher )		

		-- Adding a slight delay because sometimes you'll touch it more than once and it'll send you into low orbit.
		local Delay = CurTime()
		if Delay > CurTime() then return end
		Delay = CurTime() + 0.2

		-- There's probably a cleaner way to do this, but it works.
		local DefaultModel = Model("models/props_junk/trashdumpster02b.mdl")
		-- If the CustomModel data isn't the default...
		if self:GetCustomModel() != DefaultModel then
			-- Re-run the initialize function to change the model
			self:Initialize()
		end

		-- If we're touching a player...
		if Toucher:IsPlayer() then

			-- Throw the son of a bitch into the air!
			Toucher:SetVelocity( Toucher:GetVelocity() + Vector( 0, 0, self:GetBouncePower() ) )

		-- Players behave differently so we have to call a different function for everything else...
		else

			-- Punt the shit like an ugly baby!
			Toucher:GetPhysicsObject():SetVelocity( Toucher:GetVelocity() + Vector( 0, 0, self:GetBouncePower() ) )

		end

		-- Play some nice(?) sounds!
		self:EmitSound( self:GetCustomSound() )

	end

	function ENT:OnRemove()

		-- self:Remove() is about as trustworthy as a used car salesman with Honest in his name
		SafeRemoveEntity( self )

	end

end
