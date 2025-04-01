extends Control
var score = 0

func _ready() -> void:
	$Score.text = "Score: 0"
	score = 0
	$HP.text = "HP: 1"

func update_score(x):
	score = score + x
	$Score.text = "Score: %s" % str(score)

func update_hp(x):
	$HP.text = "HP: %s" % str(x)
