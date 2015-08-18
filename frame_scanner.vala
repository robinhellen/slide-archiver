using Scan;

namespace SlideArchiver
{
    public class FrameScanner : Object, IFrameScanner
    {
        public ScanContext Context {construct; private get;}

        public Frame Scan(Scan.Scanner scanner, FrameData frame, int resolution)
        {
            var session = Context.open_scanner(scanner);
            try
            {
                SetScannerOption(session, "tl-x", frame.Left);
                SetScannerOption(session, "tl-y", frame.Top);
                SetScannerOption(session, "br-x", frame.Right);
                SetScannerOption(session, "br-y", frame.Bottom);
                SetScannerOptionString(session, "source", "Transparency Unit");
                SetScannerOptionInt(session, "resolution", resolution);
                SetScannerOptionString(session, "mode", "Color");
            }
            catch(ScannerError e)
            {
                stderr.printf(@"$(e.message)\n");
            }

            var scanned = session.capture();

            return CreateFrameFromScannedFrame(scanned);
        }

        private void SetScannerOption(ScannerSession session, string optionName, double value)
            throws ScannerError
        {
            var option = session.get_option_by_name<FixedOption>(optionName);
            var result = option.set_value_from_double(new double[] {value});
        }

        private void SetScannerOptionInt(ScannerSession session, string optionName, int32 value)
            throws ScannerError
        {
            var option = session.get_option_by_name<IntOption>(optionName);
            var result = option.set_value(new int32[] {value});
        }

        private void SetScannerOptionString(ScannerSession session, string optionName, string value)
            throws ScannerError
        {
            var option = session.get_option_by_name<StringOption>(optionName);
            var result = option.set_value(value);
        }

        private Frame CreateFrameFromScannedFrame(ScannedFrame scanned)
        {
            var frame = new Frame();
            frame.BytesPerLine = scanned.BytesPerLine;
            frame.Depth = scanned.Depth;
            frame.data = scanned.data;
            frame.Lines = scanned.Lines;
            frame.PixelsPerLine = scanned.PixelsPerLine;
            return frame;
        }
    }
}
