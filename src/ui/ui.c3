
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
  // TODO: Status screen
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
      
      Rectangle rectoff = {
        uidata.rect.x + offset.x,
        uidata.rect.y + offset.y,
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
      float percent = *uidata.value / *uidata.max;
      rectoff.width *= percent;
      resources::textures[uidata.bar]!!.draw_npatch(
        {{0,0,24,8},8,8,8,8,THREE_PATCH_HORIZONTAL},
        rectoff,
        {0,0}, 0,
        uidata.tint,
      );
    case TEXT:
      UITextData* uidata = (UITextData*)self.data;

      resources::fonts[uidata.font]!!.draw_pro(
        *uidata.text,
        uidata.position,
        {0,0}, 0,
        uidata.text_size,
        uidata.text_spacing,
        uidata.tint,
      );
    case VERT_BOX:
      UIVerticalBox* uidata = (UIVerticalBox*)self.data;

      if (uidata.background != null) {
        resources::textures[uidata.background.texture]!!.draw_npatch(
          uidata.background.npatch,
          uidata.background.rect,
          {0,0}, 0,
          uidata.background.tint,
        );
      }
      for (int i; i < uidata.elements.len(); i++) {
        Rectangle rect = uidata.padding;
        rect.y *= (float)i;
        rect.y += uidata.padding.y;
        uidata.elements[i].draw(rect);
      }
    case HORI_BOX:
      UIHorizontalBox* uidata = (UIHorizontalBox*)self.data;

      if (uidata.background != null) {
        resources::textures[uidata.background.texture]!!.draw_npatch(
          uidata.background.npatch,
          uidata.background.rect,
          {0,0}, 0,
          uidata.background.tint,
        );
      }
      for (int i; i < uidata.elements.len(); i++) {
        Rectangle rect = uidata.padding;
        rect.x *= (float)i;
        rect.x += uidata.padding.y;
        uidata.elements[i].draw(rect);
      }
    case TEXTBOX:
      UITextbox* tbdata = (UITextbox*)self.data;
      if (tbdata.visible) {
        //* Background 
        textures[tbdata.background.texture]!!.draw_npatch(
          tbdata.background.npatch,
          tbdata.rect,
          {0,0}, 0,
          tbdata.background.tint,
        );

        //* Draw text one character at a time
        Font font = resources::fonts[tbdata.font]!!;
        for (int i; i < tbdata.display.len - 1; i++) {
          if (tbdata.display[i] != 0) {
            // TODO: Allow for rich text formatting
            String str = string::format(allocator::heap(), "%c\0",((String)tbdata.display)[i],);
            font.draw_pro(
              str,
              {
                tbdata.textspace.x + (float)((float)i * ((tbdata.text_size * 0.6) + tbdata.text_spacing)),
                tbdata.textspace.y,
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
      
      // Check if clicked
      Color col;
      float ratio = system::get_screen_ratio();
      Vector2 mouse_pos = raylib::get_mouse_position();
      mouse_pos.x /= ratio;
      mouse_pos.y /= ratio; 

      if (!button.active) {
        col = button.bg_color_disabled;
      } else if (((mouse_pos.x > button.rect.x && mouse_pos.x < button.rect.x + button.rect.width) && (mouse_pos.y > button.rect.y && mouse_pos.y < button.rect.y + button.rect.height)) && raylib::is_mouse_button_down(LEFT)) {
        col = button.bg_color_selected;
      } else { col = button.bg_color_default; }

      // Background
      Texture tx = textures[button.background]!!;
      tx.draw_npatch(
        tx.npatch(),
        button.rect,
        {0,0}, 0,
        col,
      );

      // Text
      // TODO: The shader distorts where the buttons are on screen
      //       Need to calculate its actual position on screen or
      //       calculate where the mouse would be on the screen.
      fonts[button.font]!!.draw(
        *button.text,
        {button.rect.x + button.text_padding.width, button.rect.y + button.text_padding.height},
        button.size, button.spacing,
        button.text_color,
      );

      if (((mouse_pos.x > button.rect.x && mouse_pos.x < button.rect.x + button.rect.width) && (mouse_pos.y > button.rect.y && mouse_pos.y < button.rect.y + button.rect.height)) && raylib::is_mouse_button_released(LEFT)) {
        button.func();
      }

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
