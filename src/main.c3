
module gnosis;
import std::io;
import raylib5::rl;
import gnosis::system::render;
import gnosis::system::camera;




fn int main(String[] args) {
	//* Initialize systems
	render::init()!!;
	defer render::close()!!;
	camera::init()!!;

	Mesh mesh = rl::genMeshCube(1,1,1);
	Model model = rl::loadModelFromMesh(mesh);
	defer rl::unloadModel(model);

	while (!rl::windowShouldClose()) {
		float delta_time = rl::getFrameTime();

		if (rl::isKeyDown(rl::KEY_W)) camera::move({0,0,-10 * delta_time});
		if (rl::isKeyDown(rl::KEY_S)) camera::move({0,0,10 * delta_time});
		if (rl::isKeyDown(rl::KEY_D)) camera::move({10 * delta_time,0,0});
		if (rl::isKeyDown(rl::KEY_A)) camera::move({-10 * delta_time,0,0});
		float zoom = rl::getMouseWheelMove();
		if (zoom != 0) camera::zoom(-zoom / 10);

		render::ui();
			rl::drawText("HP: ", 10, 10, 10, rl::WHITE);
			rl::drawText("ST: ", 10, 20, 10, rl::WHITE);
			rl::drawText("MN: ", 10, 30, 10, rl::WHITE);

		render::content();
			rl::drawModelEx(model, {0,-1,0}, {0,1,0}, 45, {1,1,1}, rl::YELLOW);
			rl::drawModelEx(model, {-0.5,-0,0.5}, {0,1,0}, 45, {1,1,1}, rl::YELLOW);

		render::end();
	}
	return 0;
}

