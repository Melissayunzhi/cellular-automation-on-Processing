final int CELL_SIZE = 10;       // Size of each cell
PVector gridSize;               // Number of columns and rows in the grid
int[][] grid;                   // 2D array to store the grid
boolean isDrawing;              // Flag to indicate whether the mouse is being dragged

final int DELAY = 500;          // Delay in milliseconds before new cells start following the rules
boolean followRules;            // Flag to indicate whether to follow the rules of Game of Life
boolean isPaused;               // Flag to indicate whether the simulation is paused
int timer;                      // Timer to track the delay
boolean showGrid;

ArrayList<PVector> history;     // History of cell positions for undo

float zoomFactor = 1.0;         // Zoom factor
PVector offset;                 // Offset for panning

void setup() {
  size(800, 800);
  gridSize = new PVector(width / CELL_SIZE, height / CELL_SIZE);

  grid = new int[int(gridSize.x)][int(gridSize.y)];
  isDrawing = false;
  followRules = false;
  isPaused = false;
  timer = millis();
  showGrid = false;

  history = new ArrayList<PVector>();

  offset = new PVector(0, 0);
}

void draw() {
  background(22, 30, 40);

  applyZoomAndOffset();
  displayGrid();

  // Check if the delay has passed and the simulation is not paused
  if (followRules && !isPaused && millis() - timer > DELAY) {
    nextGeneration();  // Calculate the next generation
    timer = millis();  // Reset the timer
  }
}

void applyZoomAndOffset() {
  translate(width / 2, height / 2);
  scale(zoomFactor);
  translate(-width / 2, -height / 2);
  translate(offset.x, offset.y);
}

void displayGrid() {
  if (showGrid) {
    stroke(255,100);
    for (int i = 0; i <= width; i += CELL_SIZE) {
      line(i, 0, i, height);
    }
    for (int j = 0; j <= height; j += CELL_SIZE) {
      line(0, j, width, j);
    }
  }

  // Display the cells
  for (int i = 0; i < gridSize.x; i++) {
    for (int j = 0; j < gridSize.y; j++) {
      int x = i * CELL_SIZE;
      int y = j * CELL_SIZE;

      if (grid[i][j] == 1) {
        // Assign different colors based on the stage of life
        int stage = countNeighbors(i, j);
        if (stage < 2) {
          fill(255, 132, 79);   // white for stage 0
        } else if (stage < 4) {
          fill(250, 206, 124);   // Green for stage 1
        } else {
          fill(113, 224, 216, 150);   // Blue for stage 2 and above
        }

        rect(x, y, CELL_SIZE, CELL_SIZE);
        noStroke();
      }
    }
  }
}


void mousePressed() {
  isDrawing = true;
  history.clear();  // Clear history when starting to draw
}

void mouseReleased() {
  isDrawing = false;
  followRules = true;  // Start following the rules of Game of Life
  timer = millis();    // Reset the timer
}

void mouseDragged() {
  if (isDrawing) {
    // Get the adjusted mouse position based on zoom and offset
    float mouseXAdjusted = (mouseX - offset.x - width / 2) / zoomFactor + width / 2;
    float mouseYAdjusted = (mouseY - offset.y - height / 2) / zoomFactor + height / 2;

    // Get the cell index based on the adjusted mouse position
    int i = int(mouseXAdjusted) / CELL_SIZE;
    int j = int(mouseYAdjusted) / CELL_SIZE;

    // Toggle the cell state
    if (i >= 0 && i < gridSize.x && j >= 0 && j < gridSize.y) {
      grid[i][j] = 1;
      history.add(new PVector(i, j));  // Add cell position to history
    }
  }
}

void keyPressed() {
  if (key == 'r' /*|| key == 'R'*/) {
    // Clear the grid
    for (int i = 0; i < gridSize.x; i++) {
      for (int j = 0; j < gridSize.y; j++) {
        grid[i][j] = 0;
      }
    }
    followRules = false;  // Stop following the rules of Game of Life
    history.clear();      // Clear the history
  } else if (key == ' ') {
    // Pause or continue the simulation
    isPaused = !isPaused;
  } else if (key == 'u' || key == 'U') {
    // Undo the last drawn cell
    if (!history.isEmpty()) {
      PVector cellPos = history.remove(history.size() - 1);
      int i = int(cellPos.x);
      int j = int(cellPos.y);
      grid[i][j] = 0;
    }
  } else if (key == '+') {
    // Zoom in
    zoomFactor *= 1.2;
  } else if (key == '-' || key == '_') {
    // Zoom out
    zoomFactor *= 0.8;
  } else if (key == 'g' || key == 'G') {
    // Toggle grid visibility
    showGrid = !showGrid;
  }
}



// Calculate the next generation based on the Game of Life rules
void nextGeneration() {
  int[][] nextGrid = new int[int(gridSize.x)][int(gridSize.y)];

  // Loop through every cell in the grid
  for (int i = 0; i < gridSize.x; i++) {
    for (int j = 0; j < gridSize.y; j++) {
      int state = grid[i][j];
      int neighbors = countNeighbors(i, j);

      // Apply your custom rules
    //  if (state == 0 && neighbors == 2) {
     //   nextGrid[i][j] = 1;
   //   } else if (state == 1 && neighbors == 3) {
    //    nextGrid[i][j] = 1;
    //  } else {
   //     nextGrid[i][j] = 0;
   //   }
      
            // Apply the "HighLife" rule set
    //  if (state == 0 && (neighbors == 3 || neighbors == 6)) {
     //   nextGrid[i][j] = 1;
   //   } else if (state == 1 && (neighbors == 2 || neighbors == 3)) {
     //   nextGrid[i][j] = 1;
    //  } else {
     //   nextGrid[i][j] = 0;
   //   }
   // Apply the Game of Life rules
      if (state == 0 && neighbors == 3) {
        nextGrid[i][j] = 1;
      } else if (state == 1 && (neighbors < 2 || neighbors > 3)) {
        nextGrid[i][j] = 0;
      } else {
        nextGrid[i][j] = state;
      }
    
           // Apply the custom rule set
     // if (state == 0 && (neighbors == 3 || neighbors == 6)) {
   //     nextGrid[i][j] = 1;
  //    } else if (state == 1 && (neighbors < 2 || neighbors > 4)) {
    //    nextGrid[i][j] = 0;
   //   } else {
   //     nextGrid[i][j] = state;
   //   }
      
      
    }
  }

  // Update the grid with the new generation
  grid = nextGrid;
}

int countNeighbors(int x, int y) {
  int count = 0;

  // Check the 8 neighboring cells
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      int col = (x + i + int(gridSize.x)) % int(gridSize.x);
      int row = (y + j + int(gridSize.y)) % int(gridSize.y);
      count += grid[col][row];
    }
  }

  // Subtract the state of the current cell
  count -= grid[x][y];
  return count;
}
