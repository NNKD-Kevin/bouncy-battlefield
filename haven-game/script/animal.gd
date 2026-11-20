extends CharacterBody2D

@onready var health_bar=$HealthBar
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_animation: AnimationPlayer = $AnimatedSprite2D/FlashAnimation
@onready var slap: AudioStreamPlayer2D = $Sounds/slap
@onready var growl: AudioStreamPlayer2D = $Sounds/growl
@onready var cluck: AudioStreamPlayer2D = $Sounds/cluck
@onready var cooldown: Timer = $Node/cooldown
@onready var stun: Timer = $Node/stun
@onready var devour_timer: Timer = $Node/devour_timer
@onready var grow_timer: Timer = $Node/grow_timer


const bounciness:=1.0
var speed=300
var hp=100
var max_hp=100
var damage=15
var type ='crab'
var green_style := StyleBoxFlat.new()
var red_style := StyleBoxFlat.new()
var side =null
var moving=true
var ready_to_hit=true
var data:Dictionary

#Chick
var grown=false
var egg=preload("res://scenes/egg.tscn")
#Wolf
var devour_ready=false
#Pig
var poo=preload("res://scenes/poo.tscn")
const POO_SPEED = 0.0001

#Porcupine
var spike=preload("res://scenes/spike.tscn")
const SPIKE_SPEED =150
func _ready() -> void:
	green_style.bg_color = Color.GREEN
	red_style.bg_color = Color.RED
	side ='bad' if is_in_group("enemies") else "good"
	data=AnimalData.ANIMALS[type]
	max_hp=data.max_hp
	hp=max_hp
	health_bar.value=hp
	health_bar.max_value=max_hp
	health_bar.add_theme_stylebox_override("fill",red_style if side=='bad' else green_style)
	speed=data.speed
	animation.play(type)
	if type=='crab':
		velocity=Vector2.RIGHT.rotated(randi()%2*180)*speed
	else:
		velocity=Vector2.RIGHT.rotated(randf()*TAU)*speed
	match type:
		"chick":grow_timer.start()
		"wolf":devour_timer.start()
		"pig","porcupine":grown=true
func _process(delta: float) -> void:
	health_bar.value=hp
	if type=='wolf' and devour_ready:
		hp-=delta*5
	if Global.sandstorm_on:
		hp-=delta*5

func fire(type:String):
	if type=='porcupine':
		for i in range(12):
			var dir=Vector2.RIGHT.rotated(TAU/12*i)
			var s=spike.instantiate()
			s.velocity=dir*SPIKE_SPEED
			s.rotation=dir.angle()
			s.add_collision_exception_with(self)
			add_collision_exception_with(s)
			get_parent().add_child(s)
			s.global_position=$CollisionShape2D.global_position
		return
	var bullet=null
	if type=='chick':
		bullet = egg.instantiate()
		cluck.play()
		bullet.velocity=velocity
	elif type=='pig':
		bullet= poo.instantiate()
		bullet.velocity=velocity*POO_SPEED
	bullet.add_collision_exception_with(self)
	add_collision_exception_with(bullet)
	bullet.side=side
	bullet.rotation=global_rotation
	bullet.global_position = $CollisionShape2D.global_position
	get_parent().add_child(bullet)

			
	

func _physics_process(delta: float) -> void:
	if hp<=0:
		queue_free()
		return
	if not moving:
		return
	var collision=move_and_collide(velocity*delta)
	if collision and moving:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		var is_enemy=collider is CharacterBody2D and 'side' in collider and collider.side!=side
		match type:
			'crab','turtle':
				if is_enemy and ready_to_hit:
					collider.hp-=15 if type=='crab' else 10
					if type=='crab':animation.play("crab_attack")
					collider.flash_animation.play("flash")
					slap.play()
					ready_to_hit=false
					cooldown.start()
			'wolf':
				if is_enemy and devour_ready:
					devour_ready=false
					devour_timer.start()
					hp=min(max_hp,hp+collider.hp)
					collider.queue_free()
			'chick','pig':
				if not (collider is CharacterBody2D) and grown:
					fire(type)
			'porcupine':
				if is_enemy and ready_to_hit:
					fire(type)


func _on_animation_finished() -> void:
	animation.play(type)


func _on_cooldown_timeout() -> void:
	ready_to_hit=true


func _on_stun_timeout() -> void:
	moving=true


func _on_devour_timer_timeout() -> void:
	devour_ready=true
	growl.play()


func _on_grow_timer_timeout() -> void:
	grown=true
	animation.play("chicken")
	cluck.play()
