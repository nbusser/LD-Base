extends Resource

class_name LevelState

# Represents the state of the level
# Carries the level configuration but also holds game context information

var level_number: int = 0
var level_data: LevelData  # Config of the level

var nb_coins: int = 0  # Coins collected from the beggining of game


func _init(level_number_p: int, level_data_p: LevelData, nb_coins_p: int):
	self.level_number = level_number_p
	self.level_data = level_data_p
	self.nb_coins = nb_coins_p
