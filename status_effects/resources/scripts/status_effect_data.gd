extends Resource


## data container / wrapper class for the data in status effects. 
## for example, would contain a damage entry for status effects that inflict damage. etc...
class_name StatusEffectData

@export var status_effect_data: Dictionary[String, Variant] = {}


func get_status_effect_data(key: String) -> Variant:
    var data = status_effect_data.get(key)
    if data == null:
        push_error("Trying to get the key to some status effect data, but it doesnt exist")
        return
    return data
