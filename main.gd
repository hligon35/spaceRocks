extends Node

signal startGame

@export var rockScene: PackedScene
@export var enemyScene: PackedScene

@onready var startButton = $HUD/StartButton
@onready var background_sprite = $Background # Added for background scaling

var screenSize = Vector2.ZERO
var level = 0
var score = 0
var playing = false

func _ready():
	#randomize()
	screenSize = get_viewport().get_visible_rect().size

	if background_sprite and background_sprite.texture:
		var texture_size = background_sprite.texture.get_size()
		if texture_size.x > 0 and texture_size.y > 0: # Prevent division by zero
			var screen_aspect = screenSize.x / screenSize.y
			var texture_aspect = texture_size.x / texture_size.y
			
			var scale_factor = 0.0
			if (screen_aspect > texture_aspect): # Screen is wider than texture (or texture is taller)
				scale_factor = screenSize.x / texture_size.x # Fit to width
			else: # Screen is taller than texture (or texture is wider)
				scale_factor = screenSize.y / texture_size.y # Fit to height
			
			background_sprite.scale = Vector2(scale_factor, scale_factor)
		else:
			push_error("Background texture has zero size in one or both dimensions: %s" % texture_size)
		background_sprite.position = screenSize / 2 # Center the sprite
		background_sprite.z_index = -10 # Ensure it's behind other elements
	elif not background_sprite:
		push_error("Background node ($Background) not found. Check the path in main.gd.")
	elif not background_sprite.texture:
		push_error("Texture not assigned to the Background node ($Background).")


	for i in range(3):
		spawnRock(3)

func _input(event):
	if event.is_action_pressed("pause"):
		if not playing:
			$HUD/VBoxContainer/StartButton.hide()
			startGame.emit()
			newGame()
			return
		get_tree().paused = not get_tree().paused
		var message = $HUD/VBoxContainer/Message
		if get_tree().paused:
			message.text = "Paused"
			message.show()
		else:
			message.text = ""
			message.hide()

func spawnRock(size, pos = null, vel = null):
	if pos == null:
		$RockPath/RockSpawn.progress = randi()
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	var r = rockScene.instantiate()
	r.screenSize = screenSize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
	r.exploded.connect(self.onRockExploded)

func onRockExploded(size, radius, pos, vel):
	$ExplosionSound.play()
	score += 10 * size
	$HUD.updateScore(score)
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $Player.position.direction_to(pos).orthogonal() * offset
		var newPos = pos + dir * radius
		var newVel = dir * vel.length() * 1.1
		spawnRock(size - 1, newPos, newVel)

func newGame():
	get_tree().call_group("rocks", "queue_free")
	level = 0
	score = 0
	$HUD.updateScore(score)
	$Player.reset()
	$HUD.showMessage("Get Ready!")
	await $HUD/Timer.timeout
	playing = true
	$Music.play()

func newLevel():
	$LevelupSound.play()
	$EnemyTimer.start(randf_range(5, 10))
	level += 1
	$HUD.showMessage("Wave %s" % level)
	for i in range(level):
		spawnRock(3)

func _process(_delta):
	if !playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		newLevel()

func gameOver():
	playing = false
	$HUD.gameOver()
	$Music.stop()

func onEnemyTimerTimeout():
	var e = enemyScene.instantiate()
	add_child(e)
	e.target = $Player
	$EnemyTimer.start(randf_range(20, 40))
