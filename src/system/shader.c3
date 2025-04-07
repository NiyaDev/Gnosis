
module gnosis::system;
import pleroma;


struct CRTShader {
  inline Shader sh;

  Uniform mask;
  Uniform slot;

  Uniform screen_size;
  Uniform render_size;
  Uniform shift;
  
  Uniform zoom;
  Uniform int_scale;
  Uniform aspect;
  Uniform do_tate;
  Uniform curvature;
  Uniform mask_mirror;
  Uniform mask_strength;
  Uniform mask_scale;
  Uniform mask_texwidth;
  Uniform mask_repeat;
  Uniform mask_shadow;
  Uniform slot_strength;
  Uniform sl_min;
  Uniform sl_fade;
  Uniform sl_shape;
  Uniform random_seed;
  Uniform glow_spread;
  Uniform glow_gamma;
  Uniform glow_strength;
  Uniform input_gamma;
  Uniform output_gamma;
  Uniform softness;
  Uniform border_width;
  Uniform border_brightness;
  Uniform deconvergence;
  Uniform noise;
  Uniform glow_over_mask;
  Uniform post_brightness;
}

struct Uniform {
  int location;
  union {
    float as_float;
    Vector2 as_vec2;
    Vector3 as_vec3;
    Vector4 as_vec4;
    int as_int;
    int[2] as_ivec2;
    int[3] as_ivec3;
    int[4] as_ivec4;
    uint as_uint;
    uint[2] as_uivec2;
    uint[3] as_uivec3;
    uint[4] as_uivec4;
    Texture as_texture;
  }
}


CRTShader g_shader @builtin;


<* Initialize *>
fn void shader_init() {
  Bulk shader_bulk = bulk::load("resources/001");
  g_shader.sh = shader::load_mem(null, shader_bulk.get("frag_shader"));

  Image mask = image::load_mem(".png", shader_bulk.get("mask"));
  defer mask.unload();
  Image slot = image::load_mem(".png", shader_bulk.get("slot"));
  defer slot.unload();

  g_shader.mask = {
    .location = g_shader.get_loc("u_mask_sampler"),
    .as_texture = mask.texture(),
  };
  g_shader.slot = {
    .location = g_shader.get_loc("u_slot_sampler"),
    .as_texture = slot.texture(),
  };

  g_shader.screen_size = {
    .location = g_shader.get_loc("u_output_size"),
    .as_vec2 = {(float)screen[0], (float)screen[1]},
  };
  g_shader.render_size = {
    .location = g_shader.get_loc("u_game_size"),
    .as_vec2 = {(float)render[0], (float)render[1]},
  };
  g_shader.shift = {
    .location = g_shader.get_loc("u_shift"),
    .as_vec2 = {0.0, 0.0},
  };

  g_shader.zoom = {
    .location = g_shader.get_loc("u_zoom"),
    .as_float = 1.05,
  };
  g_shader.int_scale = {
    .location = g_shader.get_loc("u_do_int_scale"),
    .as_float = 1.0,
  };
  g_shader.aspect = {
    .location = g_shader.get_loc("u_aspect"),
    .as_float = 1.77777777778,
  };
  g_shader.do_tate = {
    .location = g_shader.get_loc("u_do_tate"),
    .as_float = 1.0,
  };
  g_shader.curvature = {
    .location = g_shader.get_loc("u_curvature_amount"),
    .as_float = 0.2,
  };
  g_shader.mask_mirror = {
    .location = g_shader.get_loc("do_mask_mirror"),
    .as_float = 0.0,
  };
  g_shader.mask_strength = {
    .location = g_shader.get_loc("u_mask_strength"),
    .as_float = 0.0,
  };
  g_shader.mask_scale = {
    .location = g_shader.get_loc("u_mask_scale"),
    .as_float = 1.0,
  };
  g_shader.mask_texwidth = {
    .location = g_shader.get_loc("u_mask_tex_width"),
    .as_float = 360.0,
  };
  g_shader.mask_repeat = {
    .location = g_shader.get_loc("u_mask_repeat_on_three"),
    .as_float = 1.0,
  };
  g_shader.mask_shadow = {
    .location = g_shader.get_loc("u_mask_do_shadow"),
    .as_float = 0.0,
  };
  g_shader.slot_strength = {
    .location = g_shader.get_loc("u_slot_strength"),
    .as_float = 1.0,
  };
  g_shader.sl_min = {
    .location = g_shader.get_loc("u_scanline_min"),
    .as_float = 0.1,
  };
  g_shader.sl_fade = {
    .location = g_shader.get_loc("u_scanline_bright_fade"),
    .as_float = 0.4,
  };
  g_shader.sl_shape = {
    .location = g_shader.get_loc("u_scanline_shape"),
    .as_float = 1.5,
  };
  g_shader.random_seed = {
    .location = g_shader.get_loc("u_random_seed"),
    .as_float = 1.0,
  };
  g_shader.glow_spread = {
    .location = g_shader.get_loc("u_glow_spread"),
    .as_float = 0.5,
  };
  g_shader.glow_gamma = {
    .location = g_shader.get_loc("u_glow_gamma"),
    .as_float = 1.0,
  };
  g_shader.glow_strength = {
    .location = g_shader.get_loc("u_glow_strength"),
    .as_float = 0.5,
  };
  g_shader.input_gamma = {
    .location = g_shader.get_loc("u_input_gamma"),
    .as_float = 1.2,
  };
  g_shader.output_gamma = {
    .location = g_shader.get_loc("u_output_gamma"),
    .as_float = 1.2,
  };
  g_shader.softness = {
    .location = g_shader.get_loc("u_softness"),
    .as_float = 1.0,
  };
  g_shader.border_width = {
    .location = g_shader.get_loc("u_border_width"),
    .as_float = 1.0,
  };
  g_shader.border_brightness = {
    .location = g_shader.get_loc("u_border_brightness"),
    .as_float = 0.0,
  };
  g_shader.deconvergence = {
    .location = g_shader.get_loc("u_deconvergence"),
    .as_float = 0.75,
  };
  g_shader.noise = {
    .location = g_shader.get_loc("u_noise_amount"),
    .as_float = 0.1,
  };
  g_shader.glow_over_mask = {
    .location = g_shader.get_loc("u_glow_over_mask"),
    .as_float = 1.0,
  };
  g_shader.post_brightness = {
    .location = g_shader.get_loc("u_post_brightness"),
    .as_float = 1.0,
  };

  shader_update();
}

