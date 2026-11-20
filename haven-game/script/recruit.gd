extends HBoxContainer
@onready var h_box_container: HBoxContainer = $"."
@onready var label: Label = $"../Title"
@onready var options = [$"Option1/AnimatedSprite2D", $Option2/AnimatedSprite2D, $Option3/AnimatedSprite2D]

#Description
@onready var description_1: Label = $Option1/Description1
@onready var description_2: Label = $Option2/Description2
@onready var description_3: Label = $Option3/Description3
@onready var descriptions=[description_1,description_2,description_3]
@onready var center_container: CenterContainer = $"../../CenterContainer"
@onready var upcoming_sprite: HBoxContainer = $"../../Upcoming Enemy2/Upcoming_sprite"
@onready var upcoming: Label = $"../../Upcoming Enemy2/Upcoming"

@onready var u_1: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U1/U1"
@onready var u_2: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U2/U2"
@onready var u_3: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U3/U3"
@onready var u_4: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U4/U4"
@onready var u_5: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U5/U5"
@onready var u_6: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U6/U6"
@onready var u_7: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U7/U7"
@onready var u_8: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U8/U8"
@onready var u_9: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U9/U9"
@onready var u_10: AnimatedSprite2D = $"../../Upcoming Enemy2/Upcoming_sprite/U10/U10"
@onready var upcomings=[u_1,u_2,u_3,u_4,u_5,u_6,u_7,u_8,u_9,u_10]
#buttons
@onready var button: Button = $"../../Time speed/Button"
@onready var button_2: Button = $"../../Time speed/Button2"
@onready var button_3: Button = $"../../Time speed/Button3"
var  cache=[]
var choices=[]
func choose():
	cache=[]
	button.visible = false
	button_2.visible = false
	button_3.visible = false
	h_box_container.visible = true
	if upcoming_sprite:
		upcoming_sprite.visible = true
	if upcoming:
		upcoming.visible = true
	if label:
		label.visible = true
	for option in options:
		if option:
			option.visible=true
	choices=[]
	while len(cache)<3:
		var gacha=randi_range(1,6)
		if gacha not in cache:
			cache.append(gacha)
	for i in range(len(options)):
		var a=cache[i]-1
		var animal=AnimalData.ENEMY_TYPES[a]
		options[i].play(animal)
		choices.append(animal)
		descriptions[i].text=AnimalData.DESCRIPTIONS[animal]
		descriptions[i].visible=true
	for i in range(Global.level):
		Global.enemies.append(AnimalData.ENEMY_TYPES.pick_random())
	for i in range(Global.level):
		upcomings[i].play(Global.enemies[i])
		upcomings[i].visible=true
func _ready():
	for i in upcomings:
		i.visible=false
	choose()
func hideall():
	hide()
	label.hide()
	if upcoming_sprite:
		upcoming_sprite.visible = false
	if upcoming:
		upcoming.visible = false
	for description in descriptions:
		description.hide()
func _pick(i: int):
	Global.animals.append(choices[i])
	hideall()
	if center_container:
		center_container.visible = true
	Global.ready_to_start=true
	Global.arrange.emit()

func _on_option_1_pressed() -> void: _pick(0)
func _on_option_2_pressed() -> void: _pick(1)
func _on_option_3_pressed() -> void: _pick(2)
