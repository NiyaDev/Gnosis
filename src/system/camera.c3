
module gnosis::system::camera;
import std::io;
import std::math;
import raylib;
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
fn void! init() {
	main.position = {0, 12, 10};
	main.target = {0,0,0};
	main.up = {0,1,0};
	main.fovy = 70;
	main.projection = PERSPECTIVE;
	
	main.zoom = 1;

	main.rotation = 0;
	main.rot_target = 0;
}
<* Update camera data *>
fn void! update(float delta_time) {
	//* Position
	if (main.unit != null) {
		Vector3 position = {
			.x = main.unit.position.x - main.unit.position.z,
			.y = main.unit.position.y,
			.z = main.unit.position.x + main.unit.position.z,
		};
		
		main.target = position;
	}

	//* Rotation
	if (!gnosis::close(main.rotation, main.rot_target, 5)) {
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
	main.position = main.target.rotate({0.0, 12.0 * main.zoom, 10.0 * main.zoom}, main.rotation);
}

const Vector3 ZERO = {0,0,0};

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
	main.zoom = (change + main.zoom).clamp(0.25,2);
}
<* Rotate camera by amount *>
fn void rotate(float change) {
	main.rot_target += change;
}

