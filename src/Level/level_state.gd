class_name LevelState

extends Resource

# Represents the state of the level
# Carries the level configuration but also holds game context information

var level_data: LevelData  # Config of the level

var nb_coins := GameState.nb_coins


func _init(level_data_p: LevelData):
	self.level_data = level_data_p
