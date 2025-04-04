
module gnosis::system;
import pleroma;
import std::io;


int[2] screen = {1280, 720};
int[2] render = {640, 360};
RenderTexture render_texture;
int texture_loc;
Texture mask;


<* Initialize render system *>
fn void init_renderer() {
	//* Setup raylib
	raylib::set_trace_log_level(raylib::TraceLogLevel.WARNING);
	raylib::init_window(screen[0], screen[1], "Gnosis");
	raylib::set_target_fps(60);

	//* Set up render texture
	render_texture = rendertexture::load(render[0], render[1]);

	//* Set up shader
	shader_init();
}
<* Close render system *>
fn void close() {
	render_texture.unload();
	g_shader.unload();

	raylib::close_window();
}

<* Starts drawing *>
fn void content() {
	render_texture.begin();
	raylib::clear_background(color::BLACK);
	raylib::begin_3d_mode(camera::main);
}
<* Stops 3d mode and starts UI *>
fn void ui() {
	raylib::end_3d_mode();
}
<* Finishes rendering to RT and displays to screen *>
fn void end() {
	//* End rendering to texture
	render_texture.end();

	//* Render texture to screen
	raylib::begin_drawing();
		g_shader.begin();
			render_texture.texture.draw_pro(
				{0,0,render[0],(float)-render[1]},
				{0,0,screen[0],screen[1]},
				{0,0}, 0,
				color::WHITE,
			);
		g_shader.end();
	raylib::end_drawing();
}

<**>
fn float get_screen_ratio() {
	return (float)screen[0] / (float)render[0];
}
