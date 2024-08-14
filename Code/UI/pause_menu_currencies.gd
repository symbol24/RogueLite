extends RControl

@onready var gold:RRichTextLabel = %gold

func _ready():
	Signals.UpdateAllCurrencies.connect(_update_all_currencies)

func _update_all_currencies():
	if PlayerData.data != null:
		gold.text = str(PlayerData.data.currencies["gold"])
