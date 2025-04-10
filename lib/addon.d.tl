----------------------------------------
--- // Info
----------------------------------------

--[[
    This file contains every Addon Lua function and type, ported to teal.
    Simply put this file in your workspace, and configure it as your `global_env_def` in your `tlconfig.lua`, and teal's compiler should stop complaining, and provide intellisense for Addon Lua.

    This extension is required for intellisense: https://marketplace.visualstudio.com/items?itemName=pdesaulniers.vscode-teal

    Lua version created by: @nameouschangey (GitHub) and @Toast732 (GitHub)
    Lua version maintained by: @Cuh4 (GitHub)
    Ported to Teal by @JudgementalBird (Github)

    Lua repo: https://github.com/Cuh4/StormworksAddonLuaDocumentation
]]

----------------------------------------
--- // Changelog
----------------------------------------

--[[
    Last updated for game version: v1.13.4 (The Viewing Scope Update)
        Note that even if the above version is outdated, updates to this may still be applied (usually corrections).

    The following changelog entries are in DD/MM/YY format.

    -- 10/04/2025
        - Begin porting intellisense.lua to Teal global environment definition, renamed to addon.d.tl, host directory renamed to `lib`
        - This means no more callback definitions, as to my knowledge they can not currently be specified to Teal's language server. (?)
        - Removed unmaintained documentation
        - Updated README
    -- 15/01/2024
        - Added `group_id` return value to `server.spawnAddonVehicle` and `server.spawnVehicle` as the new game update v1.13.4 now returns the vehicle group ID with the aforementioned functions.

    -- 30/10/2024
        - Fix `server.getVehicleSign` and `server.getVehicleSeat` having their `name` parameter hinted as a number instead of a string

    -- 02/09/2024
        - Fix `server.spawnVolcano` having an invalid number of arguments too (again, `magnitude` argument doesn't exist)
        - Fix `server.spawnTornado` having an invalid number of arguments (`magnitude` argument doesn't exist)

    -- 28/08/2024
        - `SWGameSettingEnum` and `SWGameSettings` are now up-to-date
        - Fixed `SWGameSettingEnum` using `---@class` instead of `---@alias`

    -- 17/08/2024
        - Fixed up `server.setAIState` `AI_STATE` parameter description. It didn't cover all AI states
        - Made `server.setCreatureTooltip` an alias instead of it having its own function

    -- 14/08/2024
        - Added the new lobsters and crabs to `SWEquipmentTypeEnum`
        - Fixed incorrect `SWNotificationTypeEnum` names
        - Fixed `SWNotificationTypeEnum` being spelt as `SWNotifiationTypeEnum`

    -- 03/08/2024
        - Changed overall structure for tidying reasons.

    -- 02/08/2024
        - Updated SWRopeTypeEnum.
        - Added description comments to server, property, debug, etc

    -- 04/07/2024
        - Replaced "--- " with "-- ". Personal preference yet again

    -- 03/07/2024
        - Replaced "-- @" with "---@" as it's my personal preference and it's pretty much the standard
        - Added server.getVehiclesByName()
        - Added SWVehicleAuthor class
        - Updated vehicle class for v1.11.6 (add "name" and "authors" field)

    -- 19/06/2024
        - Fixed matrix.rotationToFaceXZ return type should be SWMatrix

    -- 14/06/2024
        - Added missing fluid types to SWTankFluidTypeEnum

    -- 07/06/2024
        - Added `---@meta _` see https://luals.github.io/wiki/annotations/#meta

    -- 12/05/2024
        - Switched around server.setCharacterSeated and server.setSeated (server.setSeated is no longer an alias but the actual thing)
        - Added server.setCreatureSeated as an alias of server.setSeated

    -- 08/05/2024
        - Added descriptions for server.spawnTornado, server.spawnMeteor, server.spawnMeteorShower, server.spawnVolcano, server.getVolcanos, server.spawnWhirlpool, server.spawnTsunami
        - Added server.getFishData, server.getFishHotspots
        - Added SWFishData and SWFishHotSpotData classes
        - Int states for fish equipment types are now shown in the equipment type description

    -- 06/05/2024
        - Rename SWOreTypeEnum to SWResourceTypeEnum
        - Add missing resources to SWResourceTypeEnum (solid_propellant and fishes)

    -- 05/05/2024
        - Fix description for server.getWeather

    -- 26/04/2024
        - General formatting fixes

    -- 25/04/2024
        - Add ---@deprecated tag to all undocumented hidden alias functions

    -- 24/04/2024
        - Added creature_type, interactable, and animal_type fields to SWAddonComponentData (From v1.10.10 update)

    -- 23/04/2024
        - Added server.setSeated alias for server.setCharacterSeated
        - Removed function descriptions for alias functions

    -- 19/04/2024
        - Fixed SWVehicleComponents class

    -- 12/04/2024
        - Add solid_propellant parameter to server.setTileInventory()
        - Added missing argument for server.spawnMeteor(), is_spawn_tsunami

    -- 28/03/2024
        - Added documentation for server.clearOilSpill()
        - Added documentation for callback onClearOilSpill()
        - Added solid_propellant return annotation for server.getTileInventory()

    -- 02/03/2024
        - Fix return annotation for server.spawnVehicle (group_id --> primary_vehicle_id)

    -- 21/02/2024
        - Add missing documentation for server.spawnMeteorShower

    -- 15/02/2024
        - Documented hidden undocumented functions. They are mainly aliases of existing functions
            These undocumented functions are untested. I found them in "_ENV.server", but I've never used them.
            This means they might not even be callable, they do nothing, or I may have aliased it to the wrong function
            
        - Removed "BUG REPORT" text, couldn't find hyperlink for it

    -- 01/02/2024
        - Added drill_rod and fishing_lure to object type enum
        - Added new map label types to map label type enum
        - Added new equipment types to equipment type enum

    -- 02/01/2024
        - Added missing object_id attribute to the SWPlayer class.

    -- 18/12/2023
        - Fixed return annotation for server.spawnAddonVehicle being "group_id" and not "vehicle_id"
        - Added missing is_success return annotation for server.getVehicleGroup

    -- 12/12/2023
        - Added server.dlcSpace(), forgot to add it earlier

    -- 30/11/2023
        - Fixed server.spawnAddonVehicle docs
        - Fixed server.spawnVehicle docs
        - Removed server.getVehicleName
]]

----------------------------------------
--- // Main
----------------------------------------

global record SWZoneSize
    x: number
    y: number
    z: number
end

global record SWZone
    tags: {number:string}
    tags_full: string
    name: string
    transform: SWMatrix
    size: SWZoneSize
    radius: number
    type: integer -- use enum helper
    parent_vehicle_id: number
    parent_relative_transform: SWMatrix
end

global record SWAddonData
    name: string
    path_id: string
    file_store: string
    location_count: integer
end

global record SWLocationData
    name: string
    tile: string
    env_spawn_count: integer
    env_mod: boolean
    component_count: integer
end

global record SWAddonComponentData
    tags_full: string
    tags: {number:string}
    display_name: string
    type: integer -- SWAddonComponentDataTypeEnum
    id: number
    dynamic_object_type: integer --SWObjectTypeEnum
    transform: SWMatrix
    vehicle_parent_component_id: number
    character_outfit_type: number -- outfit type
    interactable: boolean
    creature_type: integer --SWCreatureTypeEnum
    animal_type: integer --SWAnimalTypeEnum
end

global record SWAddonComponentSpawned
    tags_full: string
    tags: {number:string}
    display_name: string
    type: integer -- SWAddonComponentDataTypeEnum
    transform: SWMatrix
    id: number
    object_id: number
    group_id: number
    vehicle_ids: {integer, integer}
end

global record SWPlayer
    id: number
    name: string
    admin: boolean
    auth: boolean
    steam_id: number
    object_id: number
end

global record SWObjectData
    object_type: integer -- SWObjectTypeEnum
    hp: number
    incapacitated: boolean
    dead: boolean
    interactible: boolean
    ai: boolean
    name: string
    creature_type: integer --SWCreatureTypeEnum
    scale: number
end

global record SWVoxelPos
    x: number
    y: number
    z: number
end

global record SWVehicleSignData
    name: string
    pos: SWVoxelPos
end

global record SWVehicleSeatData
    name: string
    pos: SWVoxelPos
    seated_id: integer
    seated_peer_id: integer
end

global record SWVehicleButtonData
    name: string
    pos: SWVoxelPos
    on: boolean
end

global record SWVehicleDialData
    name: string
    pos: SWVoxelPos
    value: number
    value2: number
end

global record SWVehicleTankData
    name: string
    pos: SWVoxelPos
    value: number
    values: {integer:number} --SWTankFluidTypeEnum
    capacity: number
    fluid_type: integer --SWTankFluidTypeEnum
end

global record SWVehicleBatteryData
    name: string
    pos: SWVoxelPos
    charge: number
end

global record SWVehicleHopperData
    name: string
    pos: SWVoxelPos
    values: {integer:number}--SWResourceTypeEnum
    capacity: number
end

global record SWVehicleWeaponData
    name: string
    pos: SWVoxelPos
    ammo: number
    capacity: number
end

global record SWVehicleRopeHookData
    name: string
    pos: SWVoxelPos
end

global record SWVehicleComponents
    signs: {integer:SWVehicleSignData}
    seats: {integer:SWVehicleSeatData}
    buttons: {integer:SWVehicleButtonData}
    dials: {integer:SWVehicleDialData}
    tanks: {integer:SWVehicleTankData}
    batteries: {integer:SWVehicleBatteryData}
    hoppers: {integer:SWVehicleHopperData}
    guns: {integer:SWVehicleWeaponData}
    rope_hooks: {integer:SWVehicleRopeHookData}
end

global record SWLoadedVehicleData
    components:SWVehicleComponents
    mass:number
    voxels:number
    characters:{integer:integer}
end

global record SWVehicleAuthor
    name: string
    steam_id: string
end

global record SWVehicleData
    name: string
    tags_full: string
    tags: {number:string}
    group_id: integer
    transform: SWMatrix
    simulating: boolean
    editable: boolean
    invulnerable: boolean
    static: boolean
    authors: {integer:SWVehicleAuthor}
end

global record SWTileData
    name: string
    sea_floor: number
    cost: number
    purchased: boolean
end

global record SWPathFindPoint
    x: number
    z: number
end

global record SWTargetData
    character: number
    vehicle: number
    x: number
    y: number
    z: number
end

global record SWGameSettings
    photo_mode: boolean
    map_show_players: boolean
    sharks: boolean
    infinite_fuel: boolean
    lightning: boolean
    show_name_plates: boolean
    override_weather: boolean
    megalodon: boolean
    infinite_money: boolean
    day_length: number
    fast_travel: boolean
    cleanup_vehicle: boolean
    settings_menu: boolean
    settings_menu_lock: boolean
    rogue_mode: boolean
    ceasefire: boolean
    vehicle_damage: boolean
    vehicle_spawning: boolean
    engine_overheating: boolean
    third_person_vehicle: boolean
    infinite_ammo: boolean
    no_clip: boolean
    unlock_all_components: boolean
    player_damage: boolean
    map_show_vehicles: boolean
    despawn_on_leave: boolean
    third_person: boolean
    infinite_batteries: boolean
    teleport_vehicle: boolean
    clear_fow: boolean
    npc_damage: boolean
    show_3d_waypoints: boolean
    map_teleport: boolean
    respawning: boolean
    unlock_all_islands: boolean
end

global record SWVolcano
    x: number
    y: number
    z: number
    tile_x: number
    tile_y: number
end

global record SWTime
    hour: number
    minute: number
    daylight_factor: number
    percent: number
end

global record SWWeather
    fog: number
    rain: number
    snow: number
    wind: number
    temp: number
end

global record SWStartTile
    name: string
    x: number
    y: number
    z: number
end

global record SWOilDepositData
    x: number
    y: number
    z: number
    r: number
    oil: number
end

global record SWFishData
    name: string
    price: number
    resource_type: SWResourceTypeEnum
    equipment_type: SWEquipmentTypeEnum
    is_net_catchable: boolean
end

global record SWFishHotSpotData
    x: number
    y: number
    z: number
    resource_type: SWResourceTypeEnum
    r: number
end

-- A table containing functions that can be used for making your addon easily customizable by the user. Functions in this table must be saved in g_savedata.
global record property
    -- Adds a checkbox to the settings of the addon NOTE: to default true with a setting below, this must be declared as a variable outside of any function, and the default_value param must be "true", and then later stored in g_savedata in onCreate(is_world_create).
    checkbox: function(text: string, default_value: boolean|string): boolean
    -- Adds a slider to the settings of the addon
    slider: function(text: string, min: number, max: number, increment: number, default_value: number): number
end

--A table containing functions that can be used for creating and manipulating matrices.
global type SWMatrix = {number, number, number, number, number, number, number, number, number, number, number, number, number, number, number, number}

global record matrix
    -- Multiplies two matrices together
    multiply: function(matrix1: SWMatrix, matrix2: SWMatrix): SWMatrix
    -- Inverts the matrix
    invert: function(matrix: SWMatrix): SWMatrix
    -- Transposes a matrix
    transpose: function(matrix: SWMatrix): SWMatrix
    -- Returns an identity matrix
    identity: function(): SWMatrix
    -- Converts radians to the x axis rotation in a matrix. Doesn't rotate the orientation. Rotates the point around the center of the world (0,0,0)
    rotationX: function(radians: number): SWMatrix
    -- Converts radians to the y axis rotation in a matrix
    rotationY: function(radians: number): SWMatrix
    -- Converts radians to the z axis rotation in a matrix
    rotationZ: function(radians: number): SWMatrix
    -- Returns your x,y,z points as a matrix
    translation: function(x: number, y: number, z: number): SWMatrix
    -- Returns x,y,z when given a matrix
    position: function(matrix: SWMatrix): number, number, number
    -- Returns the distance in meters between two matrices in 3D space
    distance: function(matrix1: SWMatrix, matrix2: SWMatrix): number
    -- Multiplies a matrix by a vec 4.
    multiplyXYZW: function(matrix1: SWMatrix, x: number, y: number, z: number, w: number): number, number, number, number
    -- Returns the rotation required to face an X Z vector
    rotationToFaceXZ: function(x: number, z: number): SWMatrix
end

-- A table containing debug-related functions. Only `debug.log` exists for now.<br>
global record debug
    -- Log a message to the console output
    log: function(message: string)
end

-- A table containing most of addon lua's functions.
global record server
    -- Get the internal index of an active addon (useful if you want to spawn objects from another script). Omitting the name argument will return this addon's index
    getAddonIndex: function(name: string|nil): number, boolean
    ---@deprecated, alias for getAddonIndex
    getPlaylistIndexCurrent: function(name: string|nil): number, boolean
    -- Get the internal index of a location in the specified addon by its name (this index is local to the addon)
    getLocationIndex: function(addon_index: number, name: string): number
    -- The name of the location as it appears in the addon
    spawnThisAddonLocation: function(name: string): boolean
    ---@deprecated, alias for spawnThisAddonLocation
    spawnThisPlaylistMissionLocation: function(name: string): boolean
    -- Directly spawn a location by a name from the current addon, optional matrix parameter
    spawnNamedAddonLocation: function(name: string, matrix: SWMatrix): number, boolean
    -- Spawn a mission location at the given matrix
    spawnAddonLocation: function(matrix: SWMatrix, addon_index: number, location_index: number): SWMatrix, boolean
    -- Get the filepath of a addon
    getAddonPath: function(addon_name: string, is_rom: boolean): string, boolean
    -- Returns a list of all env mod zones
    getZones: function(tag: string|nil): {number:SWZone}
    -- Returns whether the matrix is within an env mod zone that matches the display name
    isInZone: function(matrix: SWMatrix, zone_display_name: string): boolean, boolean
    -- Returns the amount of addons that are enabled on this save
    getAddonCount: function(): number
    ---@deprecated, alias for getAddonCount
    getPlaylistCount: function(): number
    -- Returns data about the addon
    getAddonData: function(addon_index: number): SWAddonData
    ---@deprecated, alias for getAddonData
    getPlaylistData: function(addon_index: number): SWAddonData
    -- Returns data on a specific location in the addon
    getLocationData: function(addon_index: number, location_index: number): SWLocationData, boolean
    -- Returns data on a specific mission component. returned data includes component_id which can be used with server.spawnVehicle()
    getLocationComponentData: function(addon_index: number, location_index: number, component_index: number): SWAddonComponentData, boolean
    -- ?
    spawnAddonComponent: function(matrix: SWMatrix, addon_index: number, location_index: number, component_index: number, parent_vehicle_id: number|nil): SWAddonComponentSpawned, boolean
    ---@deprecated, aliased to spawnAddonComponent
    spawnMissionComponent: function(matrix: SWMatrix, addon_index: number, location_index: number, component_index: number, parent_vehicle_id: number|nil): SWAddonComponentSpawned, boolean
    -- Messages player(s) using the in-game chat
    announce: function(name: string, message: string, peerID: number|nil)
    -- Sends a command that can be recieved by addons using the onCustomCommand callback
    command: function(message: string)
    -- Displays a notification for player(s) on the right side of the screen.
    notify: function(peerID: number, title: string, message: string, notificationType: integer) --SWNotificationTypeEnum
    -- Gets a unique ID to be used with other UI functions. Functions similar to a vehicle ID. A UI id can be used for multiple lines and map objects but each popup with a different text or position must have it's own ID
    getMapID: function(): integer
    -- Remove any UI type created with this ui_id. If you have drawn multiple lines on the map with one UI id, this command would remove all of them.
    removeMapID: function(peer_id: number, ui_id: integer)
    -- Add a map marker for the specified peer(s). x, z represent the worldspace location of the marker, since the map is 2D a y coordinate is not required. If POSITION_TYPE is set to 1 or 2 (vehicle or object) then the marker will track the object/vehicle of object_id/vehicle_id and offset the position by parent_local_x, parent_local_z.
    addMapObject: function(peer_id: number, ui_id: integer, position_type: SWPositionTypeEnum, marker_type: SWMarkerTypeEnum, x: number, z: number, parent_local_x: number, parent_local_z: number, vehicle_id: number, object_id: number, label: string, radius: number, hover_label: string, r: number, g: number, b: number, a: number)
    -- Removes the map objects with the specified ui_id for the specified peer(s)
    removeMapObject: function(peer_id: number, ui_id: integer)
    -- Adds a map label for the specified peer(s). Map labels appear under fog of war.
    addMapLabel: function(peer_id: number, ui_id: integer, LABEL_TYPE: SWLabelTypeEnum, name: string, x: number, z: number)
    -- Removes a map label with the specified ui_id for the specified peer(s)
    removeMapLabel: function(peer_id: number, ui_id: integer)
    -- Adds a map line between two world space matrices with the specified ui_id for the specified pee(s). Custom colour defaults to red.
    addMapLine: function(peer_id: number, ui_id: integer, start_matrix: SWMatrix, end_matrix: SWMatrix, width: number, r: number, g: number, b: number, a: number)
    -- Removes a map line with the specified ui_id for the specified peer(s)
    removeMapLine: function(peer_id: number, ui_id: integer)
    -- Displays a tooltip-like popup either in the world. If the popup does not exist, it will be created.
    setPopup: function(peer_id: number, ui_id: integer, name: string, is_show: boolean, text: string, x: number, y: number, z: number, render_distance: number, vehicle_parent_id: number, object_parent_id: number)
    -- Creates a popup that appears on the player's screen, regardless of their look direction and location in the world.
    setPopupScreen: function(peer_id: number, ui_id: integer, name: string|nil, is_show: boolean, text: string, horizontal_offset: number, vertical_offset: number)
    -- Will remove popups that have been assigned to a player
    removePopup: function(peer_id: number, ui_id: integer)
    -- ?
    getPlayers: function(): {number:SWPlayer}
    -- Returns the display name of the player
    getPlayerName: function(peer_id: number): string, boolean
    -- Returns the position of the requested player as a matrix
    getPlayerPos: function(peer_id: number): SWMatrix, boolean
    -- Moves the player from their current location to the matrix provided
    setPlayerPos: function(peer_id: number, matrix: SWMatrix): boolean
    -- This can only be called after a user has been in the server for a few seconds. Returns the direction the player is looking in. A player sitting in a seat will have their look direction reported relative to the seat. If the seat is upside down, looking "up" is down relative to the world. math.atan(x,z) will return the heading the player is facing.
    getPlayerLookDirection: function(peer_id: number): number, number, number, boolean
    -- Returns the id of the player's character
    getPlayerCharacterID: function(peer_id: number): number, boolean
    -- Spawns an object at the specified matrix
    spawnObject: function(matrix: SWMatrix, object_type: integer): number, boolean --SWObjectTypeEnum
    -- Spawns a fire at the given matrix. Can spawn explosions
    spawnFire: function(matrix: SWMatrix, size: number, magnitude: number, is_lit: boolean, is_explosive: boolean, parent_vehicle_id: number, explosion_magnitude: number): number, boolean
    -- Spawns an NPC.
    spawnCharacter: function(matrix: SWMatrix, outfit_id: integer): number, boolean --SWOutfitTypeEnum
    -- Spawns an animal (whale, shark, kraken.)
    spawnAnimal: function(matrix: SWMatrix, animal_type: number, size_multiplier: number): number, boolean --SWAnimalTypeEnum
    -- Requires Industrial Frontier DLC, Spawns a specified creature.
    spawnCreature: function(matrix: SWMatrix, creature_type: integer, size_multiplier: number): number, boolean --SWCreatureTypeEnum
    -- Requires Industrial Frontier DLC, sets the next target matrix for the creature to path to.
    setCreatureMoveTarget: function(object_id: number, matrix: SWMatrix): boolean
	-- Spawns a dropped equipment item at the specified matrix, with the ability to set some settings of the item
	spawnEquipment: function(matrix: SWMatrix, EQUIPMENT_ID: integer, int: integer, float: number): number, boolean -- SWEquipmentTypeEnum
	-- Despawns objects. Can be used on characters and animals.
	despawnObject: function(object_id: number, is_instant: boolean): boolean
	-- Get the positon of an object/character/animal
	getObjectPos: function(object_id: number): SWMatrix, boolean
	-- Sets the position of an object/character/animalGet the simulating state of a specified object
	getObjectSimulating: function(object_id: number): boolean, boolean
	-- Sets the position of an object/character/animal
	setObjectPos: function(object_id: number, matrix: SWMatrix): boolean
	-- Sets the parameters for a fire
	setFireData: function(object_id: number, is_lit: boolean, is_explosive: boolean)
	-- Returns the is_lit parameter of a fire
	getFireData: function(object_id: number): boolean, boolean
	-- Kills the given character
	killCharacter: function(object_id: number)
	-- Revives the given character
	reviveCharacter: function(object_id: number)
	-- Makes the provided object (character, creature, etc) sit in the first seat found that has a matching name or matching voxel position to that which is provided. Can seat player characters
	setSeated: function(object_id: number, vehicle_id: number, seat_name_or_voxel_x: string|number, voxel_y: number, voxel_z: number)
	-- Deprecated, aliased to setSeated
	setCharacterSeated: function(object_id: number, vehicle_id: number, seat_name_or_voxel_x: string|number, voxel_y: number, voxel_z: number)
	-- Deprecated, aliased to setSeated
	setCreatureSeated: function(object_id: number, vehicle_id: number, seat_name_or_voxel_x: string|number, voxel_y: number, voxel_z: number)
	-- Get object/character data of the specified object_id
	getObjectData: function(object_id: number): SWObjectData|nil, SWCharacterData|nil
	-- Deprecated, aliased to getObjectData
	getCharacterData: function(object_id: number): SWObjectData|nil, SWCharacterData|nil
	-- Get the current vehicle_id for a specified character object
	getCharacterVehicle: function(object_id: number): number, boolean
	-- Sets the various parameters of a character
	setCharacterData: function(object_id: number, hp: number, is_interactable: boolean, is_ai: boolean)
	-- Sets the character's/creature's tooltip. Put after the character's "Pickup" and "Follow" tooltips without a line break.
	setCharacterTooltip: function(object_id: integer, display_name: string)
	-- Deprecated, aliased to setCharacterToolTip
	setCreatureTooltip: function(object_id: integer, display_name: string)
	-- Set the equipment a character has
	setCharacterItem: function(object_id: number, slot: integer, EQUIPMENT_ID: integer, is_active: boolean, integer_value: number|nil, float_value: number|nil): boolean --slot SWSlotNumberEnum, EQUIPMENT_ID SWEquipmentTypeEnum, 
	-- Returns the id of the equipment that the character has in the provided slot
	getCharacterItem: function(object_id: number, SLOT_NUMBER: integer): number, boolean --SWSlotNumberEnum
	-- Spawns a vehicle that is in an addon
	spawnAddonVehicle: function(matrix: SWMatrix, addon_index: number, component_id: number): number, boolean, {integer:integer}, number

-- Spawns a vehicle from your vehicle save folder. NOTE: will spawn an "empty" vehicle if a vehicle file cannot be found. It is impossible to distinguish from an actual vehicle server-wise.
---@param matrix SWMatrix The matrix the vehicle should be spawned at
---@param save_name string The name of the save file to spawn
---@return number primary_vehicle_id, boolean is_success, table<integer, integer> vehicle_ids, number group_id
spawnVehicle: function(matrix: SWMatrix, save_name: string): number, boolean, 

---@deprecated
server.spawnVehicleSaveFile = server.spawnVehicle

-- Despawns a vehicle from the world
---@param vehicle_id number The unique id of the vehicle
---@param is_instant boolean If the vehicle should be despawned instantly (true) or when no one is near (false)
---@return boolean is_success
despawnVehicle: function(vehicle_id, is_instant)

-- Returns the position of the vehicle as a matrix, If the specified voxel is part of a sub-body, it will properly apply the previous' sub-body positions (As of v1.8.5)
---@param vehicle_id number The unique id of the vehicle
---@param voxel_x number? 0 is the center of the vehicle (viewable with the move tool). Each "block" or 0.25m is a different voxel. 0.25 is one block right of the start point.
---@param voxel_y number? 0 is the center of the vehicle (viewable with the move tool). Each "block" or 0.25m is a different voxel. 0.25 is one block above the start point.
---@param voxel_z number? 0 is the center of the vehicle (viewable with the move tool). Each "block" or 0.25m is a different voxel. 0.25 is one block forwards of the start point.
---@return SWMatrix matrix, boolean is_success
getVehiclePos: function(vehicle_id, voxel_x, voxel_y, voxel_z)

-- Teleports a vehicle from it's current locaiton to the new matrix
---@param vehicle_id number The unique id of the vehicle
---@param matrix SWMatrix The matrix to be applied to the vehicle
setVehiclePos: function(vehicle_id, matrix)

-- Teleports a vehicle from it's current locaiton to the new matrix. The vehicle is displaced by other vehicles at the arrival point
---@param vehicle_id number The unique id of the vehicle
---@param matrix SWMatrix The matrix to be applied to the vehicle
---@return boolean is_success, SWMatrix result_matrix
setVehiclePosSafe: function(vehicle_id, matrix)

-- Reloads the vehicle as if spawning from a workbench - refreshing damage and inventories etc.
---@param vehicle_id number The unique id of the vehicle
resetVehicleState: function(vehicle_id)

-- Removes all vehicles from the world
cleanVehicles: function()

-- Cleans up fallout zones
clearRadiation: function()

-- Returns a vehicle's data
---@param vehicle_id number The unique id of the vehicle
---@return SWVehicleData vehicle_data, boolean is_success
getVehicleData: function(vehicle_id)

-- Returns all vehicles with a matching name
---@param name string The name to query
---@return table<integer, number> vehicle_ids, boolean is_success
getVehiclesByName: function(name)

-- Returns a vehicle's components
---@param vehicle_id number The unique id of the vehicle
---@return SWLoadedVehicleData vehicle_components, boolean is_success
getVehicleComponents: function(vehicle_id)

-- Returns a table of vehicle IDs that belong to the specified group
---@param group_id number The unique id of the group
---@return table<integer, integer> vehicle_ids, boolean is_success
getVehicleGroup: function(group_id)

-- Despawns all vehicles belonging to the specified group
---@param group_id number The unique id of the group
---@param is_instant boolean If the group should be despawned instantly (true) or when no one is near (false)
---@return boolean is_success
despawnVehicleGroup: function(group_id, is_instant)

-- Teleports a group
---@param group_id number The unique id of the group
---@param transform_matrix SWMatrix The position to teleport the group to
---@return boolean is_success
setGroupPos: function(group_id, transform_matrix)

-- Move a group. Doesn't unload then load the group vehicles
---@param group_id number The unique id of the group
---@param transform_matrix SWMatrix The position to move the group to
---@return boolean is_success
moveGroup: function(group_id, transform_matrix)

-- Moves a group, displacing the target position if a vehicle is blocking the destination
---@param group_id number The unique id of the group
---@param transform_matrix SWMatrix The position to move the group to
---@return boolean is_success, SWMatrix result_matrix
moveGroupSafe: function(group_id, transform_matrix)

-- Move a vehicle. Doesn't unload then load the vehicle
---@param vehicle_id number The unique id of the vehicle
---@param transform_matrix SWMatrix The position to move the vehicle to
---@return boolean is_success
moveVehicle: function(vehicle_id, transform_matrix)

-- Moves a vehicle, displacing the target position if a vehicle is blocking the destination
---@param vehicle_id number The unique id of the vehicle
---@param transform_matrix SWMatrix The position to move the vehicle to
---@return boolean is_success, SWMatrix result_matrix
moveVehicleSafe: function(vehicle_id, transform_matrix)

-- Teleports a group, displacing the target position if a vehicle is blocking the destination
---@param group_id number The unique id of the group
---@param transform_matrix SWMatrix The position to teleport the group to
---@return boolean is_success, SWMatrix result_matrix
setGroupPosSafe: function(group_id, transform_matrix)

-- Converts a world transform to an astronomy transform. Useful for navigating in space
---@param transform_matrix SWMatrix
---@return SWMatrix
getAstroPos: function(transform_matrix)

-- Returns the tank data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param tank_name string The name of the fuel tank as it appears on the vehicle. Editable using the select tool in the workbench
---@return SWVehicleTankData data, boolean is_success
getVehicleTank: function(vehicle_id, tank_name)

-- Gets a vehicle's sign data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique ID of the vehicle to get the sign on
---@param sign_name string The name of the sign to get
---@return SWVehicleSignData data, boolean is_success
getVehicleSign: function(vehicle_id, sign_name)

-- Gets a vehicle's seat data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique ID of the vehicle to get the seat on
---@param seat_name string The name of the seat to get
---@return SWVehicleSeatData data, boolean is_success
getVehicleSeat: function(vehicle_id, seat_name)

-- Returns the button data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param button_name string The name of the button as it appears on the vehicle. Editable using the select tool in the workbench
---@return SWVehicleButtonData data, boolean is_success
getVehicleButton: function(vehicle_id, button_name)

-- Returns the dial data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param dial_name string The name of the dial as it appears on the vehicle. Editable using the select tool in the workbench
---@return SWVehicleDialData value, boolean is_success
getVehicleDial: function(vehicle_id, dial_name)

-- Returns the battery data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param battery_name string The name of the battery as it appears on the vehicle. Editable using the select tool in the workbench
---@return SWVehicleBatteryData data, boolean is_success
getVehicleBattery: function(vehicle_id, battery_name)

-- Returns the hopper data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The vehicle ID to get the hopper from
---@param hopper_name string The name of the hopper to get
---@return SWVehicleHopperData data, boolean is_success
getVehicleHopper: function(vehicle_id, hopper_name)

-- Returns the weapon vehicle data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param weapon_name string The name of the weapon as it appears on the vehicle. Editable using the select tool in the workbench
---@return SWVehicleWeaponData data, boolean is_success
getVehicleWeapon: function(vehicle_id, weapon_name)

-- Returns the vehicle's rope anchor data
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param name string The name of the rope anchor as it appears on the vehicle. Editable using the select tool in the workbench
---@return SWVehicleRopeHookData data, boolean is_success
getVehicleRopeHook: function(vehicle_id, name)

-- Allows direct inputs to a chair from addon Lua
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number, axis_ws: number, axis_da: number, axis_ud: number, axis_rl: number, button_1: boolean, button_2: boolean, button_3: boolean, button_4: boolean, button_5: boolean, button_6: boolean, trigger: boolean)
---@param vehicle_id number The unique id of the vehicle
---@param seat_name string The name of the seat as it apears on the vehicle. Editable using the select tool in the workbench
---@param axis_ws number The W/S axis as it appears on the chair
---@param axis_da number The D/A axis as it appears on the chair
---@param axis_ud number The Up/Down axis as it appears on the chair
---@param axis_rl number The Right/Left axis as it appears on the chair
---@param button_1 boolean The chair button 1 state
---@param button_2 boolean The chair button 2 state
---@param button_3 boolean The chair button 3 state
---@param button_4 boolean The chair button 4 state
---@param button_5 boolean The chair button 5 state
---@param button_6 boolean The chair button 6 state
---@param trigger boolean The chair trigger state
setVehicleSeat: function(vehicle_id, seat_name, axis_ws, axis_da, axis_ud, axis_rl, button_1, button_2, button_3, button_4, button_5, button_6, trigger)

-- Presses a button on a vehicle. Warning, can cause massive lag. Also note: Static vehicles can output values even when not powered
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number)
---@param vehicle_id number The unique id of the vehicle
---@param button_name string The name of the button as it appears on the vehicle. Editable using the select tool in the workbench
pressVehicleButton: function(vehicle_id, button_name)

