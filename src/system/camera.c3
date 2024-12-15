
module gnosis::system::camera;
import raylib5::rl;


Camera main;

struct Camera {
	inline Camera3D camera;

	float zoom;
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
	main.zoom = (change + main.zoom).clamp(0.5,2);

	main.position = {main.target.x, main.target.y + (12 * main.zoom), main.target.z + (10 * main.zoom)};
}