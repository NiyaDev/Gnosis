
module gnosis::ui;
import std::io;
import std::collections;
import pleroma;
import gnosis;



alias UIHandler = HashMap{String, UIElement};
UIHandler uihandler;

struct UIElement {
  UIType type;
  void* data;
}

enum UIType {
  BAR,
  TEXT,
  VERT_BOX,
  HORI_BOX,
  TEXTBOX,
  TEXTURE_NPATCH,
  BUTTON,
  DROPDOWN,
  // TODO: Status screen
}
enum Alignment {
  TOPLEFT,
  TOP,
  TOPRIGHT,
  LEFT,
  CENTER,
  RIGHT,
  BOTTOMLEFT,
  BOTTOM,
  BOTTOMRIGHT,
}

<* Draw all elements *>
fn void draw() {
  uihandler.@each(; String key, UIElement val) { val.draw(); };
}
<* Remove element *>
fn void remove(String name) {
  mem::free(uihandler.get_ref(name)!!.data);
  uihandler.remove(name)!!;
}
<* Frees all ui data *>
fn void free() {
  uihandler.@each(; String key, UIElement val) {
    val.free();
  };
}

<* Draw element *>
fn void UIElement.draw(&self, Rectangle offset = {0,0,0,0}) {
  switch (self.type) {
    case BAR:
      UIBarData* uidata = (UIBarData*)self.data;
     
      float[2] pos = uidata.alignment.offset(
        {uidata.rect.x, uidata.rect.y},
        {uidata.rect.width, uidata.rect.height},
      );
      Rectangle rectoff = {
        pos[0] + offset.x, pos[1] + offset.y,
        uidata.rect.width + offset.width,
        uidata.rect.height + offset.height, 
      };
      //* Background
      resources::textures[uidata.background]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        rectoff,
        {0,0}, 0,
        uidata.tint,
      );

      //* Bar
      float percent;
      if (uidata.value != null && uidata.max != null) {
        percent = *uidata.value / *uidata.max;
        rectoff.width *= percent;
      } else { percent = 1; }
      resources::textures[uidata.bar]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        rectoff,
        {0,0}, 0,
        uidata.tint,
      );
    case TEXT:
      UITextData* uidata = (UITextData*)self.data;

      // Calculate position
      Font font = resources::fonts[uidata.font]!!;
      float[2] pos = uidata.alignment.offset(
        {uidata.position.x, uidata.position.y},
        raylib::measure_text_ex(font, *uidata.text, uidata.text_size, uidata.text_spacing),
      ); 

      font.draw_pro(
        *uidata.text,
        {pos[0], pos[1]},
        {0,0}, 0,
        uidata.text_size,
        uidata.text_spacing,
        uidata.tint,
      );
    case VERT_BOX:
      UIVerticalBox* uidata = (UIVerticalBox*)self.data;

      float[2] pos = uidata.alignment.offset(
        {uidata.padding.x, uidata.padding.y},
        {uidata.padding.width, uidata.padding.height},
      );

      if (uidata.background != null) {
        resources::textures[uidata.background.texture]!!.draw_npatch(
          uidata.background.npatch,
          {pos[0],pos[1],uidata.background.rect.width,uidata.background.rect.height},
          {0,0}, 0,
          uidata.background.tint,
        );
      }
      for (int i; i < uidata.elements.len(); i++) {
        Rectangle rect = {pos[0],pos[1],uidata.padding.width,uidata.padding.height};
        rect.y *= (float)i;
        rect.y += uidata.padding.y;
        uidata.elements[i].draw(rect);
      }
    case HORI_BOX:
      UIHorizontalBox* uidata = (UIHorizontalBox*)self.data;

      float[2] pos = uidata.alignment.offset(
        {uidata.padding.x, uidata.padding.y},
        {uidata.padding.width, uidata.padding.height},
      );

      if (uidata.background != null) {
        resources::textures[uidata.background.texture]!!.draw_npatch(
          uidata.background.npatch,
          {pos[0],pos[1],uidata.background.rect.width,uidata.background.rect.height},
          {0,0}, 0,
          uidata.background.tint,
        );
      }
      for (int i; i < uidata.elements.len(); i++) {
        Rectangle rect = {pos[0],pos[1],uidata.padding.width,uidata.padding.height};
        rect.x *= (float)i;
        rect.x += uidata.padding.y;
        uidata.elements[i].draw(rect);
      }
    case TEXTBOX:
      UITextbox* tbdata = (UITextbox*)self.data;
      if (tbdata.visible) {
        float[2] pos = tbdata.alignment.offset(
          {tbdata.rect.x, tbdata.rect.y},
          {tbdata.rect.width, tbdata.rect.height},
        );

        //* Background 
        textures[tbdata.background.texture]!!.draw_npatch(
          tbdata.background.npatch,
          {pos[0],pos[1],tbdata.rect.width,tbdata.rect.height},
          {0,0}, 0,
          tbdata.background.tint,
        );

        //* Draw text one character at a time
        Font font = resources::fonts[tbdata.font]!!;
        for (int i; i < tbdata.display.len - 1; i++) {
          if (tbdata.display[i] != 0) {
            // TODO: Allow for rich text formatting and multiple lines
            String str = string::format(allocator::heap(), "%c\0",((String)tbdata.display)[i],);
            font.draw_pro(
              str,
              {
                (pos[0] * 1.6) + tbdata.textspace.x + (float)((float)i * ((tbdata.text_size * 0.6) + tbdata.text_spacing)),
                (pos[1] * 1.6) + tbdata.textspace.y,
              },
              {0,0}, 0,
              tbdata.text_size,
              tbdata.text_spacing,
              color::WHITE,
            );
            str.free(allocator::heap());
          }
        }

        tbdata.timer++;
        if (tbdata.timer >= tbdata.text_speed && tbdata.index < tbdata.display.len-1) {
          tbdata.timer = 0;
          tbdata.display[tbdata.index] = tbdata.text[tbdata.index];
          tbdata.index++;
        }
      }
    case BUTTON:
      UIButtonData* button = (UIButtonData*)self.data;

      float[2] pos = button.alignment.offset(
        {button.rect.x, button.rect.y},
        {button.rect.width, button.rect.height},
      );
      
      // Check if clicked
      Color col;
      float ratio = system::get_screen_ratio();
      Vector2 mouse_pos = raylib::get_mouse_position();
      mouse_pos.x /= ratio;
      mouse_pos.y /= ratio; 

      if (!button.active) {
        col = button.bg_color_disabled;
      } else if (((mouse_pos.x > pos[0] && mouse_pos.x < pos[0] + button.rect.width) && (mouse_pos.y > pos[1] && mouse_pos.y < pos[1] + button.rect.height)) && raylib::is_mouse_button_down(LEFT)) {
        col = button.bg_color_selected;
      } else { col = button.bg_color_default; }

      // Background
      Texture tx = textures[button.background]!!;
      tx.draw_npatch(
        tx.npatch(),
        {pos[0],pos[1],button.rect.width,button.rect.height},
        {0,0}, 0,
        col,
      );

      // Text
      // TODO: The shader distorts where the buttons are on screen
      //       Need to calculate its actual position on screen or
      //       calculate where the mouse would be on the screen.
      fonts[button.font]!!.draw(
        *button.text,
        {pos[0] + button.text_padding.width, pos[1] + button.text_padding.height},
        button.size, button.spacing,
        button.text_color,
      );

      if (((mouse_pos.x > pos[0] && mouse_pos.x < pos[0] + button.rect.width) && (mouse_pos.y > pos[1] && mouse_pos.y < pos[1] + button.rect.height)) && raylib::is_mouse_button_released(LEFT)) {
        button.func();
      }
    //case DROPDOWN:
      
    default:
  }
}
<* Free element *>
fn void UIElement.free(&self) {
  switch (self.type) {
    case VERT_BOX: nextcase;
    case HORI_BOX:
      List{UIElement}* list = ((List{UIElement}*)self.data);
      for (int i; i < list.len(); i++) {
        list[i].free();
      }
    case BAR: nextcase;
    case TEXT:
      mem::free(self.data);
    default:
  }
  uihandler.clear();
}

