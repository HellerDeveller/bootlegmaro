extends CharacterBody2D

@export var speed = 200
@export var gravity = 2500
var facing = 1

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = facing * speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
	if position.y > 1000:
		queue_free()
	

func take_damage():
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
