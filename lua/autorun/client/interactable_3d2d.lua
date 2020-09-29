local Interactive2D3D = {}

Interactive2D3D.IsVisible = function( self )
    return self.Visible or false
end

Interactive2D3D.Start = function( self, vPos, aRot, vScale )
    if not vPos or not aRot then return false end
    self.Valid = true

    local lplayer           = LocalPlayer()
    local shootpos          = lplayer:GetShootPos()
    local plpostoscreenx    = vPos.x - shootpos.x
    local plpostoscreeny    = vPos.y - shootpos.y
    local plpostoscreen     = math.sqrt( plpostoscreenx ^ 2 + plpostoscreeny ^ 2 )
    local dist1             = 1 / math.cos( math.rad( EyeAngles().y ) ) * plpostoscreen
    local distfull          = 1 / math.cos( math.rad( EyeAngles().p ) ) * dist1
    
    local trace = {}
    trace.filter = lplayer
    trace.start  = shootpos
    trace.endpos = lplayer:GetAimVector() * distfull + shootpos
    local tr = util.TraceLine( trace )

    if tr.Entity and IsValid( tr.Entity ) then
        self.Visible = false 
        return false 
    end

    self.Visible = true

    local test = trace.endpos
    local vWorldPos = test - vPos
    vWorldPos:Rotate( Angle( 0, -aRot.y, 0 ) )
    vWorldPos:Rotate( Angle( -aRot.p, 0, 0 ) )
    vWorldPos:Rotate( Angle( 0, 0, -aRot.r ) )

    self.EyeHitx = vWorldPos.x / ( vScale or 1 )
    self.EyeHity = ( -vWorldPos.y ) / ( vScale or 1 )

    return true
end

Interactive2D3D.Finish = function( self )
    if not self:IsVisible() then return false end

    return self:Remove()
end

Interactive2D3D.Use = function( self, Name )
    if not self:IsVisible() then return false end

    if not Name and self.Buttons then
        for _, v in pairs( self.Buttons ) do
            if self:Use( v.Name ) then
                if ( v.LastClick or 0 ) < CurTime() then
                    if v.DoClick then
                        self:Remove( v.Name )
                        v:DoClick()
                        v.LastClick = CurTime()+0.1

                        return v.Name
                    end
                end

                break
            end
        end
    else
        if not self.Buttons or not self.Buttons[Name] then return false end

        return self.Buttons[Name]:IsHovered()
    end
end

hook.Add( "KeyPress", "Interactive2D3DKeyPress", function( _, key )
    if key == IN_USE then
        Interactive2D3D:Use()
    end
end )

Interactive2D3D.Remove = function( self, Name )
    if Name and self.Buttons and self.Buttons[Name] then
        self.Buttons[Name] = nil
    else
        self.Buttons = {}
        self.Visible = false
        self.Valid = false
    end

    return true
end

Interactive2D3D.MakeButton = function( self, x, y, w, h, Name )
    if not Name or not self.Valid then return false end

    self.Buttons = self.Buttons or {}
    if self.Buttons[Name] then
        if self:IsVisible() and self.EyeHitx and self.EyeHity then
            if self.EyeHitx < ( w + x ) and self.EyeHitx > x and self.EyeHity < ( h + y ) and self.EyeHity > y then
                if not self.Buttons[Name].Hovered then
                    self.Buttons[Name].Hovered = true
                end
            else 
                if self.Buttons[Name].Hovered then
                    self.Buttons[Name].Hovered = false
                end
            end
            if self.Buttons[Name].Paint then self.Buttons[Name]:Paint( x, y, w, h ) end
        end

        return self.Buttons[Name]
    end

    local Button = {}
    Button.Name    = Name
    Button.Hovered = false
    Button.Pos = {
        x = ( x or 0 ),
        y = ( y or 0 ),
        w = ( w or 0 ),
        h = ( h or 0 )
    }
    
    Button.IsHovered = function( this )
        return this.Hovered or false
    end

    Button.Remove = function( this )
        return self:Remove( this.Name ) or false
    end

    Button.GetPos = function( this )
        return this.Pos or {}
    end

    self.Buttons[Name] = Button

    return Button
end

function cam.StartInteractive3D2D( vector, angle, scale )
    cam.Start3D2D( vector, angle, scale )
    Interactive2D3D:Start( vector, angle, scale )
end

function cam.EndInteractive3D2D()
    if distance then
        if vector:Distance( LocalPlayer():GetPos() ) < distance then
            cam.End3D2D()
        end
    else
        cam.End3D2D()
    end
end