-- Sets a keypad's value
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number, value: number)
---@param vehicle_id number The unique id of the vehicle
---@param keypad_name string The name of the keypad as it appears on the vehicle. Editable using the select tool in the workbench
---@param value number The value you want to set the keypad to
setVehicleKeypad: function(vehicle_id, keypad_name, value)

-- Fills a fluid tank with the specified liquid
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number, amount: number, FLUID_TYPE: SWTankFluidTypeEnum)
---@param vehicle_id number The unique id of the vehicle
---@param tank_name string The name of the tank as it appears on the vehicle. Editable using the select tool in the workbench
---@param amount number The amount you want to fill the tank in litres
---@param FLUID_TYPE SWTankFluidTypeEnum number for fuel type
setVehicleTank: function(vehicle_id, tank_name, amount, FLUID_TYPE)

-- Sets the charge level of the battery
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number, amount: number)
---@param vehicle_id number The unique id of the vehicle
---@param battery_name string The name of the battery as it appears on the vehicle. Editable using the select tool in the workbench
---@param amount number The amount you want to fill the battery to
setVehicleBattery: function(vehicle_id, battery_name, amount)

-- Sets the number of coal objects inside a hopper
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number, amount: number, RESOURCE_TYPE: SWResourceTypeEnum)
---@param vehicle_id number The vehicle ID to set the hopper on
---@param hopper_name string The name of the hopper to set
---@param amount number The amount to set the hopper to
---@param RESOURCE_TYPE SWResourceTypeEnum The resource type to set inside the hopper
setVehicleHopper: function(vehicle_id, hopper_name, amount, RESOURCE_TYPE)

