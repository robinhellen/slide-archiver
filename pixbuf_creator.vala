using Gdk;

namespace SlideArchiver
{
    public class PixbufCreator : Object
    {
        public Pixbuf CreatePixbufFromScannedFrame(Frame frame)
        {
            // take every other byte from the data
            var newDataLength = frame.data.length / 2;
            var eightBitData = new uint8[newDataLength];
            for(int i = 0; i < newDataLength; i++)
            {
                eightBitData[i] = frame.data[i * 2 + 1];
            }

            return new Pixbuf.from_data(eightBitData, Colorspace.RGB, false, 8, frame.PixelsPerLine, frame.Lines, frame.BytesPerLine / 2);
        }

        public Pixbuf CreateScaledPixbufFromScannedFrame(Frame frame, int height)
        {
            var unscaled = CreatePixbufFromScannedFrame(frame);
            var width = height * frame.PixelsPerLine / frame.Lines;

            return unscaled.scale_simple(width, height, InterpType.BILINEAR);
        }
    }
}
