import 'package:flutter/material.dart';
import 'grid_display_screen.dart';

class GridInputScreen extends StatefulWidget {
  @override
  _GridInputScreenState createState() => _GridInputScreenState();
}

class _GridInputScreenState extends State<GridInputScreen> {
  final TextEditingController _mController = TextEditingController();
  final TextEditingController _nController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter m and n for the grid'),
            SizedBox(height: 20),
            TextFormField(
              controller: _mController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter m'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _nController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter n'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int m = int.tryParse(_mController.text) ?? 0;
                int n = int.tryParse(_nController.text) ?? 0;

                // Validate m and n (you can add more validation if needed)
                if (m > 0 && n > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GridDisplayScreen(m: m, n: n),
                    ),
                  );
                } else {
                  // Show an error message if m or n is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid values for m and n.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
