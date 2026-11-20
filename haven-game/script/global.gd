extends Node
var battle_started=false
var animals=[]
var enemies=[]
var level=1
var ready_to_start = false
var combat=false
var sandstorm_on=false
var current_map=null
signal arrange
func _ready()->void:
	Engine.time_scale=1.0
func reset_run():
	animals=[]
	enemies=[]
	level=1
	combat=false
	ready_to_start=false
