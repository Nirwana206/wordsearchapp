import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final List<List<String>> grid;

  SearchScreen({required this.grid});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<List<bool>> highlightedCells = [];

  @override
  void initState() {
    super.initState();
    initializeHighlightedCells();
  }

  void initializeHighlightedCells() {
    // Initialize a matrix to track highlighted cells
    highlightedCells = List.generate(widget.grid.length,
        (row) => List.generate(widget.grid[row].length, (col) => false));
  }

  void highlightMatchingText(String searchText) {
    // Reset highlighted cells
    initializeHighlightedCells();

    // Iterate through the grid and highlight matching cells
    for (int row = 0; row < widget.grid.length; row++) {
      for (int col = 0; col < widget.grid[row].length; col++) {
        if (searchText.isNotEmpty &&
            widget.grid[row][col].toLowerCase() ==
                searchText[0].toLowerCase()) {
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

      if (newRow >= widget.grid.length ||
          newCol >= widget.grid[row].length ||
          widget.grid[newRow][newCol].toLowerCase() !=
              searchText[i].toLowerCase()) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Enter text to search'),
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
                //       grid: widget.grid,
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
