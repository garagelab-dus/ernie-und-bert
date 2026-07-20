# this script imports (sources) the .camera.front.config and .camera.wrist.config files, and then exports the $robot_cameras2 variable.
# $robot_cameras2 contains the string that is expected from other scripts as a parameter.
# the string is a json-like string, but without quotes around the keys and values.
# these values come from:
#   - .camera.front.config
#   - .camera.wrist.config
# expected string for two cameras:
# { front: { type: opencv, index_or_path: 0, width: 320, height: 240, fps: 30 }, wrist: { type: opencv, index_or_path: 1, width: 320, height: 240, fps: 30 }}
robot_cameras2="{ front: { type: opencv, index_or_path: 0, width: 320, height: 240, fps: 30 }, wrist: { type: opencv, index_or_path: 1, width: 320, height: 240, fps: 30 }}"