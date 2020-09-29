AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.SeizeReward = 950

function ENT:Initialize()
    self:SetModel( "models/props_c17/consolebox01a.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:GetPhysicsObject():Wake()

    self.Health      = 200
    self.StoredMoney = 0
    self.Heat        = 0
    self.IsBurning   = false
end

function ENT:OnTakeDamage( dmg )
    self.Health = self.Health - dmg:GetDamage()
    local health = self.Health

    if health <= 0 then
        if not self.IsBurning then
            self:Destruct()
            self:Remove()
        else
            self:Explode()
        end
    elseif health < 30 then
        self.IsBurning = true
        self:Ignite( 999, 0 )
    end
end

function ENT:Destruct()
    local vPoint = self:GetPos()

    local effectdata = EffectData()
    effectdata:SetStart( vPoint )
    effectdata:SetOrigin( vPoint )
    effectdata:SetScale( 1 )
    util.Effect( "Explosion", effectdata )

    DarkRP.notify( self:Getowning_ent(), 1, 4, DarkRP.getPhrase( "money_printer_exploded" ) )
end

-- Explode money?
function ENT:Explode()
    if not self:IsOnFire() then return end
    self:Destruct()

    local blastRadius = self.BlastRadius
    local nearbyEnts = ents.FindInSphere( self:GetPos(), blastRadius )

    for _, ent in pairs( nearbyEnts ) do
        if ent:IsPlayer() then
            if self.DamageOnExplode then
                local distance = ent:GetPos():Distance( self:GetPos() )
                ent:TakeDamage( distance / blastRadius * 100, self, self )
            end
        end
    end

    self:Remove()
end

function ENT:Think()
    if self:WaterLevel() > 0 then
        self:Destruct()
        self:Remove()
    end
end
