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
        
        local node = core.get_node(pos)
        if node.name == "air" then
            core.set_node(pos, {name = "myblueprint:ghost_block"})
            core.sound_play("default_place_node", {pos = pos, gain = 0.5})
        end
    end,
   on_secondary_use = function(itemstack, user, pointed_thing)
    local pos = user:get_pos()
    local nodes = core.find_nodes_in_area(
        {x=pos.x-5, y=pos.y-5, z=pos.z-5}, 
        {x=pos.x+5, y=pos.y+5, z=pos.z+5}, 
        {"myblueprint:ghost_block"}
    )
    for _, p in ipairs(nodes) do
        core.remove_node(p)
    end
    core.chat_send_player(user:get_player_name(), "Ghost blocks cleared!")
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

lucky_block:add_blocks({
	{"dro", {"myblueprint:chalk"}, 1},
})
