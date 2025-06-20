import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:homepage/screens/home_screen.dart';

void main() => runApp(SketchApp());

class SketchApp extends StatelessWidget {
  const SketchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sketch & Scribble',
      debugShowCheckedModeBanner: false,
      home: SketchHomePage(),
    );
  }
}

class SketchHomePage extends StatefulWidget {
  const SketchHomePage({super.key});

  @override
  _SketchHomePageState createState() => _SketchHomePageState();
}

class _SketchHomePageState extends State<SketchHomePage> {
  final List<SketchLine> _lines = [];
  final List<SketchLine> _undoneLines = [];
  SketchLine _currentLine = SketchLine([], Colors.black, 4.0);
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;
  bool _isErasing = false;
  bool _showPenSizeSlider = false;
  bool _showEraserSizeSlider = false;

  void _startLine(Offset point) {
    setState(() {
      _currentLine = SketchLine(
        [point],
        _isErasing ? Colors.white : _selectedColor,
        _strokeWidth,
      );
    });
  }

  void _appendPoint(Offset point) {
    setState(() {
      _currentLine.path.add(point);
    });
  }

  void _endLine() {
    setState(() {
      _lines.add(_currentLine);
      _undoneLines.clear();
    });
  }

  void _undo() {
    if (_lines.isNotEmpty) {
      setState(() {
        _undoneLines.add(_lines.removeLast());
      });
    }
  }

  void _redo() {
    if (_undoneLines.isNotEmpty) {
      setState(() {
        _lines.add(_undoneLines.removeLast());
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      _lines.clear();
      _undoneLines.clear();
    });
  }

  void _pickColor() async {
    Color? color = await showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(_selectedColor),
    );
    if (color != null) {
      setState(() {
        _selectedColor = color;
        _isErasing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onPanStart: (details) => _startLine(details.localPosition),
              onPanUpdate: (details) => _appendPoint(details.localPosition),
              onPanEnd: (details) => _endLine(),
              child: CustomPaint(
                painter: SketchPainter(_lines, _currentLine),
                child: Container(),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 28),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );

                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_showPenSizeSlider)
                        Slider(
                          value: _strokeWidth,
                          min: 1,
                          max: 20,
                          activeColor: Colors.black,
                          onChanged: (value) {
                            setState(() => _strokeWidth = value);
                          },
                        ),
                      if (_showEraserSizeSlider)
                        Slider(
                          value: _strokeWidth,
                          min: 1,
                          max: 20,
                          activeColor: Colors.black,
                          onChanged: (value) {
                            setState(() => _strokeWidth = value);
                          },
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.brush,
                                color: !_isErasing ? Colors.black : Colors.grey),
                            onPressed: () {
                              setState(() {
                                _isErasing = false;
                                _showPenSizeSlider = !_showPenSizeSlider;
                                _showEraserSizeSlider = false;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.color_lens, color: _selectedColor),
                            onPressed: _pickColor,
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle,
                                color: _isErasing ? Colors.black : Colors.grey),
                            onPressed: () {
                              setState(() {
                                _isErasing = true;
                                _showEraserSizeSlider = !_showEraserSizeSlider;
                                _showPenSizeSlider = false;
                              });
                            },
                          ),
                          IconButton(icon: Icon(Icons.undo), onPressed: _undo),
                          IconButton(icon: Icon(Icons.redo), onPressed: _redo),
                          IconButton(icon: Icon(Icons.delete), onPressed: _clearCanvas),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SketchLine {
  List<Offset> path;
  Color color;
  double strokeWidth;

  SketchLine(this.path, this.color, this.strokeWidth);
}

class SketchPainter extends CustomPainter {
  final List<SketchLine> lines;
  final SketchLine currentLine;

  SketchPainter(this.lines, this.currentLine);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      _drawLine(canvas, line);
    }
    _drawLine(canvas, currentLine);
  }

  void _drawLine(Canvas canvas, SketchLine line) {
    final paint = Paint()
      ..color = line.color
      ..strokeWidth = line.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < line.path.length - 1; i++) {
      canvas.drawLine(line.path[i], line.path[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const ColorPickerDialog(this.initialColor, {super.key});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a Color"),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
            });
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () => Navigator.of(context).pop(selectedColor),
            child: Text("Select")),
      ],
    );
  }

}
