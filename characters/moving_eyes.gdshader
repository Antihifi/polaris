shader_type spatial;

uniform vec3 eye_color : source_color = vec3(0.4, 0.25, 0.1);
uniform vec3 sclera_color : source_color = vec3(0.85, 0.82, 0.78);

// Left eye (character's left)
uniform vec2 left_eye_center = vec2(0.87, 0.83);
uniform float left_pupil_size : hint_range(0.001, 0.1) = 0.013;
uniform float left_iris_size : hint_range(0.005, 0.2) = 0.031;
uniform bool left_flip_x = false;
uniform bool left_flip_y = false;
uniform bool left_swap_xy = false;

// Right eye (character's right)
uniform vec2 right_eye_center = vec2(0.82, 0.352);
uniform float right_pupil_size : hint_range(0.001, 0.1) = 0.013;
uniform float right_iris_size : hint_range(0.005, 0.2) = 0.031;
uniform bool right_flip_x = false;
uniform bool right_flip_y = false;
uniform bool right_swap_xy = false;

// Movement
uniform float movement_speed : hint_range(0.1, 3.0) = 0.8;
uniform float movement_amount : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	// Calculate base movement direction
	float time_slow = TIME * movement_speed;
	vec2 look_direction = vec2(
		sin(time_slow * 0.7) * cos(time_slow * 0.3),
		sin(time_slow * 0.5) * cos(time_slow * 0.8)
	) * movement_amount;

	// Transform movement for left eye
	vec2 left_move = look_direction;
	if (left_swap_xy) left_move = vec2(left_move.y, left_move.x);
	if (left_flip_x) left_move.x = -left_move.x;
	if (left_flip_y) left_move.y = -left_move.y;
	vec2 left_offset = left_move * left_iris_size;

	// Transform movement for right eye
	vec2 right_move = look_direction;
	if (right_swap_xy) right_move = vec2(right_move.y, right_move.x);
	if (right_flip_x) right_move.x = -right_move.x;
	if (right_flip_y) right_move.y = -right_move.y;
	vec2 right_offset = right_move * right_iris_size;

	// Distance to each eye center with movement applied
	float dist_left = length(UV - left_eye_center - left_offset);
	float dist_right = length(UV - right_eye_center - right_offset);

	// Sclera (off-white)
	vec3 color = sclera_color;

	// Left eye
	if (dist_left < left_iris_size) {
		color = eye_color;
	}
	if (dist_left < left_pupil_size) {
		color = vec3(0.02);
	}

	// Right eye
	if (dist_right < right_iris_size) {
		color = eye_color;
	}
	if (dist_right < right_pupil_size) {
		color = vec3(0.02);
	}

	ALBEDO = color;
	ROUGHNESS = 0.6;
	SPECULAR = 0.2;
}
