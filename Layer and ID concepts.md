
A significant amount of the game logic can be passed off to the tilemap, its layers, and the tileset IDs. This will be at the cost of map making time, and a little bit of rendering power. However it will vastly simplifiy everything else. 

# Layers

There will be the following layers in the main tilemap:

0. Destroyed tiles          - Place beneath everything so as to not be visible
1. To build tiles           - Also beneath everything for the same reason
2. Water                    - Aesthetic, should never be updated
3. Ground                   - Aesthetic, should never be updated, also marks the places in which things can be built.
4. Irradiated ground        - Marks and displays cells that can never again be built upon
5. Foreground               - Where all buildings, trees, rocks, etc are placed
6. Selection                - Where the player selector icon will be presented

At the start, the "Destroyed tiles" and "Irradiated ground" layers will be empty. As the game progresses and cells are destroyed, buildings will be deleted off of the foreground layer and added to the destroyed tiles layer. As nukes are dropped, irradiated ground will be placed.

When the system attempts to build or re-build a cell, it will choose from the "Destroyed tiles" and "To build tiles" layers, removing them from those layers and placing them on the foreground layer.

# Tileset ID mechanics

The built in function get_used_cells() can be used to determine how many tiles are irradiated, how many are destroyed, etc.

The tileset IDs will be used to determine cell functions, as well as for use in prioritizing how the AI will build. So for instance, ID of 5 may equal "farmland", and using the built in function get_used_cells_by_id(1, 5) would search the destroyed tiles layer for farmlands that have been destroyed, and then it will return a list of locations of where we can rebuild farmlands. This will have the effect of making the AI a little dumb, but as previously stated this will simplifiy the logic for the AI quite a bit.

Important buildings that the AI builds can potentially be softlocked this way. For example if there is a missile silo that the AI has in the "To build tiles" layer, if that gets built, then nuked, the "Irradiated Ground" layer would have cells there, marking the area as unbuildable. So even if the missile silo was sent to the "Destroyed Tiles" layer to later be rebuilt, it could never because the area is marked as unbuildable. Again the get_used_cells_by_id() can help out with this, as well as the "Ground" layer. We can run a search for how many missile silos can be built, and if it is under a threshold, more spots can be chosen for missile silo rebuilding. This is quite a complicated process, and potentialy resource expensive for the machine runnning this, so this should only be done for tileset IDs that the AI is required to have for a win condition. Other tileset IDs should primarily rely on redundancy. 

# Potential tileset IDs
Some potential tileset IDs and functions could include:


0. Selector                         - Player selector icon
1. Animated Selector               - Same as above but animated
2. Earth                            - Where foreground tiles can go
3. Water                            - A tile nothing can be placed on
4. Irradiated_Earth                 - A tile nothing can be placed on
5. Debris                           - An aesthetic tile to be removed before re-building a tile
6. Residential_Building             - Some amount are needed for the AI to be stable and fight back
7. Electric_Infrastructure          - Same as above
8. Farmland                         - Same as above
9. Bomb_Shelter                     - Residential buildings, but somewhat resistant to attacks
10. Missile_Silo                     - An offensive weapon the AI has to attack the player's ship
11. Shield_Generator                - Provides some amount of defense to surrounding buildings
12. Fire_Station                    - Puts out nearby fires
13. Fire                            - Mostly aesthetic, can spread after a period of time
14. Burnable_Nature                 - Trees, plants, shrubs, etc
15. Rocks                           - Mostly aesthetic

Splitting up these tilesets early even if they share the same/similar functions(for instance residential/electric/farmland) will make it easier to give them different effects in the future.

Textures should adhere to the function of a given ID. The tileset IDs will in the end work similarly to the oldschool ID system for blocks in minecraft.