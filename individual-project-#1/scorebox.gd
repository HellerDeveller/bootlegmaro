extends Block

class_name ScoreBox

var coin_score = 100
enum Bonus {COIN, SHROOM, FLOWER}
const COIN_SCENE = preload("res://coin.tscn")
@export var bonus: Bonus = Bonus.COIN
var is_empty = false

func _ready():
	$Sprite2D.frame = 0

func bump():
	if is_empty == true:
		return
	emptify()
	super.bump()
	
	match bonus:
		Bonus.COIN:
			spawn_coin()
		Bonus.SHROOM:
			spawn_shroom()
		Bonus.FLOWER:
			spawn_flower()
	

func emptify():
	is_empty = true
	$Sprite2D.frame = 1

func spawn_coin():
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position + Vector2(0, -16)
	get_tree().root.add_child(coin)

func spawn_shroom():
	pass

func spawn_flower():
	pass
