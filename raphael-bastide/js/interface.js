// Interface scripts for Cascade
// Shift+Click to browse colors
// ⤷ the color Silver triggers a special random color animation 
// Double click to remove
// Drag to move, drag bottom right corner to resize
// Public messages
let cssColors

d.addEventListener("newCascade", function(e) {
  let cascadeObj = e.detail.cascade
  let cClass = cascadeObj.cascadeClass
  let existingEls = d.querySelectorAll(cClass)
  cssColors = colors
  // Make existing elements on page interactive
  existingEls.forEach(existingEl => {
    makeInterractive(existingEl)
  });
  // Make elements created live, interactive
  cascadeObj.on('add', function(e) {
    let el = e.detail.newNode;
    makeInterractive(el)
  })
  cascadeObj.on('clone', function(e) {
    let el = e.detail.element;
    makeInterractive(el)
  })
})

function makeInterractive(el){
  bindClick(el)
  dragElement(el)
  el.style.resize = 'both'
  el.style.overflow = 'hidden'
}

// Click
function bindClick(el){
  el.onclick = function(e){
    if (e.shiftKey) {
      browseColors(el)
    }
  }
  el.addEventListener('dblclick', function (e) {
    if (!e.shiftKey) {
      el.remove()
    }
  });
}

// Silver random
let silverRandom = function(element){
  randomPickedColor = cssColors[Math.floor(Math.random() * cssColors.length)].hex
  if (randomPickedColor != "#c0c0c0") { // avoid picking silver again
    element.style.backgroundColor = randomPickedColor
  }
}

// Drag
function dragElement(elmnt) {
  let pos1 = 0,
    pos2 = 0,
    pos3 = 0,
    pos4 = 0;
  elmnt.onmousedown = dragMouseDown;
  function dragMouseDown(e) {
    if (!e.ctrlKey) { // ctrl is used for resize
      e = e || window.event;
      e.preventDefault();
      pos3 = e.clientX;
      pos4 = e.clientY;
      document.onmouseup = closeDragElement;
      // call a function whenever the cursor moves:
      document.onmousemove = elementDrag;
    }
  }
  function elementDrag(e) {
    dragActive = true;
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  }
  function closeDragElement() {
    dragActive = false;
    document.onmouseup = null;
    document.onmousemove = null;
  }
}

// Browse colors
const browseColors = (el) => {
  let cs = window.getComputedStyle(el)
  let currentColor
  let picked
  if (el.silverRandomMode) {
    // Check is a silver random anim is currently in use
    clearInterval(el.silverInterval)
    el.silverRandomMode = false
    currentColor = '#c0c0c0'
  }else{
    currentColor = cs.getPropertyValue("background-color")
  }
  for (var i = 0; i < colors.length; i++) {
    // If current color is in color array, loop
    if (allToHex(currentColor) == colors[i].hex && i+1 < colors.length){
      picked = colors[i+1].hex
    }
  }
  if (!picked){
    // Nothing found? End of the list? -> go back color 1
    el.style.backgroundColor = colors[0].hex
  }else {
    if (picked == "#c0c0c0") {
      // Silver color? -> random color animation
      el.silverRandomMode = true
      el.silverInterval = setInterval(() => {
        silverRandom(el)
      }, 200);
    }else{
      el.style.backgroundColor = picked
    }
  }
}

// Message
function message(content, time=5){
  let messageBox
  if (d.querySelector('.message-box') == undefined) {
    messageBox = d.createElement('div')
    messageBox.classList.add('message-box')
    d.body.appendChild(messageBox)
  }else {
    messageBox = d.querySelector('.message-box')
  }
  messageBox.innerHTML = content
  setTimeout(function () {
    messageBox.remove()
  }, time * 1000);
}
