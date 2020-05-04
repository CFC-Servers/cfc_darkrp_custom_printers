AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props_c17/consolebox01a.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:GetPhysicsObject():Wake()

    self.health = 100
    self.storedMoney = 0
    self.moneyMaxCapacity = 200
    self.heat = 0
end

function ENT:OnTakeDamage( dmg )
    self.health = self.health - dmg:GetDamage()
    local health = self.health

    if health < 10 then
        
    end
end

function ENT:Think()

end
