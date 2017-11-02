const LINE_TEMPLATE = `
  <label>Descripción<input type="text" name="description[]"></label>
  <label>Base<input type="number" name="base[]" ></label>
  <label>IVA<input type="text" name="vat[]" value="21"></label>
  <label>Retención<input type="text" name="retention[]" value="15"></label>
  <a href="">Eliminar</a>
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
