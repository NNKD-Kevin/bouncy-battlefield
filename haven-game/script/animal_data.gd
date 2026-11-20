extends Node
const ANIMALS={
	"crab":{"max_hp":100,"speed":300},
	"chick":{"max_hp":100,"speed":350},
	"wolf":{"max_hp":100,"speed":300},
	"turtle":{"max_hp":250,"speed":50},
	"pig":{"max_hp":100,"speed":100},
	"porcupine":{"max_hp":100,"speed":200}
}
const ENEMY_TYPES = ["crab", "chick", "wolf", "turtle","pig",'porcupine']
const MAPS={
	"0":{"x_min":250,"x_max":575,"y_min":150,"y_max":500,"rect":Rect2(250,150,325,350)},
	"1":{"x_min":300,"x_max":600,"y_min":200,"y_max":350,"rect":Rect2(300,200,300,150)},
	"2":{"x_min":300,"x_max":600,"y_min":175,"y_max":450,"rect":Rect2(300,150,300,300)}
}


const DESCRIPTIONS	={
"chick":
'CHICKEN:
HP: 100
Ability: Start as a harmless 
chick then grow after 15s
Bounce Edges: shoots egg which 
deals 5 damage to enemy or 
heals 10 HP to allies',

"crab":'CRAB:
HP: 100
Bounce enemies: Deal 20 damage 
to them',

'wolf':
'WOLF:
HP: 100
Ability: Gets hungry every 30s
During hunger: Lose health every 
second. 
Bounce enemies: Devour
them and gain their current HP if 
is hungry',

'turtle':
'Turtle:
HP: 250
Ability: Moves super slowly
Bounce Enemies: Deal 
10 damage on them',

'pig':'Pig',
'porcupine':'Porcupine'

}