-- Sets the charge level of the weapon
---@overload fun(vehicle_id: number, voxel_x: number, voxel_y: number, voxel_z: number, amount: number)
---@param vehicle_id number The unique id of the vehicle
---@param weapon_name string The name of the weapon as it appears on the vehicle. Editable using the select tool in the workbench
---@param amount number The amount you want to fill the ammo to
setVehicleWeapon: function(vehicle_id, weapon_name, amount)

-- Spawns a rope of the specified type between two rope anchors specified on the vehicles at their specified voxel position
---@param vehicle_id_1 number the first vehicle's id
---@param voxel_x_1 number the x position of the first vehicle's rope anchor
---@param voxel_y_1 number the y position of the first vehicle's rope anchor
---@param voxel_z_1 number the z position of the first vehicle's rope anchor
---@param vehicle_id_2 number the second vehicle's id
---@param voxel_x_2 number the x position of the second vehicle's rope anchor
---@param voxel_y_2 number the y position of the second vehicle's rope anchor
---@param voxel_z_2 number the z position of the second vehicle's rope anchor
---@param length number the length of the rope
---@param ROPE_TYPE SWRopeTypeEnum the type of the rope
spawnVehicleRope: function(vehicle_id_1, voxel_x_1, voxel_y_1, voxel_z_1, vehicle_id_2, voxel_x_2, voxel_y_2, voxel_z_2, length, ROPE_TYPE)

