extends RControl

@onready var gold:RRichTextLabel = %gold

func _ready():
	super()
	Signals.UpdateAllCurrencies.connect(_update_all_currencies)

func _update_all_currencies():
	if PlayerData.data != null:
		if PlayerData.data.currencies.has(str(GM.CURRENCIES.GOLD)):
			gold.text = str(PlayerData.data.currencies[str(GM.CURRENCIES.GOLD)])
		else:
			gold.text = "0"
