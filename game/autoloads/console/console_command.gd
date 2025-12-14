class_name ConsoleCommand


var name: String
var description: String
var usage: String
var callable: Callable


func _init(name: String, description: String, usage: String, callable: Callable) -> void:
    self.name = name
    self.description = description
    self.usage = usage
    self.callable = callable


func _to_string() -> String:
    return name + ": " + usage + ": " + description