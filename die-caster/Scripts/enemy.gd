class_name Enemy
extends Node2D

@export var hp_bar : ProgressBar
@export var max_hp = 100

@export var requirement_pool:Array[PackedScene]

@export var quirk_chance = 0.33
@export var quirk_pool:Array[PackedScene]

var current_hp

func _ready() -> void:
	SignalBus.on_roll_succeeded.connect(on_suffer_damage)
	current_hp = max_hp
	
	# Bar Setup
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp

func on_suffer_damage(damage:int):
	current_hp -= damage
	hp_bar.value = current_hp
	
func pull_requirement() ->EnemyReq:
	return requirement_pool.pick_random().instantiate() as EnemyReq

func pull_quirk() -> EnemyReqQuirk:
	if randf() < quirk_chance:
		return quirk_pool.pick_random().instantiate() as EnemyReqQuirk
	else:
		return null
