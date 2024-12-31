
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
	Mesh mesh = rl::genMeshCube(1,0.5,1);
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


	for (int i = 0; i < 100; i++) { tiles[i] = true; }

	while (!rl::windowShouldClose()) {
		float delta_time = rl::getFrameTime();
		camera::update(delta_time)!!;

		if (rl::isKeyDown(rl::KEY_W)) camera::move({0,0,-10 * delta_time});
		if (rl::isKeyDown(rl::KEY_S)) camera::move({0,0,10 * delta_time});
		if (rl::isKeyDown(rl::KEY_D)) camera::move({10 * delta_time,0,0});
		if (rl::isKeyDown(rl::KEY_A)) camera::move({-10 * delta_time,0,0});
		if (rl::isKeyDown(rl::KEY_LEFT_SHIFT)) camera::move({0,-10 * delta_time, 0});
		if (rl::isKeyDown(rl::KEY_SPACE)) camera::move({0,10 * delta_time, 0});
		if (rl::isKeyPressed(rl::KEY_Q)) camera::rotate(90);
		if (rl::isKeyPressed(rl::KEY_E)) camera::rotate(-90);
		float zoom = rl::getMouseWheelMove();
		if (zoom != 0) camera::zoom(-zoom / 10);

		render::content();
			chunk_01.draw(model);
			rl::drawBillboardPro(camera::main, player, {0,0,16,32}, camera::main.target, {0,1,-1}, {1,1}, {0.5,0.25}, 0, rl::WHITE);

		render::ui();
			rl::drawTextureNPatch(hp_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(hp_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,10,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(st_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(st_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,20,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(mn_bg, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, rl::WHITE);
			rl::drawTextureNPatch(mn_fl, {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL}, {10,30,64,8}, {0,0}, 0, rl::WHITE);
			String text = string::tformat("Tiles Rendered: %d", chunks::tiles_rendered);
			rl::drawText((ZString)text, 0, 100,20,rl::BLACK);

		render::end();
	}
	return 0;
}

