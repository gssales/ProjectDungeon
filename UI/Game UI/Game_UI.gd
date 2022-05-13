extends Control

signal stamina_changed(stamina)
signal health_changed(health)

var font_color= Color(0.7,0.2,0.2,1.0)
var font_outline_modulate= Color(1,1,1,1)
var font_color_shadow= Color(0,0,0,1)

func _ready():
  new_level()

func _process(delta):
  $LevelTitle.add_color_override("font_color", font_color)
  $LevelTitle.add_color_override("font_outline_modulate", font_outline_modulate)
  $LevelTitle.add_color_override("font_color_shadow", font_color_shadow)

func new_level():
  $LevelTitle.text = "Level %d" % Global.current_level
  var center = get_viewport_rect().size.x/2 - $LevelTitle.rect_size.x/2
  
  $LevelTitle/Tween.interpolate_property(self, "font_color",  
      Color(0.7,0.2,0.2,0.0), Color(0.7,0.2,0.2,1.0), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT)
  $LevelTitle/Tween.interpolate_property(self, "font_outline_modulate",  
      Color(1.0,1.0,1.0,0.0), Color(1.0,1.0,1.0,1.0), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT)
  $LevelTitle/Tween.interpolate_property(self, "font_color_shadow",  
      Color(0.0,0.0,0.0,0.0), Color(0.0,0.0,0.0,1.0), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT)
  $LevelTitle/Tween.interpolate_property($LevelTitle, "rect_position",  
      Vector2(center, 250), Vector2(center, 150), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT)
      
  $LevelTitle/Tween.interpolate_property(self, "font_color",  
      Color(0.7,0.2,0.2,1.0), Color(0.7,0.2,0.2,0.0), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT,1.5)
  $LevelTitle/Tween.interpolate_property(self, "font_outline_modulate",  
      Color(1.0,1.0,1.0,1.0), Color(1.0,1.0,1.0,0.0), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT,1.5)
  $LevelTitle/Tween.interpolate_property(self, "font_color_shadow",  
      Color(0.0,0.0,0.0,1.0), Color(0.0,0.0,0.0,0.0), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT,1.5)
  $LevelTitle/Tween.interpolate_property($LevelTitle, "rect_position",  
      Vector2(center, 150), Vector2(center, 50), 0.5,
      Tween.TRANS_CUBIC,Tween.EASE_OUT,1.5)
  $LevelTitle/Tween.start()
  
func on_LevelExit_go_to_next_level(player):
  new_level()


func _on_Stamina_stamina_changed(new_stamina):
  emit_signal("stamina_changed", new_stamina)


func _on_Health_health_changed(new_health):
  emit_signal("health_changed", new_health)
