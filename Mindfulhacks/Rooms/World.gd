extends Node2D

onready var currentScene = null
onready var startingRoom = null
onready var SceneChangeAnime = $SceneChangeAnime
var playerName = ""
var scenePath = ""
var doorDoneState = [false, false, false]
var anxietyMeter = 0.1

func _ready():
	gotoScene("res://Rooms/MainMenu.tscn")
	
func gotoScene(path):
	scenePath = path
	SceneChangeAnime.stop(true)
	SceneChangeAnime.play("FadeOut")

# Number: 0-2
func setDoorDone(number):
	doorDoneState[number] = true
	startingRoom.setDoorDone(number)
	
func setAnxietyMeter(number):
	anxietyMeter = number
	var meter = self.find_node("AnxietyMeter", true, false)
	meter.setAnxietyLevel(anxietyMeter)
	
	
func _on_SceneChangeAnime_animation_finished(anim_name):
	
	if (anim_name == "FadeOut"):
		self.remove_child(currentScene)
		# Restore starting room scene instead of re-instancing it
		if (scenePath.find("StartingRoom") != -1):
			
			if (startingRoom != null):
				self.add_child(startingRoom)
				currentScene = startingRoom
			else:
				var scene = load(scenePath)
				var sceneInstance = scene.instance()
				startingRoom = sceneInstance
				currentScene = sceneInstance
				self.add_child(sceneInstance)
		else:
			var scene = load(scenePath)
			var sceneInstance = scene.instance()
			self.add_child(sceneInstance)
			currentScene = sceneInstance
		
		var meter = currentScene.find_node("AnxietyMeter", true, false)
		if (meter != null):
			meter.setAnxietyLevel(anxietyMeter)
		
		SceneChangeAnime.play("FadeIn")