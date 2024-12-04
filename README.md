# omniwallet
Final project for CSEN 268 (Mobile App Development)

Setting up your environment
```
git clone <Repository Name>
git pull
git tag -l
```
In order to pull a particular tag to your computer
```
git tags/<TagName> -b <NewLocalBranchName>
```

How to run fl_chart

For Mac:
```
chmod +w ~/.pub-cache/hosted/pub.dev/fl_chart-0.46.0/lib/src/utils/utils.dart
nano ~/.pub-cache/hosted/pub.dev/fl_chart-0.46.0/lib/src/utils/utils.dart
```

For Windows, find the path:
```
..AppData\Local\Pub\Cache\hosted\pub.dev\fl_chart-0.46.0\lib\src\utils\utils.dart
```
replace:
```
if (MediaQuery.boldTextOverride(context))
```
with:
```
if (MediaQuery.of(context).boldText)
```
delete getTitles and redo
