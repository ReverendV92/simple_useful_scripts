
TOOL.Category		= "Construction"
TOOL.Name			= "Entity ID"
TOOL.Command		= nil
TOOL.ConfigName		= nil

-- local ply = TOOL:GetOwner()

function TOOL:LeftClick(tr)

	if !IsValid( tr.Entity ) then 

		return false

	end

	target = tr.Entity

	if CLIENT then
		-- self.Owner:PrintMessage( HUD_PRINTTALK , "\nEntity Class: " .. target:GetClass() .. "\nMapCreationID: " .. target:MapCreationID() .. "\nCreationID: " .. target:GetCreationID() .. "\nEntIndex ID: " .. target:EntIndex() .. "\nName: " .. targetName )
		chat.AddText( Color( 100 , 255 , 100 ) , "Entity Class is: " .. target:GetClass() .. "\nMapCreationID is: " .. target:MapCreationID() .. "\nCreationID is: " .. target:GetCreationID() .. "\nEntIndex ID is: " .. target:EntIndex() )
	-- else
		-- PrintMessage( HUD_PRINTTALK , "\nEntity Class: " .. target:GetClass() .. "\nMapCreationID: " .. target:MapCreationID() .. "\nCreationID: " .. target:GetCreationID() .. "\nEntIndex ID: " .. target:EntIndex() .. "\nName: " .. target:GetName() )
	end

	return

end

function TOOL:RightClick(tr)

	return false

end

function TOOL:Reload(tr)

	return false

end

if CLIENT then

	language.Add("tool.entity_id.name","Entity ID")
	language.Add("tool.entity_id.0","Left: Print Info")
	language.Add("tool.entity_id.desc","Get the ID of an entity.")

end
