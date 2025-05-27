extends Area2D

@export var bulletScene : PackedScene
@export var speed = 150
@export var rotationSpeed = 120
@export var health = 3
@export var bulletSpread = 0.2

var follow
var target = null

func _ready():
	$Sprite2D.frame = randi() % 3
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.loop = false

func _physics_process(delta):
	rotation += deg_to_rad(rotationSpeed) * delta
	follow.progress += speed * delta
	position = follow.global_position
	if follow.progress_ratio >= 1:
		queue_free()

func shoot():
	var dir = global_position.direction_to(target.global_position)
	dir = dir.rotated(randf_range(-bulletSpread, bulletSpread))
	var b = bulletScene.instantiate()
	get_tree().root.add_child(b)
	b.start(global_position, dir)
	$ShootSound.play()

func shootPulse(n, delay):
	for i in n:
		shoot()
		await get_tree().create_timer(delay).timeout

func takeDamage(amount):
	health -= amount
	$AnimationPlayer.play("flash")
	if health <= 0:
		explode()

func explode():
	$ExplosionSound.play()
	speed = 0
	$GunCoolDown.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	await $Explosion/AnimationPlayer.animation_finished
	queue_free()

func onGunCoolDownTimerTimeout() -> void:
	shootPulse(2, 0.12)

func onEnemyBodyEntered(body):
	if body.is_in_group("rocks"):
		return
	explode()
	body.shield -= 50
