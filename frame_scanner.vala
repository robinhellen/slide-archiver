using Scan;

namespace SlideArchiver
{
    public class FrameScanner : Object, IFrameScanner
    {
        public ScanContext Context {construct; private get;}

        public Frame Scan(Scan.Scanner scanner, FrameData frame, int resolution)
        {
            var session = Context.open_scanner(scanner);
            SetScannerOption(session, "tl-x", 0);
            SetScannerOption(session, "tl-y", 0);
            SetScannerOption(session, "br-x", 0);
            SetScannerOption(session, "br-y", 0);
            return new Frame();
        }

        private void SetScannerOption(ScannerSession session, string optionName, int value)
            throws ScannerError
        {
            var option = session.get_option_by_name<IntOption>(optionName);
            option.set_value(new int[] {value});
        }
    }
}