-- Returns the amount of surfaces that are on fire
---@param vehicle_id number The unique id of the vehicle
---@return number surface_count, boolean is_success
getVehicleFireCount: function(vehicle_id)

-- Shows the text when looked directly at. Blocks with unique tooltips such as buttons will override this tooltip
-- <br>*Only works on vehicles where "show on map" is off. (needs confirmation)*
-- <br>**Use of `<` or `>` may result in the string not being parsed properly**
---@param vehicle_id number The unique id of the vehicle
---@param text string The text that will appear in the tooltip
---@return boolean is_success
setVehicleTooltip: function(vehicle_id, text)

-- Applies impact damage to a vehicle at the specified voxel location
-- <br>Negative values repair the vehicles instead of damaging it
---@param vehicle_id number The ID of the vehicle to apply damage to
---@param amount number The amount of damage to apply (0-100)
---@param voxel_x number The voxel's X position to apply damage to
---@param voxel_y number The voxel's Y position to apply damage to
---@param voxel_z number The voxel's Z position to apply damage to
---@param radius number the radius to apply the damage over, in metres.
---@return boolean is_success
addDamage: function(vehicle_id, amount, voxel_x, voxel_y, voxel_z, radius)

-- Returns whether the specified vehicle has finished loading and is simulating.
---@param vehicle_id number The unique id of the vehicle
---@return boolean is_simulating, boolean is_success
getVehicleSimulating: function(vehicle_id)

