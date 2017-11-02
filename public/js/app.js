const LINE_TEMPLATE = `
  <p class="description"><label>Descripción:</label><input type="text" name="description[]"></p>
  <p><label>Base:</label><input type="number" name="base[]"></p>
  <p><label>IVA:</label><input type="text" name="vat[]" value="21"></p>
  <p><label>Retención:</label><input type="text" name="retention[]" value="15"></p>
  <p class="delete"><a href="">Eliminar</a></p>
`;

function addNewLine(){
  const lines = document.querySelector('#lines');
  const newLine = document.createElement("li");
  newLine.innerHTML = LINE_TEMPLATE;
  newLine.querySelector('a').addEventListener('click', (event) => {
    event.preventDefault();
    newLine.parentElement.removeChild(newLine);
  });
  lines.appendChild(newLine)
}

document.addEventListener('DOMContentLoaded', function () {
  const adder = document.querySelector('#adder');
  adder.addEventListener('click', (event) => {
    event.preventDefault();
    addNewLine();
  });
});
