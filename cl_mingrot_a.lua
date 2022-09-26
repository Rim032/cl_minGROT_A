print("==[MinGROT A -- Version: 1.40]==")

//Note: Num Lock must be turned on for numpad binds to work properly.

ply_range = 4500
aimb_range = 1000

aimb_is_on = false
tracers_are_on = true
info_is_on = true
mingrot_is_on = true

hook.Add("HUDPaint", "draw_general", function()
    for k, v in pairs(player.GetAll()) do
        ply_gen_pos = v:GetPos()
        local_ply_gen_shootpos = LocalPlayer():GetShootPos()

        //Checks if a player is in range
        if (local_ply_gen_shootpos - ply_gen_pos):Length() < ply_range then
            ply_name = v:Name() //Gets name.
            ply_weapon = v:GetActiveWeapon() //Gets the weapon they're holding.
            ply_health = v:Health() //Gets health.

            ply_is_admin = v:IsAdmin()
            ply_is_spradmin = v:IsSuperAdmin()

            not_player = true

            ply_aim = v:GetAimVector():ToScreen()
            ply_aim2 = v:GetEyeTrace().HitPos:ToScreen()

            ply_position = ( v:GetPos() + Vector( 0,0,70 )):ToScreen()
            ply_position_2 = v:GetPos():ToScreen()
            ply_self_position = LocalPlayer():GetPos():ToScreen()

            surface.SetDrawColor(255, 255, 255, 110)

            if ply_name == LocalPlayer():Name() then
                ply_name = ""
                surface.SetDrawColor(0, 0, 0, 0)
                not_player = false
            end


            if not_player == true then
                if mingrot_is_on == true then 
                    if info_is_on == true then
                        draw.DrawText(ply_name, DermaDefault, ply_position.x, ply_position.y-10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER) //Text with the player's name.
                        draw.DrawText(ply_weapon, DermaDefault, ply_position.x, ply_position.y-25, Color( 255, 255, 255, 165 ), TEXT_ALIGN_CENTER) //Text with the player's gun.

                        user_admin_check()
                        user_health_check()
                    end

                    if tracers_are_on == true then 
                        surface.SetDrawColor(255, 255, 255, 110)
                        surface.DrawLine(ply_position_2.x, ply_position_2.y, ply_self_position.x, ply_self_position.y) //Tracer from player to local player.

                        surface.SetDrawColor(255, 0, 0, 255)
                        surface.DrawLine(ply_position.x, ply_position.y, ply_aim2.x, ply_aim2.y) //Tracer from the player's head to surface.
                    end
                end
            end
        end
    end
end)

hook.Add("Tick", "tick_operations_general", function()
    if mingrot_is_on == true then 
        local_user_aimb()
    end
end)

hook.Add("PreDrawHalos", "draw_halo_outline", function()
    if mingrot_is_on == true then
        halo.Add(player.GetAll(), Color(255, 255, 255, 125), 2, 2, 1, true, true)
    end
end)

//Overrides hook in a screen capture addon
hook.Add("PostRender", "override_screenshot", function()
    if mingrot_is_on == true then
        local data = render.Capture({
            format = "png",
            x = 0,
            y = 0,
            w = 0,
            h = 0
        })

        //file.Write("screen_override.png", screenshots)
        //file.write is not needed to overwrite the hook? The image is 0x0 pixels anyways.
        //Ignore "Freeimage couldn't allocate!" in the console.
    end
end)

//Doing this by tick is worse than this timer (in terms of player ease.)
timer.Create("key_bind_check", 0.1, 0, function() 
    if input.IsKeyDown(KEY_PAD_0) == true then
        aimb_range = 500
    elseif input.IsKeyDown(KEY_PAD_1) == true then
        aimb_range = 1000
    elseif input.IsKeyDown(KEY_PAD_2) == true then
        aimb_range = 2000
    elseif input.IsKeyDown(KEY_PAD_3) == true then
        aimb_range = 5000
    end

    if input.IsKeyDown(KEY_PAD_4) == true then
        ply_range = 2000
    elseif input.IsKeyDown(KEY_PAD_5) == true then
        ply_range = 4500
    elseif input.IsKeyDown(KEY_PAD_6) == true then
        ply_range = 8000
    end

    //Reset script values.
    if input.IsKeyDown(KEY_PAD_DECIMAL) == true then
        ply_range = 4500
        aimb_range = 1000
        
        aimb_is_on = false
        tracers_are_on = true
        info_is_on = true
        mingrot_is_on = true
    end


    if input.IsKeyDown(KEY_UP) == true then
        if aimb_is_on == true then
            aimb_is_on = false
        else
            aimb_is_on = true
        end
    end

    if input.IsKeyDown(KEY_LEFT) == true then
        if tracers_are_on == true then
            tracers_are_on = false
        else
            tracers_are_on = true
        end
    end

    if input.IsKeyDown(KEY_RIGHT) == true then
        if info_is_on == true then
            info_is_on = false
        else
            info_is_on = true
        end
    end

    if input.IsKeyDown(KEY_DOWN) == true then
        if mingrot_is_on == true then
            mingrot_is_on = false
        else
            mingrot_is_on = true
        end
    end
end)