-- Returns whether the specified vehicle is loading, simulating or unloading
---@param vehicle_id number The unique id of the vehicle
---@return string is_local, boolean is_success
getVehicleLocal: function(vehicle_id)

-- Will set the vehicle's transponder state. If a transponder does not exist on the vehicle, an invisible one will be created.
---@param vehicle_id number The unique id of the vehicle
---@param is_active boolean Turns the transponder on/off
---@return boolean is_success
setVehicleTransponder: function(vehicle_id, is_active)

-- Allows a vehicle to be edited. NOTE: the vehicle will only be editable when next to a workbench. You can see it on the map but cannot teleport or remove it.
---@param vehicle_id number The unique id of the vehicle
---@param is_editable boolean Sets whether or not the vehicle is able to be edited
---@return boolean is_success
setVehicleEditable: function(vehicle_id, is_editable)

-- Sets a vehicle to invulnerable
---@param vehicle_id number The unique id of the vehicle
---@param is_invulnerable boolean Sets whether or not the vehicle is immune to damage
---@return boolean is_success
setVehicleInvulnerable: function(vehicle_id, is_invulnerable)

-- Sets a vehicle to show on the map
---@param vehicle_id number The ID of the vehicle to show/hide on map
---@param is_show_on_map boolean Whether to show/hide the vehicle on the map
---@return boolean is_success
setVehicleShowOnMap: function(vehicle_id, is_show_on_map)

