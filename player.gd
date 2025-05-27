extends RigidBody2D

signal livesChanged
signal shieldChanged
signal dead

@export var bulletScene : PackedScene
@export var enginePower = 500
@export var spinPower = 8000
@export var fireRate = 0.25
@export var maxShield = 100.0
@export var shieldRegen = 5.0

enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT
var thrust = Vector2.ZERO
var rotationDir = 0
var screenSize = Vector2.ZERO
var canShoot = true
var resetPos = false
var lives = 0: set = setLives
var shield = 0: set = setShield

func _ready():
	changeState(INIT)
	screenSize = get_viewport_rect().size
	$GunCoolDown.wait_time = fireRate

func setShield(value):
	value = min(value, maxShield)
	shield = value
	shieldChanged.emit(shield / maxShield)
	if shield <= 0:
		lives -= 1
		explode()

func setLives(value):
	lives = value
	shield = maxShield
	livesChanged.emit(lives)
	if lives <= 0:
		changeState(DEAD)
	else:
		changeState(INVULNERABLE)

func reset():
	resetPos = true
	$Sprite2D.show()
	lives = 3
	changeState(ALIVE)
	shield = maxShield

func changeState(newState):
	match newState:
		INIT:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
		ALIVE:
			$CollisionShape2D.set_deferred("disabled", false)
			$Sprite2D.modulate.a = 1.0
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.hide()
			$EngineSound.stop()
			linear_velocity = Vector2.ZERO
			dead.emit()
	state = newState

func _process(delta):
	getInput()
	shield += shieldRegen * delta

func getInput():
	thrust = Vector2.ZERO
	$Exhaust.emitting = false
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * enginePower
		$Exhaust.emitting = true
		if not $EngineSound.playing:
			$EngineSound.play()
	else:
		$EngineSound.stop()
	rotationDir = Input.get_axis("rotateLeft", "rotateRight")
	if Input.is_action_pressed("shoot") and canShoot:
		shoot()

func shoot():
	if state == INVULNERABLE:
		return
	canShoot = false
	$GunCoolDown.start()
	var b = bulletScene.instantiate()
	get_tree().root.add_child(b)
	b.start($Muzzle.global_transform)
	$LaserSound.play()

func _physics_process(delta):
	constant_force = thrust
	constant_torque = rotationDir * spinPower

func _integrate_forces(physics_state) -> void:
	if resetPos:
		physics_state.transform.origin = screenSize / 2
		resetPos = false
	var xform = physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screenSize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screenSize.y)
	physics_state.transform = xform

func onGunCoolDownTimeout() -> void:
	canShoot = true

func onInvulnerabilityTimerTimeout():
	changeState(ALIVE)

func explode():
	$ExplosionSound.play()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	#lives -= 1
	await $Explosion/AnimationPlayer.animation_finished
	$Explosion.hide()

func onPlayerBodyEntered(body: Node) -> void:
	if body.is_in_group("rocks"):
		shield -= body.size * 25
		body.explode()
		#lives -= 1
		#explode()
