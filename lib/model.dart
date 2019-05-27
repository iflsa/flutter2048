import 'dart:math' show Random;

class Board {
  final int row;
  final int column;
  int score;

  Board(this.row, this.column);

  List<List<Tile>> _boardTiles;

  void initBoard() {
    _boardTiles = List.generate(
      4,
      (r) => List.generate(
            4,
            (c) => Tile(
                  row: r,
                  column: c,
                  value: 0,
                  isNew: false,
                  canMarge: false,
                ),
          ),
    );

    score = 0;
    resetCanMarge();
    randomEmptyTile();
    randomEmptyTile();
  }

  void moveLeft() {
    if (!canMoveLeft()) {
      return;
    }

    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        margeLeft(r, c);
      }
    }
    randomEmptyTile();
    resetCanMarge();
  }

  void moveRight() {
    if (!canMoveRight()) {
      return;
    }

    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        margeRight(r, c);
      }
    }
    randomEmptyTile();
    resetCanMarge();
  }

  void moveUp() {
    if (!canMoveUp()) {
      return;
    }

    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        margeUp(r, c);
      }
    }
    randomEmptyTile();
    resetCanMarge();
  }

  void moveDown() {
    if (!canMoveDown()) {
      return;
    }

    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        margeDown(r, c);
      }
    }
    randomEmptyTile();
    resetCanMarge();
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; ++r) {
      for (int c = 1; c < column; ++c) {
        if (canMarge(_boardTiles[r][c], _boardTiles[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c > 0; --c) {
        if (canMarge(_boardTiles[r][c], _boardTiles[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        if (canMarge(_boardTiles[r][c], _boardTiles[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        if (canMarge(_boardTiles[r][c], _boardTiles[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void margeLeft(int row, int col) {
    while (col > 0) {
      marge(_boardTiles[row][col], _boardTiles[row][col - 1]);
      col--;
    }
  }

  void margeRight(int row, int col) {
    while (col < column - 1) {
      marge(_boardTiles[row][col], _boardTiles[row][col + 1]);
      col++;
    }
  }

  void margeUp(int row, int col) {
    while (row > 0) {
      marge(_boardTiles[row][col], _boardTiles[row - 1][col]);
      row--;
    }
  }

  void margeDown(int r, int col) {
    while (r < row - 1) {
      marge(_boardTiles[r][col], _boardTiles[r + 1][col]);
      r++;
    }
  }

  bool canMarge(Tile a, Tile b) {
    return !a.canMarge &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void marge(Tile a, Tile b) {
    if (!canMarge(a, b)) {
      if (!a.isEmpty() && !b.canMarge) {
        b.canMarge = true;
      }
      return;
    }
    if (b.isEmpty()) {
      b.value = a.value;
      a.value = 0;
    } else if (a == b) {
      b.value = b.value * 2;
      a.value = 0;
      b.canMarge = true;
    } else {
      b.canMarge = true;
    }
  }

  Tile getTile(int row, int column) {
    return _boardTiles[row][column];
  }

  void randomEmptyTile() {
    List<Tile> empty = List<Tile>();

    _boardTiles.forEach((rows) {
      empty.addAll(rows.where((tile) => tile.isEmpty()));
    });

    if (empty.isEmpty) {
      return;
    }

    Random rng = Random();
    for (int i = 0; i < 4; i++) {
      int index = rng.nextInt(empty.length);
      empty[index].value = rng.nextInt(9) == 0 ? 4 : 2;
      empty[index].isNew = true;
      empty.removeAt(index);
    }
  }

  void resetCanMarge() {
    _boardTiles.forEach((rows) {
      rows.forEach((tile) {
        tile.canMarge = false;
      });
    });
  }
}

class Tile {
  int row, column;
  int value;
  bool canMarge;
  bool isNew;

  Tile({
    this.row,
    this.column,
    this.value = 0,
    this.canMarge,
    this.isNew,
  });

  bool isEmpty() {
    return value == 0;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  operator ==(other) {
    return other is Tile && value == other.value;
  }
}