<* Pushes already created element to ui *>
fn void push(String name, UIElement element) {
  uihandler.set(name, element);
}

<* Add new element to Vertical box
  @require self.type == VERT_BOX || self.type == HORI_BOX
 *>
fn void UIElement.add_element(&self, UIElement element) {
  List{UIElement}* uidata = (List{UIElement}*)self.data;
  uidata.push(element);
}
<* Remove element from Vertical box
  @require self.type == VERT_BOX || self.type == HORI_BOX
 *>
fn void UIElement.remove_element(&self, usz index) {
  List{UIElement}* uidata = (List{UIElement}*)self.data;
  uidata.remove_at(index);
}
<* Get the length of the elements *>
fn usz UIElement.len(&self) {
  List{UIElement}* uidata = (List{UIElement}*)self.data;
  return uidata.len(); 
}


<**>
fn usz String.text_length(&self) {
  return 0;
}

<**>
fn float[2] Alignment.offset(self, float[2] pos, Vector2 textsize) {
  switch (self) {
    case TOPLEFT: return pos;
    case TOP:
      return {
        ((float)system::render[0] / 2) + pos[0] - (textsize.x / 2),
        pos[1],
      };
    case TOPRIGHT:
      return {
        (float)system::render[0] + pos[0],
        pos[1],
      };
    case LEFT:
      return {
        pos[0],
        ((float)system::render[1] / 2) + pos[1] - (textsize.y / 2),
      };
    case CENTER:
      return {
        ((float)system::render[0] / 2) + pos[0] - (textsize.x / 2),
        ((float)system::render[1] / 2) + pos[1] - (textsize.y / 2), 
      };
    case RIGHT:
      return {
        (float)system::render[0] + pos[0],
        ((float)system::render[1] / 2) + pos[1] - (textsize.y / 2),
      };
    case BOTTOMLEFT:
      return {
        pos[0],
        (float)system::render[1] + pos[1],
      };
    case BOTTOM:
      return {
        ((float)system::render[0] / 2) + pos[0] - (textsize.x / 2),
        (float)system::render[1] + pos[1],
      }; 
    case BOTTOMRIGHT:
      return {
        (float)system::render[0] + pos[0],
        (float)system::render[1] + pos[1],
      };
  }
}
