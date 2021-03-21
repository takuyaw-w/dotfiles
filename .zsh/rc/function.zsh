# functions

function get_max_brightness() {
  less "/sys/class/backlight/intel_backlight/max_brightness"
}

funtion get_brightness() {
  less "/sys/class/backlight/intel_backlight/brightness"
}

funtion set_brightness() {
  sudo tee /sys/class/backlight/intel_backlight/brightness <<< $1
}
