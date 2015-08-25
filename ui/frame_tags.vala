using Gtk;
using Gtk.Stock;

namespace SlideArchiver.Ui
{
    public class FrameTags : Box
    {
        public FrameData Frame {construct; get;}
        private FlowBox flow;

        public FrameTags(FrameData frame)
        {
            Object(Frame: frame);
        }

        construct
        {
            orientation = Orientation.VERTICAL;
            homogeneous = false;

            flow = new FlowBox();
            flow.orientation = Orientation.HORIZONTAL;
            flow.min_children_per_line = 4;
            flow.homogeneous = false;
            pack_start(flow, true, true);

            var addButton = new Button.from_stock(ADD);
            pack_end(addButton, false);

            addButton.clicked.connect(AddTag);
        }

        private async void AddTag(Button button)
        {
            // get user input
            var window = new Window(WindowType.TOPLEVEL);
            window.decorated = false;
            var box = new Box(Orientation.HORIZONTAL, 1);
            var entry = new Entry();
            box.pack_start(entry);
            var ok = new Button.from_stock(OK);

            ok.clicked.connect(() => {
                var tag = entry.text.strip();
                if(tag.length != 0)
                {
                    Frame.Tags.add(tag);
                    var label = new TagLabel(Frame, tag);
                    flow.add(label);
                    label.show_all();
                }
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
        }

        private class TagLabel : Box
        {
            public FrameData Frame {construct; get;}
            public string Tag {construct; get;}

            public TagLabel(FrameData frame, string tag)
            {
                Object(Frame: frame, Tag: tag);
                orientation = Orientation.HORIZONTAL;
            }

            construct
            {
                pack_start(new Label(Tag), false);
            }
        }
    }
}


