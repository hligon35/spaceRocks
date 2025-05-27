extends CanvasLayer

signal startGame

@onready var livesCounter = $MarginContainer/HBoxContainer/LivesCounter.get_children()
@onready var scoreLabel = $MarginContainer/HBoxContainer/ScoreLabel
@onready var shieldBar = $MarginContainer/HBoxContainer/ShieldBar
@onready var message = $VBoxContainer/Message
@onready var startButton = $VBoxContainer/StartButton

var barTextures = {
	"green": preload("res://assets/bar_green_200.png"),
	"yellow": preload("res://assets/bar_yellow_200.png"),
	"red": preload("res://assets/bar_red_200.png")
}

func updateShield(value):
	shieldBar.texture_progress = barTextures["green"]
	if value < 0.4:
		shieldBar.texture_progress = barTextures["red"]
	elif value < 0.7:
		shieldBar.texture_progress = barTextures["yellow"]
	shieldBar.value = value

func showMessage(text):
	message.text = text
	message.show()
	$Timer.start()

func updateScore(value):
	scoreLabel.text = str(value)

func updateLives(value):
	for item in 3:
		livesCounter[item].visible = value > item

func gameOver():
	showMessage("Game Over")
	await $Timer.timeout
	startButton.show()

func onStartButtonPressed():
	startButton.hide()
	startGame.emit()

func onTimerTimeout():
	message.hide()
	message.text = ""
