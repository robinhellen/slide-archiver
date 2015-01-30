using Scan;

namespace SlideArchiver
{
    public class FrameScanner : Object, IFrameScanner
    {
        public ScanContext Context {construct; private get;}

        public Frame Scan(Scan.Scanner scanner, FrameData frame, int resolution)
        {
            var session = Context.open_scanner(scanner);
            SetScannerOption(session, "tl-x", 9.095);
            SetScannerOption(session, "tl-y", 4.418);
            SetScannerOption(session, "br-x", 11.820);
            SetScannerOption(session, "br-y", 6.722);

            var scanned = session.capture();

            return new Frame();
        }

        private void SetScannerOption(ScannerSession session, string optionName, double value)
            throws ScannerError
        {
            var option = session.get_option_by_name<FixedOption>(optionName);
            option.set_value_from_double(new double[] {value});
        }
    }
}
