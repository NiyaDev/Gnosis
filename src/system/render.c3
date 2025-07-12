
module gnosis::system;
import ennoia;
import std::io;


int[2] screen = {1280, 720};
int[2] render = {640, 360};
int fps = 60;
RenderTexture render_texture;
bool is_rendering;


<* Initialize render system *>
fn void init_renderer() {
	//* Setup raylib
	raylib::set_trace_log_level(WARNING);
	raylib::init_window(screen[0], screen[1], "Gnosis");
	raylib::set_target_fps(fps);

	//* Set up render texture
	render_texture = rendertexture::load(render[0], render[1]);

	//* Set up shader
	shader_init();
}
<* Close render system *>
fn void close_renderer() {
	render_texture.unload();
	g_shader.unload();

	raylib::close_window();
}
<* Resets renderer *>
fn void reset_renderer() {
	if (is_rendering) end();

	render_texture.unload();
	g_shader.unload();

	raylib::set_target_fps(fps);
	render_texture = rendertexture::load(render[0], render[1]);
	shader_init();
}

<* Starts drawing *>
fn void content() {
	render_texture.begin();
	raylib::clear_background(color::BLACK);
	raylib::begin_3d_mode(camera::main);
	is_rendering = true;
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
	is_rendering = false;
}

<**>
fn float get_screen_ratio() {
	return (float)screen[0] / (float)render[0];
}
