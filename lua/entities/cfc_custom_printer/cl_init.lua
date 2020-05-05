include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
    self:SetColor( self.Color )
    self:SetMaterial( "models/debug/debugwhite" )

    local owner = self:Getowning_ent()
    owner = IsValid( owner ) and owner:Nick() or DarkRP.getPhrase( "unknown" )

    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis( ang:Up(), 90 )

    surface.SetFont( "HUDNumber5" )
    local campos = pos + ang:Up() * 11
    local text = DarkRP.getPhrase( "money_printer" )
    local textWidthOwner = surface.GetTextSize( owner )
    local textWidthMoney = surface.GetTextSize( "self.StoredMoney" .. "/" .. self.MaxMoneyCapacity )

    --[[
    What needs to be displayed:

        - Who owns the printer
        - How much money is in the printer
        - Heat levels of the printer ( show heat threshold )
        - Maximum store amount
        - Statistics (money per minute?...)
        - 
    ]]

    if LocalPlayer():GetPos():Distance( self:GetPos() ) < 500 then
        cam.StartInteractive3D2D( campos, ang, 0.11, 500 )  
            draw.RoundedBox( 0, -138, -145, 278, 276, self.Color )
            draw.SimpleText( owner, "HUDNumber5", -textWidthOwner / 2, -130 )
            draw.SimpleText( "self.StoredMoney" .. "/" .. self.MaxMoneyCapacity, "HUDNumber5", -textWidthMoney / 2, -100 )
        cam.EndInteractive3D2D( campos, 500 )
    end
end