-- Sets the AI state of a character
---@param object_id number The unique id of the character
---@param AI_STATE number **Ship Pilot**: 0 = none, 1 = path to destination<br>**Heli Pilot**: 0 = None, 1 = path to destination, 2 = path to destination (accurate), 3 = gun run<br>**Plane Pilot**: 0 = none, 1 = path to destination, 2 = gun run<br>**Gunner**: 0 = none, 1 = fire at target<br>**Designator**: 0 = none, 1 = aim at target
setAIState: function(object_id, AI_STATE)

-- Sets the target destination for the AI
---@param object_id number The unique id of the character
---@param matrix_destination SWMatrix|nil The matrix that the AI will try to reach, set nil to clear its target
setAITarget: function(object_id, matrix_destination)

-- Gets the target destination for an AI
---@param object_id number The unique ID of the character object ID
---@return SWTargetData|nil data the data of the AI target, returns nil if fails.
getAITarget: function(object_id)

-- Sets the target charcter for an AI. Different AIs use this data for their unique tasks
---@param object_id number The unique id of the character
---@param target_object_id number|nil target object_id to go target, set nil to clear its target
setAITargetCharacter: function(object_id, target_object_id)

-- Sets the target vehicle for an AI. Different AIs use this data for their unique tasks
---@param object_id number The unique id of the character
---@param target_vehicle_id number|nil target vehicle id to go target, set nil to clear its target
setAITargetVehicle: function(object_id, target_vehicle_id)