function local_user_aimb()
    for f, g in pairs(player.GetAll()) do
        local_ply_shootpos = LocalPlayer():GetShootPos()
        ply_norm_pos = g:GetPos()

        if aimb_is_on == true then
            if (local_ply_shootpos - ply_norm_pos):Length() <= aimb_range then
                if (local_ply_shootpos - ply_norm_pos):Length() > 100 then
                    if ply_health >= 1 then 
                        ply_mouse_pos = ( g:GetPos() + Vector( 0,0,50 )):ToScreen()
                        input.SetCursorPos(ply_mouse_pos.x, ply_mouse_pos.y)
                    end
                end
            end
        end
    end
end

function user_admin_check()
    if ply_is_admin == true or ply_is_spradmin == true then //Check if the player's an admin or not.
        draw.DrawText("Admin", DermaDefault, ply_position.x, ply_position.y-35, Color( 255, 165, 0, 200 ), TEXT_ALIGN_CENTER)
    else
        draw.DrawText("User", DermaDefault, ply_position.x, ply_position.y-35, Color( 25, 255, 25, 165 ), TEXT_ALIGN_CENTER)
    end
end

function user_health_check()
    if ply_health > 50 then //Checking the player's health points for the text's color.
        draw.DrawText("Health: " ..ply_health, DermaDefault, ply_position.x, ply_position.y-55, Color( 90, 255, 25, 165 ), TEXT_ALIGN_CENTER)
    else
        draw.DrawText("Health: " ..ply_health, DermaDefault, ply_position.x, ply_position.y-55, Color( 255, 75, 25, 165 ), TEXT_ALIGN_CENTER)
    end
end



concommand.Add("cl_mingrot_debug_info", function(ply, cmd, args) //Lists general information regarding all players.
    if ply_aim != NULL then
        if ply_name != NULL then
            for i, j in pairs(player.GetAll()) do
                print("[_________User " ..i)
                print(ply_name.. "  :  " ..tostring(j:GetPos()))

                print("Super admin: " ..tostring(j:IsSuperAdmin()))
                print("Admin: " ..tostring(j:IsAdmin()))
            end
        end
    end
end)

concommand.Add("cl_mingrot_help", function(ply, cmd, args) //Lists control and general information.
    print("\n[----MinGROT Commands----]\n")
    print("1. AIMBOT. \n    *UP ARROW KEY to toggle. \n    *NUMPAD 0 for 500 unit aimbot range. \n    *NUMPAD 1 for 1000 unit aimbot range. \n    *NUMPAD 2 for 2000 unit aimbot range. \n    *NUMPAD 3 for 5000 unit aimbot range. \n")
    print("2. GENERAL. \n    *NUMPAD 4 for 1500 unit wallhack. \n    *NUMPAD 5 for 3500 unit wallhack. \n    *NUMPAD 6 for 5000 unit wallhack. \n    *RIGHT ARROW KEY to toggle player stats. \n    *LEFT ARROW KEY to toggle tracers. \n    *DOWN ARROW KEY to toggle MinGROT as a whole. \n    *NUMPAD 0 to reset script values.")
    print("3. MISC. \n    *Type \"cl_mingrot\" to see more commands.")
end)

//Commands are here in-case of no numpad or misc. issues.

concommand.Add("cl_mingrot_aim_on", function(ply, cmd, args)
    aimb_is_on = true
end)

concommand.Add("cl_mingrot_aim_off", function(ply, cmd, args)
    aimb_is_on = false
end)

concommand.Add("cl_mingrot_far_r", function(ply, cmd, args)
    ply_range = 5000
end)

concommand.Add("cl_mingrot_mid_r", function(ply, cmd, args)
    ply_range = 3500
end)

concommand.Add("cl_mingrot_short_r", function(ply, cmd, args)
    ply_range = 1500
end)

concommand.Add("cl_mingrot_inf_r", function(ply, cmd, args)
    ply_range = 131072
end)