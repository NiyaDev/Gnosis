
module gnosis::system::camera;
import std::io;
import std::math;
import raylib5::rl;


Camera main;

struct Camera {
	inline Camera3D camera;

	float zoom;

	float rotation;
	float rot_target;
}

/** 
 **/
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
/** 
 **/
fn void! update(float delta_time) {
	if (!close_enough(main.rotation, main.rot_target, 5)) {
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

	//* Calc rotation
	main.position = main.target.rotate({0.0, 12.0 * main.zoom, 10.0 * main.zoom}, main.rotation);
	io::printfn("{%d}", main.rotation);
}

/** TEMP
 **/
fn bool close_enough(float f1, float f2, float amount) {
	if (f1 + amount > f2 && f1 - amount < f2) {
		return true;
	} else {
		return false;
	}
}
/** TEMP
 **/
fn Vector3 Vector3.rotate(&self, Vector3 dist, float rot) {
	Vector3 position;

	position.x = dist.x * (float)math::cos(rot / 57.3) - dist.z * (float)math::sin(rot / 57.3);
	position.z = dist.x * (float)math::sin(rot / 57.3) + dist.z * (float)math::cos(rot / 57.3);

	position.x += self.x;
	position.y  = self.y + dist.y;
	position.z += self.z;

	return position;
}

/** 
 **/
fn void move(Vector3 amount) {
	main.position.x += amount.x;
	main.target.x += amount.x;
	main.position.y += amount.y;
	main.target.y += amount.y;
	main.position.z += amount.z;
	main.target.z += amount.z;
}
/** 
 **/
fn void zoom(float change) {
	main.zoom = (change + main.zoom).clamp(0.25,2);

	//main.position = {main.target.x, main.target.y + (12 * main.zoom), main.target.z + (10 * main.zoom)};
}
/** 
 **/
fn void rotate(float change) {
	main.rot_target += change;
}