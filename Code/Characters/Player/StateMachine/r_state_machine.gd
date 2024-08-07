class_name RStateMachine extends RAction

const NOTHING = preload("res://Data/Characters/Player/States/nothing.tres")

@export var states:Array[RState] = []

var id:String = "":
	get:
		if current_state is RState:
			return current_state.id
		return ""
var can_move:bool = false:
	get:
		if current_state is RState:
			return current_state.can_move
		return false
var can_jump:bool = false:
	get:
		if current_state is RState:
			return current_state.can_jump
		return false
var can_be_hit:bool = false:
	get:
		if current_state is RState:
			return current_state.can_be_hit
		return false
var can_die:bool = false:
	get:
		if current_state is RState:
			return current_state.can_die
		return false
var can_flip:bool = false:
	get:
		if current_state is RState:
			return current_state.can_flip
		return false
var can_interact:bool = false:
	get:
		if current_state is RState:
			return current_state.can_interact
		return false

var current_state:RState = NOTHING:
	get:
		if current_state is RState:
			if current_state == null:
				return NOTHING
			return current_state
		return NOTHING
	set(_value):
		if _value != current_state:
			current_state = _value
			Signals.StateUpdated.emit(r_owner, current_state)
			#print("new state ", current_state.id)

func _ready():
	super._ready()
	Signals.UpdateCharacterState.connect(_update_state)

func _update_state(_character:RCharacter, _new_state := ""):
	#print("receving new state ",_new_state, " for ", _character.data.id)
	if _character == r_owner and _new_state != "" and id != _new_state:
		current_state = _get_state(_new_state)

func _get_state(_id := "") -> RState:
	if _id != "":
		for state in states:
			if _id == state.id:
				#print("state found: ", state.id)
				return state
	#print("state NOT found")
	return NOTHING

func is_state(_value := "") -> bool:
	return current_state.id == _value
