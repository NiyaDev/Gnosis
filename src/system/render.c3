
module gnosis::system::render;
import raylib5::rl;
import gnosis::system::camera;


int[2] screen = {1280, 720};
int[2] render = {640, 360};
RenderTexture render_texture;
Shader shader;


/** Initialize render system
 **/
fn void! init() {
	//* Setup raylib
	rl::setTraceLogLevel(rl::TraceLogLevel.WARNING);
	rl::initWindow(screen[0], screen[1], "Gnosis");

	//* Set up render texture
	render_texture = rl::loadRenderTexture(render[0], render[1]);

	//* Set up shader
	shader = rl::loadShader(null, "resources/shader.fs");
}
/** Close render system
 **/
fn void! close() {
	rl::unloadRenderTexture(render_texture);
	rl::unloadShader(shader);

	rl::closeWindow();
}

/** 
 **/
fn void ui() {
	rl::beginTextureMode(render_texture);
	rl::clearBackground(rl::DARKGRAY);
}
/** 
 **/
fn void content() {
	rl::beginMode3D(camera::main);
}
/** 
 **/
fn void end() {
	//* End rendering to texture
	rl::endMode3D();
	rl::endTextureMode();

	//* Render texture to screen
	rl::beginDrawing();
		rl::beginShaderMode(shader);
			rl::drawTexturePro(render_texture.texture, {0,0,render[0],(float)-render[1]}, {0,0,screen[0],screen[1]}, {0,0}, 0, rl::WHITE);
		rl::endShaderMode();
	rl::endDrawing();
}