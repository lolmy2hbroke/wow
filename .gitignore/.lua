local ver = "0.06"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Riven" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/riven/master/riven.lua', SCRIPT_PATH .. 'Riven.lua', function() PrintChat('<font color = "#00FFFF">Riven Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/riven/master/riven.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local RivenMenu = Menu("Riven", "Riven")

RivenMenu:SubMenu("Combo", "Combo")

RivenMenu.Combo:Boolean("Q", "Use Q in combo", true)
RivenMenu.Combo:Boolean("AA", "Use AA in combo", true)
RivenMenu.Combo:Boolean("W", "Use W in combo", true)
RivenMenu.Combo:Boolean("E", "Use E in combo", true)
RivenMenu.Combo:Boolean("R", "Use R in combo", true)
RivenMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
RivenMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
RivenMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
RivenMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
RivenMenu.Combo:Boolean("RHydra", "Use RHydra", true)
RivenMenu.Combo:Boolean("THydra", "Use THydra", true)
RivenMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
RivenMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
RivenMenu.Combo:Boolean("Randuins", "Use Randuins", true)


RivenMenu:SubMenu("AutoMode", "AutoMode")
RivenMenu.AutoMode:Boolean("Level", "Auto level spells", false)
RivenMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
RivenMenu.AutoMode:Boolean("Q", "Auto Q", false)
RivenMenu.AutoMode:Boolean("W", "Auto W", false)
RivenMenu.AutoMode:Boolean("E", "Auto E", false)
RivenMenu.AutoMode:Boolean("R", "Auto R", false)


RivenMenu:SubMenu("LaneClear", "LaneClear")
RivenMenu.LaneClear:Boolean("Q", "Use Q", true)
RivenMenu.LaneClear:Boolean("W", "Use W", true)
RivenMenu.LaneClear:Boolean("E", "Use E", true)
RivenMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
RivenMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

RivenMenu:SubMenu("Harass", "Harass")
RivenMenu.Harass:Boolean("Q", "Use Q", true)
RivenMenu.Harass:Boolean("W", "Use W", true)

RivenMenu:SubMenu("KillSteal", "KillSteal")
RivenMenu.KillSteal:Boolean("Q", "KS w Q", true)
RivenMenu.KillSteal:Boolean("E", "KS w E", true)
RivenMenu.KillSteal:Boolean("R", "KS w R", true)
RivenMenu.KillSteal:Boolean("W", "KS w W", true)

RivenMenu:SubMenu("AutoIgnite", "AutoIgnite")
RivenMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

RivenMenu:SubMenu("Drawings", "Drawings")
RivenMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

RivenMenu:SubMenu("SkinChanger", "SkinChanger")
RivenMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
RivenMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local THydra = GetItemSlot(myHero, 3748)
		
	--AUTO LEVEL UP
	if RivenMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if RivenMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 260) then
				if target ~= nil then 
                                      CastSkillShot(_Q, enemy)
                                end
            end

            if RivenMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 125) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
		
	    if RivenMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 500) >= RivenMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end
			
            if RivenMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if RivenMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if RivenMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if RivenMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if RivenMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 325) then
			 CastSkillShot(_E, target.pos)
	    end

            if RivenMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 125) then
			CastSpell(_W)
            end		
			   				    
            if RivenMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end		
			
            if RivenMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 500) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end
				  
            if RivenMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            if RivenMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 500) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end

            if RivenMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            if RivenMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 500) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end
			
	    		
            if RivenMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end


            if RivenMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if RivenMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end

            if RivenMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if RivenMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end
			
	     if RivenMenu.Combo.AA:Value() and ValidTarget(target, 125) then
                         AttackUnit(target)
            end		
			
	    if RivenMenu.Combo.THydra:Value() and THydra > 0 and Ready(THydra) and ValidTarget(target, 400) then
			CastSpell(THydra)
            end	

	    if RivenMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 125) then
			CastSpell(_W)
	    end
	    	                			
            if RivenMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= RivenMenu.Combo.RX:Value()) then
			CastSkillShot(_R, target)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 260) and RivenMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_R) and ValidTarget(enemy, 900) and RivenMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastSkillShot(_R, target)
  
                end
			
		if IsReady(_W) and ValidTarget(enemy, 125) and RivenMenu.KillSteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then
		                      CastSpell(_W)  
                end	
			
			if IsReady(_E) and ValidTarget(enemy, 325) and RivenMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                        CastSkillShot(_E, target.pos)
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if RivenMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 260) then
	        	CastSkillShot(_Q, closeminion)
                end

                if RivenMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 125) then
	        	CastSpell(_W)
	        end

                if RivenMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 325) then
	        	CastSkillShot(_E, closeminion)
	        end

                if RivenMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if RivenMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if RivenMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 260) then
		      CastSkillShot(_Q, target.pos)
          end
        end 
        if RivenMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 125) then
	  	      CastSpell(_W)
          end
        end
        if RivenMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 325) then
		      CastSpell(_E)
	  end
        end
        if RivenMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastSpell(_R)
	  end
        end
		
			
	--AUTO GHOST
	if RivenMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if RivenMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 260, 0, 150, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("rivenbrokenwings") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end
		


end) 


local function SkinChanger()
	if RivenMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Riven</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')


