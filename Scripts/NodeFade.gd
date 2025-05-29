extends CanvasItem

@export var FadeIn: bool = false
@export var SpeedMultiplier: float = 1.0

func _ready() -> void:
	if(FadeIn):
		set_modulate(Color(1, 1, 1, 0))
	else:
		set_modulate(Color(1, 1, 1, 1))

func _physics_process(delta: float) -> void:
	if(FadeIn):
		set_modulate(lerp(get_modulate(), Color(1,1,1,1), delta*SpeedMultiplier))
	else:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), delta*SpeedMultiplier))
