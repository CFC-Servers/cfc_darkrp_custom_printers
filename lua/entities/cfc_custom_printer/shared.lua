ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "CFC Custom Money Printer"
ENT.Author = "CFC Development Team"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Color = Color( 199, 75, 30 ) --Color( 36, 41, 67 )
ENT.DamageOnExplode = true
ENT.BlastRadius = 100
ENT.MaxMoneyCapacity = 10000

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "price" )
    self:NetworkVar( "Entity", 0, "owning_ent" )
end
