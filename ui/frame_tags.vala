using Gtk;
using Gtk.Stock;

namespace SlideArchiver.Ui
{
    public class FrameTags : Box
    {
        construct
        {
            orientation = Orientation.VERTICAL;

            var addButton = new Button.from_stock(ADD);
            pack_end(addButton, false);

            addButton.clicked.connect(AddTag);
        }

        private async void AddTag(Button button)
        {
            // get user input
            var window = new Window(WindowType.POPUP);
            var box = new Box(Orientation.HORIZONTAL, 1);
            var entry = new Entry();
            box.pack_start(entry);
            var ok = new Button.from_stock(OK);

            ok.clicked.connect(() => {
                window.destroy();
            });

            var cancel = new Button.from_stock(CANCEL);
            box.pack_start(ok);
            box.pack_start(cancel);

            cancel.clicked.connect(() => window.destroy());
            window.attached_to = button;
            window.add(box);
            window.window_position = WindowPosition.MOUSE;
            window.transient_for = (Window)get_ancestor(typeof(Window));

            window.show_all();
            // store in the model

            // update display.
        }
    }
}


