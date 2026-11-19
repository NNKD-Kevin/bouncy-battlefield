extends HBoxContainer
@onready var h_box_container: HBoxContainer = $"."
@onready var label: Label = $"../Title"
@onready var options = [$"Option1/AnimatedSprite2D", $Option2/AnimatedSprite2D, $Option3/AnimatedSprite2D]

#Description
@onready var chicken1: Label = $Option1/Description/Chicken
@onready var crab1: Label = $"Option1/Description/Crab"
@onready var wolf1: Label = $"Option1/Description/Wolf"
@onready var turtle1: Label = $"Option1/Description/Turtle"
@onready var description1=[chicken1,crab1,turtle1,wolf1]
@onready var chicken2: Label = $Option2/Description/Chicken
@onready var crab2: Label = $Option2/Description/Crab
@onready var wolf2: Label = $Option2/Description/Wolf
@onready var turtle2: Label = $Option2/Description/Turtle
@onready var description2=[chicken2,crab2,turtle2,wolf2]
@onready var chicken3: Label = $Option3/Description/Chicken
@onready var crab3: Label = $Option3/Description/Crab
@onready var wolf3: Label = $Option3/Description/Wolf
@onready var turtle3: Label = $Option3/Description/Turtle
@onready var description3=[chicken3,crab3,turtle3,wolf3]
@onready var descriptions=[description1,description2,description3]
var index=0
@onready var center_container: CenterContainer = $"../../CenterContainer"
@onready var upcoming_sprite: HBoxContainer = $"../../Upcoming Enemy2/Upcoming_sprite"
@onready var upcoming: Label = $"../../Upcoming Enemy2/Upcoming"
const ENEMY_TYPES = ["crab", "chick", "wolf", "turtle","pig"]
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


var choices=[]
func choose():
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
	index=0
	for sprite in options:
		var gacha=randi_range(1,5)
		if sprite:
			if gacha==1:
				sprite.play('Chicken')
				choices.append('chick')
				if descriptions[index][0]:descriptions[index][0].visible=true
			elif gacha==2:
				sprite.play('Crab')
				choices.append('crab')
				if descriptions[index][1]:descriptions[index][1].visible=true
			elif gacha==3:
				sprite.play('Turtle')
				choices.append('turtle')
				if descriptions[index][2]:descriptions[index][2].visible=true
			elif gacha==4:
				sprite.play('Wolf')
				choices.append('wolf')
				if descriptions[index][3]:descriptions[index][3].visible=true
			elif gacha==5:
				sprite.play("Pig")
				choices.append('pig')
		index+=1
	for i in range(Global.level):
		Global.enemies.append(ENEMY_TYPES.pick_random())
	for i in range(Global.level):
		if Global.enemies[i]=='chick':
			upcomings[i].play("Chicken")
		if Global.enemies[i]=='crab':
			upcomings[i].play("Crab")
		if Global.enemies[i]=='turtle':
			upcomings[i].play("Turtle")
		if Global.enemies[i]=='wolf':
			upcomings[i].play("Wolf")
		if Global.enemies[i]=='pig':
			upcomings[i].play("Pig")
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
		for i in description:
			i.hide()
	Global.ready_to_start = true
func _pick(i: int):
	Global.animals.append(choices[i])
	hideall()
	if center_container:
		center_container.visible = true

func _on_option_1_pressed() -> void: _pick(0)
func _on_option_2_pressed() -> void: _pick(1)
func _on_option_3_pressed() -> void: _pick(2)
