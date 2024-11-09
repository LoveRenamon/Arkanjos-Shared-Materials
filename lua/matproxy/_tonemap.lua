--[[
   ToneMap is a custom Proxy to fetch Entity's current illumination color

   ToneMap {
      raw "0"        // tell to return raw values (opcional) (bool)
      lerp "0.003"   // adjust interpolation speed between resultVar, the lower value, the longer inerpolation it will be (opcional) (float)
      scale "1"      // scale resultVar (opcional) (float)
      resultVar $var // output (vec3)
   }

--]]
matproxy.Add( {
   name = "ToneMap",

   init = function( self, mat, values )
      self.ResultXYZ = values.resultvar
      self.Scalar = values.scale or 1
      self.lerpSpeed = values.lerp or .003
      self.Raw = tobool(values.raw) or false
   end,

   bind = function( self, mat, ent ) -- TODO: lower ticks
      if not (IsValid( ent )) then return end

      local Tone = render.GetLightColor( ent:GetPos() )

      if (self.Raw) then return mat:SetVector( self.ResultXYZ, Tone ) end

      local t = {
         Vector(0, 0, 0),
         Vector(5000, 5000, 0),
         Vector(-10000, -10000, 0),
         Vector(10000, 10000, 0),
         Vector(-5000, -5000, 0),
      }

      local HDRmin, HDRmax = math.huge, -math.huge

      for _, p in ipairs(t) do
         local lightColor = render.GetLightColor(p)
         local HDR = ( lightColor.x + lightColor.y + lightColor.z ) * 0.33
      
         HDRmin = math.min(HDRmin, HDR)
         --HDRmax = math.max(HDRmax, HDR)
      end

      local XYZ = render.GetToneMappingScaleLinear()

      local R = Tone.x * 0.755 + XYZ.x * 0.25
      local G = Tone.y * 0.715 + XYZ.y * 0.25
      local B = Tone.z * 1.125 + XYZ.z * 0.25
      local HDR = ( Tone.x + Tone.y + Tone.z ) * 0.33

      if ( HDR <= HDRmin ) then
         R = R * 0.128
         G = G * 0.128
         B = B * 0.128
      end

      local R = R * self.Scalar
      local G = G * self.Scalar
      local B = B * self.Scalar
      lerpR = Lerp( self.lerpSpeed, lerpR or 0, R )
      lerpG = Lerp( self.lerpSpeed, lerpG or 0, G )
      lerpB = Lerp( self.lerpSpeed, lerpB or 0, B )

      mat:SetVector( self.ResultXYZ, Vector( lerpR, lerpG, lerpB ) )

   end
} )
