class_name Player
extends Node2D

@export var hp_bar: ProgressBar

@export var max_hp = 100

var current_hp:int

func _ready() -> void:
	SignalBus.on_roll_failed.connect(on_suffer_damage)
	
	current_hp = max_hp
	
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp

func on_suffer_damage(damage:int):
	current_hp -= damage
	hp_bar.value = current_hp
