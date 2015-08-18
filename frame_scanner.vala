using Scan;

namespace SlideArchiver
{
    public class FrameScanner : Object, IFrameScanner
    {
        public ScanContext Context {construct; private get;}

        public Frame Scan(Scan.Scanner scanner, FrameData frame, int resolution)
        {
            var session = Context.open_scanner(scanner);
            PrintCurrentParameters(session);
            session.parameters_changed.connect_after(PrintCurrentParameters);
            PrintCurrentCoordinates(session);
            try
            {
                SetScannerOption(session, "tl-x", frame.Left);
                SetScannerOption(session, "tl-y", frame.Top);
                SetScannerOption(session, "br-x", frame.Right);
                SetScannerOption(session, "br-y", frame.Bottom);
                SetScannerOptionString(session, "source", "Transparency Unit");
                SetScannerOptionInt(session, "resolution", 1200);
                SetScannerOptionString(session, "mode", "Color");
            }
            catch(ScannerError e)
            {
                stderr.printf(@"$(e.message)\n");
            }

            PrintCurrentParameters(session);
            var scanned = session.capture();

            return CreateFrameFromScannedFrame(scanned);
        }

        private void PrintCurrentCoordinates(ScannerSession session)
        {
            var right = GetScannerOption(session, "br-x");
            var left = GetScannerOption(session, "tl-x");
            var bottom = GetScannerOption(session, "br-y");
            var top = GetScannerOption(session, "tl-y");

            stdout.printf(@"Currentframe to capture: ($left, $top) to ($right, $bottom).\n");
        }

        private double GetScannerOption(ScannerSession session, string optionName)
            throws ScannerError
        {
            var option = session.get_option_by_name<FixedOption>(optionName);
            return option.get_value_as_double()[0];
        }

        private void SetScannerOption(ScannerSession session, string optionName, double value)
            throws ScannerError
        {
            var option = session.get_option_by_name<FixedOption>(optionName);
            var result = option.set_value_from_double(new double[] {value});
            stderr.printf(@"Set $optionName to $value$(option.unit). It was actually set to $(result[0])$(option.unit).\n");
        }

        private void SetScannerOptionInt(ScannerSession session, string optionName, int32 value)
            throws ScannerError
        {
            var option = session.get_option_by_name<IntOption>(optionName);
            var result = option.set_value(new int32[] {value});
            stderr.printf(@"Set $optionName to $value$(option.unit). It was actually set to $(result[0])$(option.unit).\n");
        }

        private void SetScannerOptionString(ScannerSession session, string optionName, string value)
            throws ScannerError
        {
            var option = session.get_option_by_name<StringOption>(optionName);
            var result = option.set_value(value);
            stderr.printf(@"Set $optionName to $value$(option.unit). It was actually set to $(result)$(option.unit).\n");
        }

        private void PrintCurrentParameters(ScannerSession session)
        {
            var params = session.current_parameters;
            stderr.printf(@"Current parameters: pixWidth: $((int32)params.pixels_per_line), pixHeight: $((int32)params.lines).\n");
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
