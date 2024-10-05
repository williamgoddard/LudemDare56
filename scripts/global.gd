extends Node

# Enum for the different room types of a room
enum RoomType {DEFAULT, LADDER, BEDROOM, BATHROOM, KITCHEN}

# Tracks whether the player is currently dragging a tile, so that they cannot drag more than one
var dragging := false
