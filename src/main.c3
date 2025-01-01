
module gnosis;
import std::io;
import std::math::random;
import raylib5::rl;
import gnosis::system::render;
import gnosis::system::camera;
import gnosis::chunks;


bool[100] tiles;
Chunk chunk_01;


fn int main(String[] args) {
	//* Initialize systems
	render::init()!!;
	defer render::close()!!;
	camera::init()!!;

	//* Generate Test chunk
	chunk_01.init();

	// Generate basic tile
	Mesh mesh = rl::genMeshCube(1,1,1);
	Model model = rl::loadModelFromMesh(mesh);
	defer rl::unloadModel(model);

	//* Generate default material
	Material mat = rl::loadMaterialDefault();
	mat.maps[0].texture = rl::loadTexture("resources/tex_grass.png");
	model.materials[0] = mat;

	//* Load Textures
	Texture player = rl::loadTexture("resources/spr_test_player.png");

	Texture hp_bg = rl::loadTexture("resources/spr_health_bg.png");
	Texture hp_fl = rl::loadTexture("resources/spr_health_fill.png");
	Texture st_bg = rl::loadTexture("resources/spr_stamina_bg.png");
	Texture st_fl = rl::loadTexture("resources/spr_stamina_fill.png");
	Texture mn_bg = rl::loadTexture("resources/spr_mana_bg.png");
	Texture mn_fl = rl::loadTexture("resources/spr_mana_fill.png");

	//* Player
	Player pl = {
		.u.position = {8,9,8},
		.u.sprite = player,
	};
	camera::main.unit = &pl;


	for (int i = 0; i < 100; i++) { tiles[i] = true; }

	while (!rl::windowShouldClose()) {
		float dt = rl::getFrameTime();
		camera::update(dt)!!;

		// TODO: Move into player.c3
		pl.update();
		//if (rl::isKeyDown(rl::KEY_W)) pl.move(camera::ZERO.rotate({-5 * dt, 0, -5 * dt}, camera::main.rotation));	
		//if (rl::isKeyDown(rl::KEY_S)) pl.move(camera::ZERO.rotate({ 5 * dt, 0,  5 * dt}, camera::main.rotation));
		//if (rl::isKeyDown(rl::KEY_D)) pl.move(camera::ZERO.rotate({ 5 * dt, 0, -5 * dt}, camera::main.rotation));
		//if (rl::isKeyDown(rl::KEY_A)) pl.move(camera::ZERO.rotate({-5 * dt, 0,  5 * dt}, camera::main.rotation));
		if (rl::isKeyDown(rl::KEY_LEFT_SHIFT)) camera::move({0,-10 * dt, 0});
		if (rl::isKeyDown(rl::KEY_SPACE)) camera::move({0,10 * dt, 0});
		if (rl::isKeyPressed(rl::KEY_Q)) camera::rotate(90);
		if (rl::isKeyPressed(rl::KEY_E)) camera::rotate(-90);
		float zoom = rl::getMouseWheelMove();
		if (zoom != 0) camera::zoom(-zoom / 10);

		render::content();
			chunk_01.draw(model);
			rl::drawBillboardPro(camera::main, pl.sprite, {0,0,16,32}, camera::main.target, camera::ZERO.rotate({0,1,-1}, camera::main.rotation), {1,1}, {0.5,0.25}, 0, rl::WHITE);

		render::ui();
			rl::drawTextureNPatch(hp_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(hp_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(st_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(st_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(mn_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(mn_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, rl::WHITE);
			String text = string::tformat("FPS: %d\nTiles Rendered: %d", rl::getFPS(), chunks::tiles_rendered);
			rl::drawText((ZString)text, 0, 100, 8, rl::BLACK);

		render::end();
	}
	return 0;
}

