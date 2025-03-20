
module gnosis::system::render;
import raylib;
import bulk;
import gnosis::system::camera;


int[2] screen = {1280, 720};
int[2] render = {640, 360};
RenderTexture render_texture;
Shader* shader;
int texture_loc;
Texture* mask;


<* Initialize render system *>
fn void! init() {
	//* Setup raylib
	raylib::set_trace_log_level(raylib::TraceLogLevel.WARNING);
	raylib::init_window(screen[0], screen[1], "Gnosis");
	//raylib::set_target_fps(60);

	//* Set up render texture
	render_texture = raylib::load_render_texture(render[0], render[1]);

	//* Set up shader
	Bulk* shader_bulk = bulk::load("resources/001")!!;
	//shader = shader::from_mem(null, shader_bulk.get("shader")!!);
	//shader = shader::from_mem(shader_bulk.get("vert_shader")!!, shader_bulk.get("frag_shader")!!);
	//shader = shader::from_mem(null, shader_bulk.get("frag_shader")!!);
	shader = shader::from_mem(null, shader_bulk.get("shadertest")!!);
	mask = texture::load("resources/raw_files/mask.png")!!;
	texture_loc = raylib::get_shader_location(*shader, "mask_sampler");
	//raylib::set_shader_value_texture(*shader, texture_loc, *mask);
	//shader.locs[] = raylib::get_shader_location(*shader, "gm_BaseTexture");
}
<* Close render system *>
fn void! close() {
	raylib::unload_render_texture(render_texture);
	shader.unload();

	raylib::close_window();
}

<* Starts drawing *>
fn void content() {
	raylib::begin_texture_mode(render_texture);
	raylib::clear_background(raylib::BLACK);
	raylib::begin_3d_mode(camera::main);
}
<* Stops 3d mode and starts UI *>
fn void ui() {
	raylib::end_3d_mode();
}
<* Finishes rendering to RT and displays to screen *>
fn void end() {
	//* End rendering to texture
	raylib::end_texture_mode();

	//* Render texture to screen
	raylib::begin_drawing();
		//Image* img = render_texture.texture.to_image();
		//raylib::set_shader_value_texture(*shader,texture_loc,render_texture.texture);
		shader.begin();
			raylib::draw_texture_pro(render_texture.texture, {0,0,render[0],(float)-render[1]}, {0,0,screen[0],screen[1]}, {0,0}, 0, raylib::WHITE);
		shader.end();
	raylib::end_drawing();
}

