/**
 * This class grabs key events from main window and invokes hanlders bound to accelerators
 * 
 * @author Libor Zoubek <jezz_at_seznam.cz>
 */
public class KeyBindingManager : GLib.Object
{
  /**
   * list of binded keybindings
   */
  private Gee.List<KeyBinding> bindings = new Gee.ArrayList<KeyBinding>();

  /**
   * Helper class to store keybinding
   */
  private class KeyBinding
  {
    public KeyBinding(string accelerator, uint keycode,
        Gdk.ModifierType modifiers, KeyBindingHandlerFunc handler)
    {
      this.accelerator = accelerator;
      this.keycode = keycode;
      this.modifiers = modifiers;
      this.handler = handler;
    }

    public string accelerator { get; set; }
    public uint keycode { get; set; }
    public Gdk.ModifierType modifiers { get; set; }
    public KeyBindingHandlerFunc handler { get; set; }
  }

  /**
   * Keybinding func needed to bind key to handler
   * 
   * @param event passing on gdk EventKey
   */
  public delegate void KeyBindingHandlerFunc(Gdk.EventKey event);

  public KeyBindingManager(Vide.MainWindow win)
  {
    win.key_press_event.connect((event) => {
        bool ret = false;
        foreach (KeyBinding binding in bindings) {
        if ((event.state & binding.modifiers)!=0 && event.keyval == binding.keycode) {
        binding.handler(event);
        ret |= true;
        }
        }
        return ret;
        });
  }

  /**
   * Bind accelerator to given handler
   *
   * @param accelerator accelerator parsable by Gtk.accelerator_parse
   * @param handler handler called when given accelerator is pressed
   */
  public void bind(string accelerator, KeyBindingHandlerFunc handler)
  {
    // debug("Binding key " + accelerator);
    // convert accelerator
    uint keysym;
    Gdk.ModifierType modifiers;
    Gtk.accelerator_parse(accelerator, out keysym, out modifiers);
    bindings.add(new KeyBinding(accelerator, keysym, modifiers, handler));
    // debug("Successfully binded key " + accelerator);
  }

  /**
   * Unbind given accelerator.
   *
   * @param accelerator accelerator parsable by Gtk.accelerator_parse
   */
  public void unbind(string accelerator)
  {
    // debug("Unbinding key " + accelerator);
    // unbind all keys with given accelerator
    Gee.List<KeyBinding> remove_bindings = new Gee.ArrayList<KeyBinding>();
    foreach (KeyBinding binding in bindings) {
      if (binding.accelerator == accelerator) {
        remove_bindings.add(binding);
      }
    }
    // remove unbinded keys
    bindings.remove_all(remove_bindings);
  }
}
