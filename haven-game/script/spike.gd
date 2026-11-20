extends CharacterBody2D
class_name Spike
var bounciness=1.0
var side=null
var type='spike'
func _physics_process(delta: float) -> void:
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if collider is CharacterBody2D and (not collider is Spike):
			collider.hp-=10
			collider.flash_animation.play('flash')
		queue_free()
	if not Global.combat:
		queue_free()
			
