var xTurn = true;
var fullColumns = [];
const rows = ["F", "E", "D", "C", "B", "A"];
const numColumns = 7;
const columnFull = `This column is full. Please try again.<br>It is still Player ${getTurn()}'s turn.`;

function placeToken(col) {
  col = col[1];
  if (fullColumns.includes(col)) {
     setNotice(columnFull);
     return;
  }
  for (const row of rows) {
    if (getValue(row, col)) {
      continue;
    }  else {
      setValue(row, col);
      if (gameOver()) {
        celebrate();
      } else {
        changeTurn();
      };
      return;
    }
  }
  fullColumns.push(col);
  setNotice(columnFull);
}

function getValue(row, col) {
  if (!rows.includes(row) || col < 0 || col > 7) {
    console.log(`${row} ${col}`);
  }
  return getElement(row, col).innerHTML;
}

function setValue(row, col, val=getTurn()) {
  getElement(row,col).innerHTML = val;
}

function getElement(row, col) {
  return document.getElementById(`${row}${col}`);
}

function getTurn() {
  return xTurn ? "X" : "O";
}

function changeTurn() {
  xTurn = !xTurn;
  document.getElementById('turn').innerHTML = `It is Player ${getTurn()}'s turn!`;
}

function setNotice(notice) {
  document.getElementById('turn').innerHTML = notice;
}

function gameOver() {
  for (let y = 0; y < rows.length; y++) {
    for (let x = 1; x <= numColumns; x++) {
      if (getValue(rows[y], x)) {
        if (x >= 4) {
          if (checkRow(y, x)) {
            return true;
          }
        }
        if (y >= 3) {
          if (checkColumn(y, x)) {
            return true;
          }
        }
        if (x >= 4 && y >= 3) {
          if (checkLRDiagonal(y, x)) {
            return true;
          }          
        }
        if (x <= 4 && y <= 2) {
          if (checkRLDiagonal(y, x)) {
            return true;
          }          
        }
      }
    } 
  }
}

function checkRow(y, x) {
  if (getValue(rows[y], x) == getValue(rows[y], x-3) &&
      getValue(rows[y], x) == getValue(rows[y], x-2) &&
      getValue(rows[y], x) == getValue(rows[y], x-1)) {
        return true;
  }
}

function checkColumn(y, x) {
  if (getValue(rows[y], x) == getValue(rows[y-3], x) &&
      getValue(rows[y], x) == getValue(rows[y-2], x) &&
      getValue(rows[y], x) == getValue(rows[y-1], x)) {
        return true;
  }
}

function checkLRDiagonal(y, x) {
  if (getValue(rows[y], x) == getValue(rows[y-3], x-3) &&
      getValue(rows[y], x) == getValue(rows[y-2], x-2) &&
      getValue(rows[y], x) == getValue(rows[y-1], x-1)) {
    return true;
  }
}

function checkRLDiagonal(y, x) {
  if (getValue(rows[y], x) == getValue(rows[y+3], x+3) &&
      getValue(rows[y], x) == getValue(rows[y+2], x+2) &&
      getValue(rows[y], x) == getValue(rows[y+1], x+1)) {
    return true;
  }
}

function clearBoard() {
  for (let col = 1; col < numColumns; col++) {
    for (const row of rows) {
      setValue(row, col, '');
    }
  }
}

function celebrate() {
  setNotice(`Whoo! Player ${getTurn()} has won the game!`);
  document.getElementById('game_over').style.setProperty('display', 'block');
}

document.addEventListener('turbolinks:load', () => {
    const headers = document.querySelectorAll('.header');
    headers.forEach(el => el.addEventListener('click', (event) => {
      placeToken(el.id)
    }));
    
    document.getElementById('game_over').addEventListener('click', (event) => {
        clearBoard()
    });
});