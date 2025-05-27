extends Area2D

@export var speed = 800
@export var damage = 15

func start(_pos, _dir):
	position = _pos
	rotation = _dir.angle()

func _process(delta):
	position += transform.x * speed * delta

func onEnemyBulletBodyEntered(body):
	if body.name == "Player":
		body.shield -= damage
	queue_free()

func onVisibleOnScreenNotifier2DScreenExited():
	queue_free()
