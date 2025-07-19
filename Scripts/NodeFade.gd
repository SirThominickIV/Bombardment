extends CanvasItem

@export var FadeIn: bool = false
@export var SpeedMultiplier: float = 0.01

func _ready() -> void:
	if(FadeIn):
		set_modulate(Color(1, 1, 1, 0))
	else:
		set_modulate(Color(1, 1, 1, 1))

func _physics_process(_delta: float) -> void:
	if(FadeIn):
		set_modulate(lerp(get_modulate(), Color(1,1,1,1), SpeedMultiplier))
	else:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), SpeedMultiplier))
