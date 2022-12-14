extends TileMap

const START_ALIVE_CHANCE = 40 # % chance for tile to begin alive
const MIN_ALIVE = 3 # minimum alive neighbours to stay alive
const MIN_BIRTH = 5 # minimum alive neighbours to become alive

const WALL = 0 # Tile id

# Initialises random grid of wall tiles
func initialise_walls_layer():
	for x in range(Globals.CAVE_SIZE):
		for y in range(Globals.CAVE_SIZE):
			var tile = WALL if GameManager.percent_chance(START_ALIVE_CHANCE) else -1
			
			# Create a border of wall tiles with a width of 3
			if x < 3 or x > Globals.CAVE_SIZE-4 or y < 3 or y > Globals.CAVE_SIZE-4:
				tile = WALL
			
			set_cell(x, y, tile)

# Returns number of alive (wall) neighbours for a given tile
func num_wall_neighbours(tile_x, tile_y) -> int:
	var count = 0
	# Loop through all x and y offsets (-1, 0 and 1)
	for i in range(-1, 2):
		for j in range(-1, 2):
			# Don't count (0,0) as this is the original tile
			if not (i == 0 and j == 0):
				var x = tile_x+i
				var y = tile_y+j
				if get_cell(x, y) == WALL: # If wall increase count
					count += 1
	return count

# Carries out the cellular automaton logic
# Returns whether the cave generation has finished or not (true or false)
func carry_out_generation() -> bool:
	var changed_tiles = [] # Store changes to tilemap
	
	for x in range(Globals.CAVE_SIZE):
		for y in range(Globals.CAVE_SIZE):
			var tile = get_cell(x, y)
			if tile == WALL:
				if num_wall_neighbours(x, y) < MIN_ALIVE: # Tile should "die"
					changed_tiles.append({"x": x, "y": y, "value": -1})
			elif tile != WALL:
				if num_wall_neighbours(x, y) >= MIN_BIRTH: # Tile should be "born"
					changed_tiles.append({"x": x, "y": y, "value": WALL})
	
	# Make changes to tilemap
	for tile in changed_tiles:
		set_cell(tile["x"], tile["y"], tile["value"])
	
	# If no changes were made then the generation is finsihed
	return changed_tiles.empty()

# Adds a border outside the map to make the edges blend in with the cave
func initialise_outside_border():
	for x in range(-1, Globals.CAVE_SIZE+1):
		set_cell(x, -1, WALL)
		set_cell(x, Globals.CAVE_SIZE, WALL)
	
	for y in range(-1, Globals.CAVE_SIZE+1):
		set_cell(-1, y, WALL)
		set_cell(Globals.CAVE_SIZE, y, WALL)
