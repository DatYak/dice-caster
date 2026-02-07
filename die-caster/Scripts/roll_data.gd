class_name RollData
extends Resource

#TODO: roll_data should be an object that contains info about the player's roll/attempt:
#	- Player's presented damage if they had succeeded 
#	- Final roll value
#	- Array of each FaceData hit to make roll

var presented_damage:int
var presented_value: int
var faces_rolled:Array

func reset(base_damage:int) ->void:
	presented_damage = base_damage
	presented_value = 0
	faces_rolled.clear()

func addFaceToRoll(face:FaceData):
	presented_value += face.numerical_value
	faces_rolled.append(face)
