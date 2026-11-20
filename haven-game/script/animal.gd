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
var mouse_on =false
var dragging=false
var valid=false
var initial_position=Vector2(0,0)
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
const SPIKE_SPEED =200


func _ready() -> void:
	green_style.bg_color = Color.GREEN
	red_style.bg_color = Color.RED
	health_bar.visible=false
	side ='bad' if is_in_group("enemies") else "good"
	data=AnimalData.ANIMALS[type]
	max_hp=data.max_hp
	hp=max_hp
	health_bar.value=hp
	health_bar.max_value=max_hp
	health_bar.add_theme_stylebox_override("fill",red_style if side=='bad' else green_style)
	speed=data.speed
	animation.play(type)
	if side=='bad':
		health_bar.visible=true


func _input(event: InputEvent) -> void:
	if mouse_on and Input.is_action_just_pressed("drag") and side=='good':
		dragging=true
	if Input.is_action_just_released('drag') and dragging and side=='good':
		dragging=false
		queue_redraw()
		var map=AnimalData.MAPS[Global.current_map]
		if map.rect.has_point(position):
			valid=true
		else:
			valid=false
			position=initial_position
	if event.is_action_pressed("start") and not Global.combat and Global.ready_to_start:
		health_bar.visible=true
		if side=='good' and not valid:
			var map=AnimalData.MAPS[Global.current_map]
			position=Vector2(randi_range(map.x_min,map.x_max),randi_range(map.y_min,map.y_max))
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
	if dragging and Global.ready_to_start:
		self.position=get_global_mouse_position()
		queue_redraw()
func _draw() -> void:
	if dragging and Global.ready_to_start:
		var r: Rect2 = AnimalData.MAPS[Global.current_map].rect
		draw_rect(Rect2(to_local(r.position),r.size),Color.GREEN,false,3.0)

func fire(type:String):
	if type=='porcupine':
		for i in range(15):
			var dir=Vector2.RIGHT.rotated(TAU/15*i)
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
	if not Global.combat:
		return
	if hp<=0:
		queue_free()
		return
	if not moving:
		return
	if velocity.x<0:
		animation.flip_h=true
	else:
		animation.flip_h=false
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
					animation.play("porcupine_attack")
	

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


func _on_mouse_entered() -> void:
	mouse_on=true


func _on_mouse_exited() -> void:
	mouse_on=false
