class_name DieEditor

extends Node2D

@export var faces = 6
@export var face_sprite_width = 32
@export var face_sprite_gap = 3

@export var face_parent : Node2D
@export var die_face_packed : PackedScene

@export var face_options : Array

var die_faces : Array
var image : Sprite2D

func _ready() -> void:
	image = get_node("Image")
	setDefaultFaces()

func  _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			rollDie()

func setDefaultFaces():
	var pos_X = (face_sprite_width + face_sprite_gap) * faces
	pos_X = pos_X - face_sprite_width
	pos_X = pos_X /  -2.0
	for i in range(faces):
		var face = die_face_packed.instantiate()
		face_parent.add_child(face)

		var face_data = DieFace.RollData.new()
		face_data.numerical_value = i + 1
		# For faces without an ability the frame = their result (0 = ?)
		face_data.sprite_frame = i + 1
		face_data.effect = DieFace.SpecialEffect.None

		face.setState(face_data)

		face.position.x = pos_X
		pos_X += face_sprite_width+face_sprite_gap

		die_faces.append(face)

		pass

func rollDie():
	var result = die_faces.pick_random()
	print(result.roll_data.numerical_value)
	image.frame = result.roll_data.sprite_frame
	return result.roll_data