-- Get fish data
---@return table<SWResourceTypeEnum, SWFishData>
getFishData: function()

-- Get fish hotspot data
---@return table<integer, SWFishHotSpotData>
getFishHotspots: function()

-- Spawns a tsunami
---@param transform_matrix SWMatrix
---@param magnitude number magnitude 0->1
---@return boolean is_success
spawnTsunami: function(transform_matrix, magnitude)

-- Spawns a whirlpool
---@param transform_matrix SWMatrix
---@param magnitude number magnitude 0->1
---@return boolean is_success
spawnWhirlpool: function(transform_matrix, magnitude)

-- Cancels the current gerstner wave even (tsunami or whirlpool)
cancelGerstner: function()

-- Spawns a tornado
---@param transform_matrix SWMatrix
---@return boolean is_success
spawnTornado: function(transform_matrix)

-- Spawns a meteor
---@param transform_matrix SWMatrix
---@param magnitude number magnitude 0->1
---@param is_spawn_tsunami boolean
---@return boolean is_success
spawnMeteor: function(transform_matrix, magnitude, is_spawn_tsunami)

-- Spawns a meteor shower
---@param transform_matrix SWMatrix
---@param magnitude number magnitude 0->1
---@param is_spawn_tsunami boolean
---@return boolean is_success
spawnMeteorShower: function(transform_matrix, magnitude, is_spawn_tsunami)

-- Spawns a volcano
---@param transform_matrix SWMatrix
---@return boolean is_success
spawnVolcano: function(transform_matrix)

-- Gets all volcanos
---@return table<number, SWVolcano> volcanos
getVolcanos: function()

-- Gets the blended oil amount at the target location.
---@param transform_matrix SWMatrix the position where you want to get the oil amount at
---@return number oil_amount the amount of oil at the specified matrix.
getOilSpill: function(transform_matrix)

-- Sets the oil spill amount at the target location. The amount is blended across nearby tiles.
---@param transform_matrix SWMatrix the position where you want to set the oil amount at.
---@param amount number the amount of oil you want to set at the specified position.
setOilSpill: function(transform_matrix, amount)

-- Clear all oil spills in the world
clearOilSpill: function()

-- Requires Weapons DLC
---@param transform_matrix SWMatrix
---@param magnitude number 0->1
spawnExplosion: function(transform_matrix, magnitude)

-- Used to set game settings
---@param GameSettingString SWGameSettingEnum
---@param value boolean The game setting state. True or False
setGameSetting: function(GameSettingString, value)

-- Returns a table of the game settings indexed by the GAME_SETTING string, this can be accessed inline eg. server.getGameSettings().third_person
---@return SWGameSettings game_settings
getGameSettings: function()

-- Used to set the money and research points for the player
---@param money number How much money the player will have
---@param research_points number How many research points the player will have
setCurrency: function(money, research_points)

-- Returns how much money the player has
---@return number money
getCurrency: function()

-- Returns how many research points the player has
---@return number research_points
getResearchPoints: function()

-- Returns how many days the player has survived
---@return number days_survived
getDateValue: function()

-- Gets the current game date
---@return number d, number m, number y
getDate: function()

-- Returns the current game time
---@return SWTime clock
getTime: function()

-- Returns the current weather
---@param transform_matrix SWMatrix
---@return SWWeather weather
getWeather: function(transform_matrix)

-- Sets the custom weather override values (0-1).
---@param fog number the amount of global fog (0-1)
---@param rain number the amount of global rain (0-1)
---@param wind number the amount of global wind (0-1)
setWeather: function(fog, rain, wind)

-- Sets the target audio mood. Mood naturally decreases over time
---@param peer_id integer the target peer, -1 for all peers
---@param AUDIO_MOOD SWAudioMoodEnum the selected audio mood (Going below 0 or above 4 will cause CTD)
setAudioMood: function(peer_id, AUDIO_MOOD)

