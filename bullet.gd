extends Area2D

@export var speed = 1000

var velocity = Vector2.ZERO

func start(_transform):
	transform = _transform
	velocity = transform.x * speed

func _process(delta):
	position += velocity * delta

func onVisibleOnScreenNotifier2DScreenExited() -> void:
	queue_free()

func onBulletBodyEntered(body: Node2D) -> void:
	if body.is_in_group("rocks"):
		body.explode()
		queue_free()

func onEnemyAreaEntered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.takeDamage(1)
