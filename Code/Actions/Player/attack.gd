extends RAction

var current_attack:AttackArea = null
var attacks:Array[AttackArea] = []
var timer := 0.0:
	set(_value):
		timer = _value
		if timer >= delay:
			timer = 0.0
			can_action = true
var delay := 0.2
var combo_timer := 0.0:
	set(_value):
		combo_timer = _value
		if combo_timer >= combo_delay:
			combo_timer = 0.0
			combo_index = 0
			combo_started = false
var combo_delay := 5.0
var combo_index := 0:
	set(_value):
		combo_index = _value
		if combo_index >= attacks.size() or combo_index < 0:
			_reset_combo()
var has_combo := false:
	get:
		return attacks.size() > 1
var combo_started := false

func _ready() -> void:
	super._ready()
	Signals.AttackEnded.connect(_attack_ended)
	var temp = get_children(false)
	for each in temp:
		if each is AttackArea:
			attacks.append(each)
	attacks.sort_custom(func(a, b): return a.id.naturalnocasecmp_to(b.id) < 0)

func _input(event: InputEvent) -> void:
	if action_available and r_owner.grounded and can_action and event.is_action_pressed("attack"):
		combo_index = _combo_attack(combo_index, attacks)

func _process(_delta):
	if action_available:
		if r_owner.grounded:
			if !current_attack and !can_action:
				timer += _delta
			
			if has_combo and combo_started:
				combo_timer += _delta

func _combo_attack(_index := 0, _attacks:Array[AttackArea] = attacks) -> int:
	_attack(_attacks[_index].id)
	if has_combo and !combo_started: combo_started = true
	return _index + 1

func _attack(_id := ""):
	can_action = false
	current_attack = _get_from_id(_id)
	#Debug.log("Sending ", current_attack.id)
	Signals.StartAttack.emit(r_owner, current_attack.id)

func _reset_combo() -> void:
	combo_index = 0
	combo_timer = 0.0
	combo_started = false

func _get_from_id(_id := "") -> AttackArea:
	for each in attacks:
		if each.id == _id:
			return each
	#Debug.error("No attack matching id ", _id)
	return null

func _attack_ended(_character:RCharacter, _name := ""):
	#Debug.log("Receiving in attack_ended ", _character.name, " and ", _name)
	if _character == r_owner and _name == current_attack.id:
		current_attack = null
		can_action = true
		Signals.UpdateCharacterState.emit(r_owner, "idle")
