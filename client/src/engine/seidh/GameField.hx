package engine.seidh;

enum abstract CellContent(Int) {
	var EMPTY = 1;
	var PLAYER = 2;
    var BOT = 3;
    var OBSTACLE = 4;
}

class GameFieldCell {

    public var content = CellContent.EMPTY;

    public function new() {
    }

}

class GameField {

    public final gameField = new Map<String, GameFieldCell>();

    private final cellSize:Int;

    public function new(width:Int, height:Int, cellSize:Int) {
        this.cellSize = cellSize;

        for (x in 0...width) {
            for (y in 0...height) {
                gameField.set(x + '/' + y, new GameFieldCell());
            }
        }
    }

    public function coordsToCell() {
        
    }

}

