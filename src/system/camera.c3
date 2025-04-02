
module gnosis::system::camera;
import std::io;
import std::math;
import pleroma;
//import raylib;
//import keybind;
import gnosis;
import gnosis::unit;


Camera main;

struct Camera {
	inline Camera3D camera;

	float zoom;

	float rotation;
	float rot_target;

	Unit* unit;
}

<* Initialize Camera structure *>
fn void init() {
	main = {
		.position 		= {0, 12, 10},
		.target   		= {0,  0,  0},
		.up       		= {0,  1,  0},
		.fovy      		= 70,
		.projection 	= PERSPECTIVE,

		.zoom 				= 0.5,

		.rotation    	= 0,
		.rot_target  	= 0,
	};
}
<* Set unit to follow *>
fn void set_target(Unit* target) {
	main.unit = target;
}
<* Update camera data *>
fn void update(float delta_time) {
	if (main.unit != null) {
		//* Follow unit if it has one
		Vector3 position = {
			main.unit.position.x - main.unit.position.z,
			main.unit.position.y - 1.5,
			main.unit.position.x + main.unit.position.z,
		};
		
		main.target = position;
	} else {
		//* Control directly otherwise
		Vector3 position = main.target;
		if (keybind::is_down("move_up"))    position.z -= 0.1;
  	if (keybind::is_down("move_down"))  position.z += 0.1;
  	if (keybind::is_down("move_left"))  position.x -= 0.1;
  	if (keybind::is_down("move_right")) position.x += 0.1;
		main.target = position;
	}

	//* Rotation
	if (!raylib::close(main.rotation, main.rot_target, 5)) {
		float dir = 0;
		if ((main.rot_target - main.rotation) > 0) dir =  1;
		if ((main.rot_target - main.rotation) < 0) dir = -1;

		main.rotation += dir * (500 * delta_time);
	} else {
		main.rotation = main.rot_target;

		//* Bounds checking */
		if (main.rotation < 0) {
			main.rotation += 360;
			main.rot_target += 360;
		}
		if (main.rotation > 360) {
			main.rotation -= 360;
			main.rot_target -= 360;
		}
	}
	//main.position = main.target.rotate({0.0, 12.0 * main.zoom, 10.0 * main.zoom}, main.rotation);
	main.position = main.target.rotate({0.0, (float)((12.0).pow(main.zoom * 1.5)), 10.0 * main.zoom}, main.rotation);
}
<* Move camera by an amount *>
fn void move(Vector3 amount) {
	main.position.x += amount.x;
	main.target.x += amount.x;
	main.position.y += amount.y;
	main.target.y += amount.y;
	main.position.z += amount.z;
	main.target.z += amount.z;
}
<* Change zoom level *>
fn void zoom(float change) {
	main.zoom = (change + main.zoom).clamp(0.25,0.85);
}
<* Rotate camera by amount *>
fn void rotate(float change) {
	main.rot_target += change;
}

