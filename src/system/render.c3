
module gnosis::system::render;
import raylib;
import gnosis::system::camera;


int[2] screen = {1280, 720};
//int[2] screen = {1920, 1080};
int[2] render = {640, 360};
RenderTexture render_texture;
Shader shader;


/** Initialize render system
 **/
fn void! init() {
	//* Setup raylib
	raylib::setTraceLogLevel(rl::TraceLogLevel.WARNING);
	raylib::initWindow(screen[0], screen[1], "Gnosis");
	raylib::setTargetFPS(60);

	//* Set up render texture
	render_texture = raylib::loadRenderTexture(render[0], render[1]);

	//* Set up shader
	shader = raylib::loadShader(null, "resources/shader.fs");
}
/** Close render system
 **/
fn void! close() {
	raylib::unloadRenderTexture(render_texture);
	raylib::unloadShader(shader);

	raylib::closeWindow();
}

/** 
 **/
fn void content() {
	raylib::beginTextureMode(render_texture);
	raylib::clearBackground(raylib::DARKGRAY);
	raylib::beginMode3D(camera::main);
}
/** 
 **/
fn void ui() {
	raylib::endMode3D();
}
/** 
 **/
fn void end() {
	//* End rendering to texture
	raylib::endTextureMode();

	//* Render texture to screen
	raylib::beginDrawing();
		raylib::beginShaderMode(shader);
			raylib::drawTexturePro(render_texture.texture, {0,0,render[0],(float)-render[1]}, {0,0,screen[0],screen[1]}, {0,0}, 0, rl::WHITE);
		raylib::endShaderMode();
	raylib::endDrawing();
}
