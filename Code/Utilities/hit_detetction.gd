class_name HitDetection extends RArea2D

@onready var hit_collider:CollisionShape2D = %hit_collider

var r_owner:RCharacter
var delay := 0.3
var hitters := []
var timer := 0.0

func _ready():
	Signals.ToggleHitCollider.connect(_toggle_hit_collider)
	r_owner = get_parent() as RCharacter
	area_entered.connect(_area_entered)

func _process(_delta):
	if GM.is_playing():
		timer += _delta
		if timer >= delay:
			timer = 0.0
			if !hitters.is_empty():
				hitters.clear()

func _area_entered(_area):
	if _area is AttackArea:
		if r_owner and !_area.r_owner in hitters:
			hitters.append(_area.r_owner)
			Signals.AttackReceived.emit(r_owner, _area.damages)

func _toggle_hit_collider(_owner:RCharacter, _value:=false):
	if _owner == r_owner:
		hit_collider.set_deferred("disabled", _value)
	
