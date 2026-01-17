core.register_node("myblueprint:ghost_block", {
    description = "Ghost Block (Architect's Guide)",
    drawtype = "glasslike",
    tiles = {"mychalk_ghost.png"},
    use_texture_alpha = "blend",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    pointable = true,
    buildable_to = true,
    is_ground_content = false,
    groups = {snappy = 3, cracky = 3, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
})

core.register_tool("myblueprint:chalk", {
    description = "Architect's Chalk",
    inventory_image = "mychalk_chalk.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then return end
        
        local pos = core.get_pointed_thing_position(pointed_thing, true)
        local user_name = user:get_player_name()

        -- 1. PROTECTION CHECK (Placement)
        if core.is_protected(pos, user_name) then
            core.record_protection_violation(pos, user_name)
            core.chat_send_player(user_name, "This area is protected!")
            return
        end
        
        local node = core.get_node(pos)
        if node.name == "air" then
            core.set_node(pos, {name = "myblueprint:ghost_block"})
            core.sound_play("default_place_node", {pos = pos, gain = 0.5})
        end
    end,

    on_secondary_use = function(itemstack, user, pointed_thing)
        local pos = user:get_pos()
        local user_name = user:get_player_name()
        local nodes = core.find_nodes_in_area(
            {x=pos.x-5, y=pos.y-5, z=pos.z-5}, 
            {x=pos.x+5, y=pos.y+5, z=pos.z+5}, 
            {"myblueprint:ghost_block"}
        )
        
        local cleared_count = 0
        for _, p in ipairs(nodes) do
            -- 2. PROTECTION CHECK (Clearing)
            -- We only remove the node if the player has permission for that specific spot
            if not core.is_protected(p, user_name) then
                core.remove_node(p)
                cleared_count = cleared_count + 1
            end
        end

        if cleared_count > 0 then
            core.chat_send_player(user_name, cleared_count .. " Ghost blocks cleared!")
        else
            core.chat_send_player(user_name, "No ghost blocks were cleared (Protected or none found).")
        end
    end
})
core.register_craft({
    output = "myblueprint:chalk",
    recipe = {
        {"", "dye:white", ""},
        {"", "default:stone", ""},
        {"", "default:stick", ""},
    }
})

if core.get_modpath("lucky_block") then
	lucky_block:add_blocks({
		{"dro", {"myblueprint:chalk"}, 1},
	})
end
