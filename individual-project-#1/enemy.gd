extends CharacterBody2D

@export var speed = 150
@export var gravity = 2500
@export var facing = 0

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = facing * speed
	$AnimatedSprite2D.flip_h = velocity.x > 0
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			collision.get_collider().hurt()
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
	if position.y > 1000:
		queue_free()

func take_damage():
	$AnimatedSprite2D.play("dead")
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)

func _on_animated_sprite_2d_animation_finished(animation) -> void:
	if animation == "dead":
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	facing = -1
