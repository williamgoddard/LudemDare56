extends Node

# Enum for the different room types of a room
enum RoomType {DEFAULT, LADDER, BEDROOM, BATHROOM, KITCHEN}

# Enum for the four cardinal directions
enum Direction {UP, DOWN, LEFT, RIGHT}

# Enum for a character's current desire
enum Desire {NONE, SLEEP, FOOD, TOILET}

# Tracks whether the player is currently dragging a tile, so that they cannot drag more than one
var dragging := false
