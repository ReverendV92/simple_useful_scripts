
TOOL.Category		= "Construction"
TOOL.Name			= "Entity ID"
TOOL.Command		= nil
TOOL.ConfigName		= nil

function TOOL:LeftClick(tr)

	if !IsValid(tr.Entity) then return false end

	if CLIENT then return true end

	self.SelectedEnt = tr.Entity

	print( "\nEntity Class is: " .. self.SelectedEnt:GetClass() .. "\nMapCreationID is: " .. self.SelectedEnt:MapCreationID() )

	return false

end

function TOOL:RightClick(tr)

	if !IsValid(tr.Entity) then return false end

	if CLIENT then return true end

	self.SelectedEnt = tr.Entity

	print( "\nEntity Class is: " .. self.SelectedEnt:GetClass() .. "\nCreationID is: " .. self.SelectedEnt:GetCreationID() )

	return false

end

function TOOL:Reload(tr)

	if !IsValid(tr.Entity) then return false end

	if CLIENT then return true end

	self.SelectedEnt = tr.Entity

	print( "\nEntity Class is: " .. self.SelectedEnt:GetClass() .. "\nEntIndex ID is: " .. self.SelectedEnt:EntIndex() )

	return false

end

if CLIENT then

language.Add("tool.entity_id.name","Entity ID")
language.Add("tool.entity_id.0","Left: MapCreationID, Right: CreationID, Reload: EntIndex")
language.Add("tool.entity_id.desc","Get the entity ID of a prop, entity, etc.")

end