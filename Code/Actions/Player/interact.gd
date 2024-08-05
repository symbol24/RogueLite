class_name InteractAction extends RAction

@onready var interact_area:RArea2D = %interact_area

var interactable:RInteractable = null
var timer := 0.0
var delay := 0.2

func _ready():
	super()
	interact_area.area_entered.connect(_area_entered)
	interact_area.area_exited.connect(_area_exited)

func _process(_delta):
	if GM.is_playing():
		if can_action and interactable and RInput.interact:
			can_action = false
			_interact()
		
		if !can_action:
			timer += _delta
			if timer >= delay:
				can_action = true
				timer = 0.0

func _interact():
	var _result = interactable.interact({})

func _area_entered(_area):
	if _area is RInteractable:
		interactable = _area

func _area_exited(_area):
	if _area is RInteractable:
		interactable = null
