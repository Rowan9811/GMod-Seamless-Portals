SWEP.Base = "weapon_base"
SWEP.PrintName = "Portal Gun"

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = false

SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.SetHoldType = "pistol"

SWEP.Weight = 5
SWEP.AutoSwichTo = true
SWEP.AutoSwichFrom = false

SWEP.Category = "Seamless Portals"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.DrawAmmo = true
SWEP.DrawChrosshair = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1 
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false


--language.Add("#weapon_mee", "MEE'S WAPON")
if CLIENT then return end

-- from portal gun addon
local function VectorAngle(vec1, vec2)
	local costheta = vec1:Dot(vec2) / (vec1:Length() * vec2:Length())
	local theta = math.acos(costheta)
	return math.deg(theta)
end

local function setPortalPlacement(owner, portal)
	local tr = owner:GetEyeTrace()
	local offset = math.abs(tr.HitNormal:Dot(Vector(0, 0, 1))) * 10
	local rotatedAng = tr.HitNormal:Angle() + Angle(90, 0, 0)

	local elevationangle = VectorAngle(vector_up, tr.HitNormal)
	if elevationangle < 1 or (elevationangle > 179 and elevationangle < 181) then 
		rotatedAng.y = owner:EyeAngles().y + 180
	end

	portal:SetPos((tr.HitPos + tr.HitNormal * 20) + Vector(0, 0, offset))
	portal:SetAngles(rotatedAng)
end

function SWEP:PrimaryAttack()
	if !self.Portal or !self.Portal:IsValid() then
		self.Portal = ents.Create("seamless_portal")
		self.Portal:Spawn()
		SafeRemoveEntity(self.Portal:ExitPortal())
		self.Portal:LinkPortal(self.Portal2)
	end

	setPortalPlacement(self.Owner, self.Portal)
	self:SetNextPrimaryFire(1)
end

function SWEP:SecondaryAttack() 
	if !self.Portal2 or !self.Portal2:IsValid() then
		self.Portal2 = ents.Create("seamless_portal")
		self.Portal2:Spawn()
		SafeRemoveEntity(self.Portal2:ExitPortal())
		self.Portal2:LinkPortal(self.Portal)
	end

	setPortalPlacement(self.Owner, self.Portal2)
	self:SetNextSecondaryFire(1)
end

function SWEP:OnRemove()
	SafeRemoveEntity(self.Portal)
	SafeRemoveEntity(self.Portal2)
end

function SWEP:Reload() 
	SafeRemoveEntity(self.Portal)
	SafeRemoveEntity(self.Portal2)
end

