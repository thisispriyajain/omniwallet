# omniwallet
Final project for CSEN 268 (Mobile App Development)

How to run fl_chart:

For Mac:
chmod +w ~/.pub-cache/hosted/pub.dev/fl_chart-0.46.0/lib/src/utils/utils.dart
nano ~/.pub-cache/hosted/pub.dev/fl_chart-0.46.0/lib/src/utils/utils.dart

Window:
..AppData\Local\Pub\Cache\hosted\pub.dev\fl_chart-0.46.0\lib\src\utils\utils.dart

replace:
if (MediaQuery.boldTextOverride(context))
with:
if (MediaQuery.of(context).boldText)