-- Returns the world position of a random ocean tile within the selected search range
---@param matrix SWMatrix The matrix to start the search at
---@param min_search_range number The mininum search range relative to the provided matrix. In meters
---@param max_search_range number The maximum search range relative to the provided matrix. In meters
---@return SWMatrix matrix, boolean is_success
getOceanTransform: function(matrix, min_search_range, max_search_range)

-- Gets the ocean floor level of the tile on that matrix, does not include mesh height (eg: land)
-- <br>Example return value: `-375`
---@param transform_matrix SWMatrix the position to get the ocean floor of
---@return number height the ocean floor of the tile at the provided matrix.
getOceanFloor: function(transform_matrix)

-- Returns the world position of a random tile of type tile_name closest to the supplied location
---@param transform_matrix SWMatrix The matrix to find the tile near
---@param tile_name string The name of the tile to find
---@param search_radius number|nil The radius in which to find the tile. Max is 50000
---@return SWMatrix transform_matrix, boolean is_success
getTileTransform: function(transform_matrix, tile_name, search_radius)

-- Returns the data for the tile at the specified location
---@param transform SWMatrix The matrix to get the tile data for
---@return SWTileData tile_data, boolean is_success
getTile: function(transform)

-- Returns the data for the tile selected at the start of the game
---@return SWStartTile tile_data, boolean is_success
getStartTile: function()

---@deprecated
server.getStartIsland = server.getStartTile

-- Returns whether the tile at the given world coordinates is player owned
---@param matrix SWMatrix The matrix the tile can be found at. Doesn't have to be exact, just has to be within the tile.
---@return boolean is_purchased
getTilePurchased: function(matrix)

-- Returns the current inventory amounts for the tile resource depot.
---@param matrix SWMatrix the matrix of the target tile to get the inventory of
---@return number coal the amount of coal in this tile's inventory
---@return number uranium the amount of uranium in this tile's inventory
---@return number diesel the amount of diesel in this tile's inventory
---@return number jet_fuel the amount of jet_fuel in this tile's inventory
---@return number solid_propellant the amount of solid_propellant in this tile's inventory
getTileInventory: function(matrix)

-- Sets the inventory amounts for the tile resource depot.
---@param matrix SWMatrix the matrix of the target tile to set the inventory of
---@param coal number the amount of coal to set in this tile's inventory
---@param uranium number the amount of uranium to set in this tile's inventory
---@param diesel number the amount of diesel to set in this tile's inventory
---@param jet_fuel number the amount of jet_fuel to set in this tile's inventory
---@param solid_propellant number the amount of solid_propellant to set in this tile's inventory
setTileInventory: function(matrix, coal, uranium, diesel, jet_fuel, solid_propellant)


-- Returns whether the object transform is within a custom zone of the selected size
---@param matrix_object SWMatrix The matrix of the object
---@param matrix_zone SWMatrix The matrix of the zone to search within
---@param zone_size_x number The size of the zone. Refer to World Space
---@param zone_size_y number The size of the zone. Refer to World Space
---@param zone_size_z number The size of the zone. Refer to World Space
---@return boolean is_in_area
isInTransformArea: function(matrix_object, matrix_zone, zone_size_x, zone_size_y, zone_size_z)

a: -- table of waypoints that form a path from start to, tags should be seperated by commas with no spaces.
---@param matrix_start SWMatrix The starting point of the path. Refer to World Space
---@param matrix_end SWMatrix The ending point of the path. Refer to World Space
---@param required_tags string The tags a graph node must have to be used.
---@param avoided_tags string The tags it will avoid if a graph node has it. (To omit provide a empty string "")
---@return table<number, SWPathFindPoint> position_list
pathfind: function(matrix_start, matrix_end, required_tags, avoided_tags)

a: -- table of waypoints tagged with ocean_path, that form a path from start to. This functions the same as passing "ocean_path" as a required tag to server.pathfind().
---@param matrix_start SWMatrix The starting point of the path. World Space
---@param matrix_end SWMatrix The ending point of the path. World Space
---@return table<number, SWPathFindPoint> position_list
pathfindOcean: function(matrix_start, matrix_end)

-- Returns a table of all of the oil deposits in the world.
---@return table<integer, SWOilDepositData> oil_deposits the oil deposits in this world.
getOilDeposits: function()

-- Limited to one request per 2 ticks (32 requests/s). Any additional requests will be queued, (requests to port 0 will result in a return to all addons, with the request sent, on the next tick.)
---@param port number The port you are making the request on
---@param request string The URL to make the request to. (4082 chars maximum)
httpGet: function(port, request)

-- Bans a player from your server. There is no way to unban players from that save, choose wisely! A new save will have to be created before a banned player can rejoin.
---@param peer_id number The peer id of the affected player
banPlayer: function(peer_id)

-- Kicks a player from your server. They can rejoin
---@param peer_id number The peer id of the affected player. Kicking -1 will kick the host, closing the server.
kickPlayer: function(peer_id)

-- Makes a player an admin. (Able to kick, ban, auth)
---@param peer_id number The peer id of the affected player
addAdmin: function(peer_id)

-- Removes the admin permissions from a player
---@param peer_id number The peer id of the affected player
removeAdmin: function(peer_id)

-- Gives a player the ability to spawn in vehicles and edit unlocked game settings
---@param peer_id number The peer id of the affected player
addAuth: function(peer_id)

-- Remove the auth permissions from a player
---@param peer_id number The peer id of the affected player
removeAuth: function(peer_id)

-- Send a save command for a dedicated server, with an optional save name parameter
---@param save_name string Name to give the save
save: function(save_name)

-- For random seeding
---@return number system_time milliseconds - may not be reliable sync between different machines
getTimeMillisec: function()

-- Get whether the game considers the tutorial active (Default missions check this before they spawn)
---@return boolean tutorial_completed
getTutorial: function()

-- Sets whether the game considers the tutorial active (useful if you are making your own tutorial)
setTutorial: function()

-- Returns whether or not the user has been informed of the video tutorials that are on the main menu and pause screen.
---@return boolean user_notified
getVideoTutorial: function()

-- Returns true of the host player is a developer of the game.
---@return boolean is_dev
isDev: function()

-- Returns true if the server has the Search and Destroy DLC active.
---@return boolean is_enabled
dlcWeapons: function()

-- Returns true if the server has the Industrial Frontier DLC active.
---@return boolean is_enabled
dlcArid: function()

-- Returns true if the server has the Space DLC active.
---@return boolean is_enabled
dlcSpace: function()

-- Returns the ID of the currently active seasonal event.
---@return SWEventIDEnum EVENT_ID the id of the current event.
getSeasonalEvent: function()

end