extends CharacterBody2D
signal hp_changed
signal score_changed
var score = 0
var hp = 1: set = set_hp
@export var gravity = 2500
@export var run_speed = 450
@export var jump_speed = -1200
enum {IDLE, RUN, HURT, JUMP, DEAD}
var state = IDLE

func _ready() -> void:
	score = 0

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimatedSprite2D.play("default")
		RUN:
			$AnimatedSprite2D.play("walk")
		HURT:
			hp -= 1
			if state != DEAD:
				pity_time()
		JUMP:
			$AnimatedSprite2D.play("airborne")
		DEAD:
			$AnimatedSprite2D.speed_scale = 0.2
			skew = rad_to_deg(150)
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			$agony.start()
			await $agony.timeout
			get_tree().change_scene_to_file.bind("res://custard.tscn").call_deferred()

func get_input():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	velocity.x = 0
	
	if state == DEAD:
		return
	
	if right:
		velocity.x += run_speed
		$AnimatedSprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$AnimatedSprite2D.flip_h = true
	
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	
	for i in get_slide_collision_count(): # collision interactions
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y - 10:
				collision.get_collider().take_damage()
				velocity.y = -500
				score = 100
				score_changed.emit(score)
			else:
				hurt()
		if collision.get_collider().is_in_group("powerup"):
			pass
		if collision.get_collider() is Block:
			var collision_angle = rad_to_deg(collision.get_angle())
			if roundf(collision_angle) == 180:
				(collision.get_collider() as Block).bump()
				if collision.get_collider().is_in_group("scorebox"):
					score = 100
					score_changed.emit(score)
	
	if state == JUMP and is_on_floor():
		change_state(IDLE)
	
	if position.y > 300:
		hp -= 1
		get_tree().change_scene_to_file.bind("res://custard.tscn").call_deferred()

func pity_time():
	$Invul.start()
	modulate.a = 0.5
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	change_state(IDLE)
	await $Invul.timeout
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	modulate.a = 1

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
	hp = 1

func set_hp(x):
	hp = x
	hp_changed.emit(hp)
	if hp <= 0:
		change_state(DEAD)

func hurt():
	if state != HURT:
		change_state(HURT)
