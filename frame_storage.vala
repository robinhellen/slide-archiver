using Gdk;

namespace SlideArchiver
{
    public class NullFrameStorage : Object, IFrameStorage
    {
        public void Store(Frame frame, PictureData data, int sequenceNo)
        {
        }
    }

    public class PicturesFolderFrameStorage : Object, IFrameStorage
    {


        public void Store(Frame frame, PictureData data, int sequenceNo)
        {
            stderr.printf(@"Storing frame: lines:$(frame.Lines), pixelsPerLine:$(frame.PixelsPerLine).\n");

            var pixbuf = new Pixbuf.from_data(frame.data, Colorspace.RGB, false, 16, frame.PixelsPerLine, frame.Lines, frame.BytesPerLine);
            pixbuf.save("/home/robin/Pictures/foo.jpg", "jpeg");
        }
    }
}
