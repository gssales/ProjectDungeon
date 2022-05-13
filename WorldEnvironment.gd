extends WorldEnvironment
  
func _on_DetectDarkness_darkness_changed(is_dark):
  if is_dark:
    $Tween.stop_all()
    $Tween.interpolate_property(environment, "tonemap_exposure", environment.tonemap_exposure, 4, 1.5,Tween.TRANS_CUBIC, Tween.EASE_OUT)
    $Tween.start()
  else:
    $Tween.stop_all()
    $Tween.interpolate_property(environment, "tonemap_exposure", environment.tonemap_exposure, 1, 1.5,Tween.TRANS_CUBIC, Tween.EASE_OUT)
    $Tween.start()
