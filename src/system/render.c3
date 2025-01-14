
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
	raylib::set_trace_log_level(raylib::TraceLogLevel.WARNING);
	raylib::init_window(screen[0], screen[1], "Gnosis");
	raylib::set_target_fps(60);

	//* Set up render texture
	render_texture = raylib::load_render_texture(render[0], render[1]);

	//* Set up shader
	shader = raylib::load_shader(null, "resources/shader.fs");
}
/** Close render system
 **/
fn void! close() {
	raylib::unload_render_texture(render_texture);
	raylib::unload_shader(shader);

	raylib::close_window();
}

/** 
 **/
fn void content() {
	raylib::begin_texture_mode(render_texture);
	raylib::clear_background(raylib::DARKGRAY);
	raylib::begin_3d_mode(camera::main);
}
/** 
 **/
fn void ui() {
	raylib::end_3d_mode();
}
/** 
 **/
fn void end() {
	//* End rendering to texture
	raylib::end_texture_mode();

	//* Render texture to screen
	raylib::begin_drawing();
		raylib::begin_shader_mode(shader);
			raylib::draw_texture_pro(render_texture.texture, {0,0,render[0],(float)-render[1]}, {0,0,screen[0],screen[1]}, {0,0}, 0, raylib::WHITE);
		raylib::end_shader_mode();
	raylib::end_drawing();
}
