class_name LevelData

extends Resource

enum LevelType { TILEMAP_EXAMPLE, PLATFORMER_EXAMPLE }

# In this class, put the settings of your level

@export var name := "Level"
@export var timer_duration := 10
@export var type := LevelType.TILEMAP_EXAMPLE