<* Updates all shader uniforms *>
fn void shader_update() {
  g_shader.set_texture(g_shader.mask.location, g_shader.mask.as_texture);
  g_shader.set_texture(g_shader.slot.location, g_shader.slot.as_texture);

  g_shader.set_value(g_shader.screen_size.location, &g_shader.screen_size.as_float, VEC2);
  g_shader.set_value(g_shader.render_size.location, &g_shader.render_size.as_float, VEC2);
  g_shader.set_value(g_shader.shift.location, &g_shader.shift.as_float, VEC2);

  g_shader.set_value(g_shader.zoom.location, &g_shader.zoom.as_float, FLOAT);
  g_shader.set_value(g_shader.int_scale.location, &g_shader.int_scale.as_float, FLOAT);
  g_shader.set_value(g_shader.aspect.location, &g_shader.aspect.as_float, FLOAT);
  g_shader.set_value(g_shader.do_tate.location, &g_shader.do_tate.as_float, FLOAT);
  g_shader.set_value(g_shader.curvature.location, &g_shader.curvature.as_float, FLOAT);
  g_shader.set_value(g_shader.mask_mirror.location, &g_shader.mask_mirror.as_float, FLOAT);
  g_shader.set_value(g_shader.mask_strength.location, &g_shader.mask_strength.as_float, FLOAT);
  g_shader.set_value(g_shader.mask_scale.location, &g_shader.mask_scale.as_float, FLOAT);
  g_shader.set_value(g_shader.mask_texwidth.location, &g_shader.mask_texwidth.as_float, FLOAT);
  g_shader.set_value(g_shader.mask_repeat.location, &g_shader.mask_repeat.as_float, FLOAT);
  g_shader.set_value(g_shader.mask_shadow.location, &g_shader.mask_shadow.as_float, FLOAT);
  g_shader.set_value(g_shader.slot_strength.location, &g_shader.slot_strength.as_float, FLOAT);
  g_shader.set_value(g_shader.sl_min.location, &g_shader.sl_min.as_float, FLOAT);
  g_shader.set_value(g_shader.sl_fade.location, &g_shader.sl_fade.as_float, FLOAT);
  g_shader.set_value(g_shader.sl_shape.location, &g_shader.sl_shape.as_float, FLOAT);
  g_shader.set_value(g_shader.random_seed.location, &g_shader.random_seed.as_float, FLOAT);
  g_shader.set_value(g_shader.glow_spread.location, &g_shader.glow_spread.as_float, FLOAT);
  g_shader.set_value(g_shader.glow_gamma.location, &g_shader.glow_gamma.as_float, FLOAT);
  g_shader.set_value(g_shader.glow_strength.location, &g_shader.glow_strength.as_float, FLOAT);
  g_shader.set_value(g_shader.input_gamma.location, &g_shader.input_gamma.as_float, FLOAT);
  g_shader.set_value(g_shader.output_gamma.location, &g_shader.output_gamma.as_float, FLOAT);
  g_shader.set_value(g_shader.softness.location, &g_shader.softness.as_float, FLOAT);
  g_shader.set_value(g_shader.border_width.location, &g_shader.border_width.as_float, FLOAT);
  g_shader.set_value(g_shader.border_brightness.location, &g_shader.border_brightness.as_float, FLOAT);
  g_shader.set_value(g_shader.deconvergence.location, &g_shader.deconvergence.as_float, FLOAT);
  g_shader.set_value(g_shader.noise.location, &g_shader.noise.as_float, FLOAT);
  g_shader.set_value(g_shader.glow_over_mask.location, &g_shader.glow_over_mask.as_float, FLOAT);
  g_shader.set_value(g_shader.post_brightness.location, &g_shader.post_brightness.as_float, FLOAT);

}
