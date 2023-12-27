extends Panel

@export var current_state : State
@onready var property_container =$MarginContainer/VBoxContainer
var property
var fps:String
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.debug=self
	visible=false
	#add_debug_property("FPS", fps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps= "%.2f" % (1.0/delta)
	add_property("FPS",fps, 1)
func _input(event):
	#toggle debug panel
	if event.is_action_pressed("debug"):
		visible=!visible

func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false)  # Try to find Label node with same name
	if !target:  # If there is no current Label node for property (i.e., initial load)
		target = Label.new()  # Create new Label node
		property_container.add_child(target)  # Add new node as child to VBox container
		target.name = title  # Set name to title
		target.text = target.name + ": " + str(value)  # Set text value
	elif visible:
		target.text = title + ": " + str(value)  # Update text value
		property_container.move_child(target,order)  # Reorder property based on given order value


#func add_debug_property(title: String, value):
	#property= Label.new()
	#property_container.add_child(property)
	#property.name =title
	#property.text=property.name + value
