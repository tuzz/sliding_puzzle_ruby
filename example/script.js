var App = function () {
  var self = this;

  var canvas = document.getElementById("canvas");
  var context = canvas.getContext("2d");

  var tiles = [
    [4, 2, 3],
    [7, 0, 6],
    [1, 5, 8],
  ];

  var slidingTile, slidingDirection, slidingCallback;
  var offset = { x: 0, y: 0 };
  var solution;

  var colors = [
    null,
    "#d7f4fe",
    "#dcd2fe",
    "#fed7e7",
    "#cff7f4",
    "#fbeed0",
    "#fdb9b4",
    "#d6efd1",
    "#fed0b9",
  ]

  self.run = function () {
    canvas.addEventListener("mousedown", canvasTouched);
    fetchSolution();

    setInterval(render, 1000 / 30);
  }

  self.slide = function (direction, callback) {
    callback = callback || function () {};

    var x, y;
    eachTile(function (tile, row, column, isBlank) {
      if (isBlank) { x = column; y = row; }
    });

    switch (direction) {
      case "left":  x += 1; break;
      case "right": x -= 1; break;
      case "up":    y += 1; break;
      case "down":  y -= 1; break;
    }

    if (outOfBounds(x, y)) {
      callback(false);
      return;
    }

    slidingTile = tiles[y][x];
    slidingDirection = direction;
    slidingFinished = callback;
  };

  self.scramble = function (moves, previous) {
    if (moves === 0) return;

    var directions = ["left", "right", "up", "down"];
    var random = Math.floor(Math.random() * directions.length);
    var direction = directions[random];

    if (direction === opposite(previous)) {
      self.scramble(moves, previous);
      return;
    }

    self.slide(direction, function (success) {
      if (success) {
        moves -= 1;
        self.scramble(moves, direction);
      } else {
        self.scramble(moves, previous);
      }
    });
  };

  self.step = function (callback) {
    if (solution.length === 0) return;
    self.slide(solution[0], callback);
  };

  self.solve = function () {
    self.step(self.solve);
  };

  var render = function () {
    context.clearRect(0, 0, canvas.width, canvas.height);

    slideTile();

    eachTile(function (tile, row, column, isBlank) {
      if (!isBlank) renderTile(tile, row, column);
    });
  };

  var eachTile = function (callback) {
    for (var row = 0; row < tiles.length; row += 1) {
      var numbers = tiles[row];

      for (var column = 0; column < numbers.length; column += 1) {
        var tile = tiles[row][column];
        callback(tile, row, column, tile === 0);
      }
    }
  }

  var renderTile = function (tile, row, column) { var border = canvas.width * 0.01;
    var size = (canvas.width - border) / 3;

    var x = column * size + border / 2;
    var y = row * size + border / 2;

    if (tile === slidingTile) {
      x += offset.x * size;
      y += offset.y * size;
    }

    context.fillStyle = colors[tile];
    context.fillRect(x, y, size, size);

    context.lineWidth = border; context.strokeStyle = "#444";
    context.strokeRect(x, y, size, size);

    context.font = "80px Helvetica";
    context.textAlign = "center";
    context.fillStyle = "#444";
    context.fillText(tile, x + 65, y + 90);
  };

  var slideTile = function () {
    var absolute = Math.abs(offset.x + offset.y);
    if (absolute >= 1) finishSliding();

    switch (slidingDirection) {
      case "left":  offset.x -= 0.25; break;
      case "right": offset.x += 0.25; break;
      case "up":    offset.y -= 0.25; break;
      case "down":  offset.y += 0.25; break;
    }
  };

  var startSliding = function (row, column) {
    if (slidingDirection) return;

    var x, y;
    eachTile(function (tile, row, column, isBlank) {
      if (isBlank) { x = column; y = row; }
    });

    if (x + 1 === column && y === row) self.slide("left");
    if (x - 1 === column && y === row) self.slide("right");
    if (x === column && y + 1 === row) self.slide("up");
    if (x === column && y - 1 === row) self.slide("down");
  }

  var finishSliding = function () {
    eachTile(function (tile, row, column, isBlank) {
      if (tile === slidingTile) tiles[row][column] = 0;
      if (isBlank) tiles[row][column] = slidingTile;
    });

    slidingTile = undefined;
    slidingDirection = undefined;
    offset = { x: 0, y: 0 };

    fetchSolution(function () {
      slidingFinished(true);
    });
  };

  var canvasTouched = function (event) {
    var bounds = canvas.getBoundingClientRect();

    var x = event.x - bounds.x;
    var y = event.y - bounds.y;

    var column = Math.floor(x / canvas.width * 3);
    var row = Math.floor(y / canvas.width * 3);

    startSliding(row, column);
  };

  var outOfBounds = function (x, y) {
    return x < 0 || x >= 3 || y < 0 || y >= 3;
  };

  var opposite = function (direction) {
    switch (direction) {
      case "left":  return "right";
      case "right": return "left";
      case "up":    return "down";
      case "down":  return "up";
    }
  };

  var fetchSolution = function (callback) {
    callback = callback || function () {};
    var puzzle = "";

    puzzle += tiles[0].join() + ":";
    puzzle += tiles[1].join() + ":";
    puzzle += tiles[2].join();

    var link = document.getElementById("encoding");
    link.innerHTML = "/" + puzzle;
    link.setAttribute("href", "/" + puzzle);

    get(puzzle, function (moves) {
      solution = moves;

      var html = "";
      for (var i = 0; i < moves.length; i += 1) {
        html += "<div class='move'>" + moves[i] + "</div>";
      }

      if (solution.length === 0) {
        html = "Puzzle is solved.";
      }

      document.getElementById("moves").innerHTML = html;
      callback();
    });
  }

  var get = function (url, callback) {
    var xmlhttp = new XMLHttpRequest();

    xmlhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        var data = JSON.parse(this.responseText);
        callback(data);
      }
    };

    xmlhttp.open("GET", url, true);
    xmlhttp.send();
  };
};

var app = new App();
app.run();
