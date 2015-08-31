using Gee;
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

        public async Frame ScanAsync(Scan.Scanner scanner, FrameData frame, int resolution, ProgressReporter? reporter = null)
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

            var scanned = yield session.capture_async(reporter);

            // We need to do the callback like this otherwise the session won't get cleaned up until the whole async chain finishes!
            Idle.add(ScanAsync.callback);
            yield;

            return CreateFrameFromScannedFrame(scanned);
        }

        public async Collection<Frame> ScanFramesAsync(Scan.Scanner scanner, Collection<FrameData> frames, int resolution, ProgressReporter? reporter = null)
        {
            var frameDataScanned = (FrameData)Object.new(typeof(FrameData),
                Left: Min<FrameData>(frames, frame => frame.Left),
                Right: Max<FrameData>(frames, frame => frame.Right),
                Top: Min<FrameData>(frames, frame => frame.Top),
                Bottom: Max<FrameData>(frames, frame => frame.Bottom));

            var session = Context.open_scanner(scanner);
            try
            {
                SetScannerOption(session, "tl-x", Min<FrameData>(frames, frame => frame.Left));
                SetScannerOption(session, "tl-y", Min<FrameData>(frames, frame => frame.Top));
                SetScannerOption(session, "br-x", Max<FrameData>(frames, frame => frame.Right));
                SetScannerOption(session, "br-y", Max<FrameData>(frames, frame => frame.Bottom));
                SetScannerOptionString(session, "source", "Transparency Unit");
                SetScannerOptionInt(session, "resolution", resolution);
                SetScannerOptionString(session, "mode", "Color");
            }
            catch(ScannerError e)
            {
                stderr.printf(@"$(e.message)\n");
            }

            var scanned = yield session.capture_async(reporter);

            // We need to do the callback like this otherwise the session won't get cleaned up until the whole async chain finishes!
            Idle.add(ScanFramesAsync.callback);
            yield;

            //return CreateFrameFromScannedFrame(scanned);
            var result = frames.map<Frame>(fd => CreateSubFrameFromScannedFrame(scanned, fd, frameDataScanned));
            var retval = new ArrayList<Frame>();
            result.foreach(f => retval.add(f));
            return retval;
        }

        private double Min<T>(Traversable<T> traversable, MapFunc<double?, T> f)
        {
            return traversable.map<double?>(f).fold<double?>((v, m) => v < m ? v :m, double.MAX);
        }

        private double Max<T>(Traversable<T> traversable, MapFunc<double?, T> f)
        {
            return traversable.map<double?>(f).fold<double?>((v, m) => v > m ? v :m, double.MIN);
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

        private Frame CreateSubFrameFromScannedFrame(ScannedFrame scanned, FrameData data, FrameData asScanned)
        {
            // currently assumes all frames have the same left, right
            var frame = new Frame();
            frame.BytesPerLine = scanned.BytesPerLine;
            frame.PixelsPerLine = scanned.PixelsPerLine;
            frame.Depth = scanned.Depth;

            int topLine = (int) (((data.Top - asScanned.Top) * scanned.Lines) / (asScanned.Bottom - asScanned.Top));
            int bottomLine = int.min((int) (((data.Bottom - asScanned.Top) * scanned.Lines) / (asScanned.Bottom - asScanned.Top) + 1), scanned.Lines);

            frame.Lines = bottomLine - topLine;
            var startByte = (topLine * frame.BytesPerLine);
            frame.data = new uint8[frame.Lines * frame.BytesPerLine];
            for(int i = 0; i < (frame.Lines * frame.BytesPerLine); i++)
            {
                frame.data[i] = scanned.data[i + startByte];
            }
            return frame;
        }
    }
}
