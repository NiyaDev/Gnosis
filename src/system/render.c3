
module gnosis::system::render;
import pleroma;
//import raylib;
//import bulk;
import gnosis::system::camera;
import std::io;


int[2] screen = {1280, 720};
int[2] render = {640, 360};
RenderTexture render_texture;
Shader shader;
int texture_loc;
Texture mask;


<* Initialize render system *>
fn void init() {
	//* Setup raylib
	raylib::set_trace_log_level(raylib::TraceLogLevel.WARNING);
	raylib::init_window(screen[0], screen[1], "Gnosis");
	//raylib::set_target_fps(60);

	//* Set up render texture
	render_texture = rendertexture::load(render[0], render[1]);

	//* Set up shader
	io::printfn("");
	Bulk shader_bulk = bulk::load("resources/001");
	//shader = shader::load_mem(null, shader_bulk.get("shadertest"));
}
<* Close render system *>
fn void close() {
	render_texture.unload();
	shader.unload();

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
		//Image* img = render_texture.texture.to_image();
		//raylib::set_shader_value_texture(*shader,texture_loc,render_texture.texture);
		//shader.begin();
			render_texture.texture.draw_pro(
				{0,0,render[0],(float)-render[1]},
				{0,0,screen[0],screen[1]},
				{0,0}, 0,
				color::WHITE,
			);
		//shader.end();
	raylib::end_drawing();
}

