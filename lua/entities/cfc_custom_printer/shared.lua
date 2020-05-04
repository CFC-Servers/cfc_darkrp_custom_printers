ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "CFC Custom Money Printer"
ENT.Author = "CFC Development Team"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Color = Color( 36, 41, 67 )

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 0, "owning_ent")
end
