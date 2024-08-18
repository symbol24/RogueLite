extends RControl

@onready var gold:RRichTextLabel = %gold
@onready var key_1: RRichTextLabel = %key1
@onready var key_2: RRichTextLabel = %key2
@onready var key_3: RRichTextLabel = %key3

func _ready():
	super()
	Signals.UpdateAllCurrencies.connect(_update_all_currencies)

func _update_all_currencies():
	if PlayerData.data != null:
		if PlayerData.data.currencies.has(str(GM.CURRENCIES.GOLD)):
			gold.text = str(PlayerData.data.currencies[str(GM.CURRENCIES.GOLD)])
		else:
			gold.text = "0"
		if PlayerData.data.currencies.has(str(GM.CURRENCIES.KEY1)):
			key_1.text = str(PlayerData.data.currencies[str(GM.CURRENCIES.KEY1)])
		else:
			key_1.text = "0"
		if PlayerData.data.currencies.has(str(GM.CURRENCIES.KEY2)):
			key_2.text = str(PlayerData.data.currencies[str(GM.CURRENCIES.KEY2)])
		else:
			key_2.text = "0"
		if PlayerData.data.currencies.has(str(GM.CURRENCIES.KEY3)):
			key_3.text = str(PlayerData.data.currencies[str(GM.CURRENCIES.KEY3)])
		else:
			key_3.text = "0"
