extends Resource

#repreents an instasnce of item data
class_name ItemInstance

@export var uid: String
@export var data: ItemData

@export var quantity: int

# @export var max_durability: int
# @export var durability: int

# constructor
func _init(d: ItemData = null, q := 1):
	uid = uuid.v4()
	data = d
	quantity = q