
function DropCurrentWeapon(ply)
         local Currentweapon = ply:GetActiveWeapon()

         local NewWeapon = ents.Create(Currentweapon:GetClass())

         local currentweaponclip1 = Currentweapon:Clip1()
         local currentweaponclip2 = Currentweapon:Clip2()

         ply:StripWeapon(Currentweapon:GetClass())


         NewWeapon:SetPos(ply:GetShootPos() + (ply:GetAimVector() * 30))

         ply.AllowWeaponPickupFix = 0

         timer.Simple(1.5,PickupDelayFunc,ply)

         NewWeapon:Spawn()
         
         NewWeapon:SetClip1(currentweaponclip1)
         NewWeapon:SetClip2(currentweaponclip2)


end

function PickupDelayFunc(ply)
         ply.AllowWeaponPickupFix = 1
end


if SERVER then
concommand.Add("DropWeapon",DropCurrentWeapon)
end

--function AutoBindOnSpawn(ply)
--	ply.AllowWeaponPickupFix = 1
--	ply:ConCommand("bind g DropWeapon\n")
--end

hook.Add("PlayerInitialSpawn","AutobindDropWeapon",AutoBindOnSpawn)

function RePickupFix(ply,weapon)
         if ply.AllowWeaponPickupFix == 0 then return false end
end

hook.Add("PlayerCanPickupWeapon","FixForPickup",RePickupFix)


