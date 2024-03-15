import 'package:flutter/material.dart';
// import 'result_screen.dart';

class GridDisplayScreen extends StatefulWidget {
  final int m;
  final int n;

  GridDisplayScreen({required this.m, required this.n});

  @override
  _GridDisplayScreenState createState() => _GridDisplayScreenState();
}

class _GridDisplayScreenState extends State<GridDisplayScreen> {
  List<List<TextEditingController>> gridControllers = [];
  TextEditingController _searchController = TextEditingController();
  List<List<bool>> highlightedCells = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    initializeGrid();
    initializeHighlightedCells();
  }

  void initializeGrid() {
    // Initialize grid controllers with the specified dimensions
    gridControllers = List.generate(
      widget.m,
      (row) => List.generate(
        widget.n,
        (col) => TextEditingController(),
      ),
    );
  }

  void initializeHighlightedCells() {
    // Initialize a matrix to track highlighted cells
    highlightedCells = List.generate(
        widget.m, (row) => List.generate(widget.n, (col) => false));
  }

  void highlightMatchingText(String searchText) {
    // Reset highlighted cells
    initializeHighlightedCells();

    // Iterate through the grid and highlight matching cells
    for (int row = 0; row < widget.m; row++) {
      for (int col = 0; col < widget.n; col++) {
        if (searchText.isNotEmpty &&
            gridControllers[row][col].text == searchText) {
          // Check for matches in all directions
          checkAndHighlight(row, col, searchText, 0, 1); // East
          checkAndHighlight(row, col, searchText, 1, 0); // South
          checkAndHighlight(row, col, searchText, 1, 1); // South-East
        }
      }
    }
  }

  void checkAndHighlight(
      int row, int col, String searchText, int rowChange, int colChange) {
    int length = searchText.length;

    for (int i = 0; i < length; i++) {
      int newRow = row + i * rowChange;
      int newCol = col + i * colChange;

      if (newRow >= widget.m ||
          newCol >= widget.n ||
          gridControllers[newRow][newCol].text != searchText) {
        // Stop checking if there's no match or if out of bounds
        return;
      }
    }

    // If we reach here, it means there's a match, so highlight the cells
    for (int i = 0; i < length; i++) {
      int newRow = row + i * rowChange;
      int newCol = col + i * colChange;
      highlightedCells[newRow][newCol] = true;
    }

    // Update the UI after highlighting
    setState(() {});
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void endSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
      initializeHighlightedCells(); // Clear highlighting when ending the search
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Display'),
        actions: [
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    endSearch();
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    startSearch();
                  },
                ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Navigate back to the grid input screen to reset the app
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              child: Container(
                constraints: BoxConstraints(maxHeight: 400),
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.n,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: widget.m * widget.n,
                  itemBuilder: (context, index) {
                    int row = index ~/ widget.n;
                    int col = index % widget.n;

                    return TextField(
                      controller: gridControllers[row][col],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        // Update the grid when the user enters an alphabet
                        checkAndHighlight(
                            row, col, _searchController.text, 0, 1);
                        checkAndHighlight(
                            row, col, _searchController.text, 1, 0);
                        checkAndHighlight(
                            row, col, _searchController.text, 1, 1);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor:
                            highlightedCells[row][col] ? Colors.yellow : null,
                        filled: highlightedCells[row][col],
                        counterText:
                            '', // Remove the counter text below the TextField
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isSearching)
              TextField(
                controller: _searchController,
                decoration: InputDecoration(labelText: 'Enter text to search'),
                onChanged: (value) {
                  // Highlight the matching cells in the grid when the search text changes
                  highlightMatchingText(value);
                  setState(() {});
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String searchText = _searchController.text;
                // Highlight the matching cells in the grid
                highlightMatchingText(searchText);

                // Navigate to the result screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ResultScreen(
                //       searchText: searchText,
                //       grid: gridControllers
                //           .map((row) =>
                //               row.map((controller) => controller.text).toList())
                //           .toList(),
                //       highlightedCells: highlightedCells,
                //     ),
                //   ),
                // );
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
