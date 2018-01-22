const line = (vat, retention, hasDeleteLine) => {
  return `
  <p class="description"><label>Descripción:</label><input type="text" name="description[]"></p>
  <p><label>Base:</label><input type="number" name="base[]"></p>
  <p><label>IVA:</label><input type="text" name="vat[]" value="${vat}"></p>
  <p><label>Retención:</label><input type="text" name="retention[]" value="${retention}"></p>
  ${deleteLine(hasDeleteLine)}`;
}

const deleteLine = (showDeleteAnchor) => {
  if (showDeleteAnchor) {
    return '<p class="delete"><a href="">Eliminar</a></p>';
  } else {
    return '<p class="delete"></p>';
  }
}

function addNewLine(){
  const lines = document.querySelector('#lines');
  const newLine = document.createElement("li");
  const hasMoreChilds = (lines.childElementCount > 0)
  newLine.innerHTML = line(21, 15, hasMoreChilds);
  if (hasMoreChilds) {
    addDeleteLineListener(newLine);
  }
  lines.appendChild(newLine);
}

function addDeleteLineListener(newLine) {
  newLine.querySelector('a').addEventListener('click', (event) => {
    event.preventDefault();
    newLine.parentElement.removeChild(newLine);
  });
}

document.addEventListener('DOMContentLoaded', function () {
  addNewLine();
  const adder = document.querySelector('#adder');
  adder.addEventListener('click', (event) => {
    event.preventDefault();
    addNewLine();
  });
});
