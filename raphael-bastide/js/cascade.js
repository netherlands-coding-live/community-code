// Cascade v.0.6
// https://raphaelbastide.com/cascade

let d = document;
let allowedCssProperties = ['opacity', 'display', 'visibility', 'background', 'background-color', 'border-top-left-radius', 'border-top-right-radius', 'border-bottom-right-radius', 'border-bottom-left-radius', 'width', 'height', 'border-top-width', 'border-right-width', 'border-bottom-width', 'border-left-width', ];
let defaultCascadeClass = ".cas";
let defaultRoot = "body";
let defaultIntervalBpmbasis = intervalBpmBasis = 60000;


class Cascade {
  constructor(rootNode = defaultRoot, options = {}) {
    if (typeof rootNode === 'string' || rootNode instanceof String) { // checking if rootnode is a selector (string) or object
      this.rootNode = d.querySelector(rootNode);
      if (d.body.contains(this.rootNode)) {
        // always returns false when checking Shadowdom. Use non-string selector (element objects) in case of a shadowDom Cascade root
        this.rootNode.style.position = "relative";
      } else {
        console.info('Invalid root element');
        return;
      }
    }else{
      this.rootNode = rootNode;
    }

    this.state = {
      isMute: false,
      playing: false,
      tick: 0,
      timerInterval:0,
      userHasBeenWarned: false
    }

    this.documentCssRules = this.getDocumentCssRules();
    this.bpm = this.getbpm();
    this.els = [];
    this.insList = [];
    this.colors = [];
    this.intervalBpmBasis = defaultIntervalBpmbasis;
    this.interval = Math.round(intervalBpmBasis / (this.bpm));
    this.cascadeClass = options.cascadeClass ? options.cascadeClass : defaultCascadeClass;
    this.instruments = options.instruments ? options.instruments : instruments;
    this.startButton = options.startButton == undefined ? true : options.startButton;
    this.defaultStyle = options.defaultStyle ? options.defaultStyle : "width:100px; height:200px; background-color:var(--c0); position:absolute; bottom:40vh; left:40vw;"
    this.debugTime = options.debugTime == undefined ? false : options.debugTime;
    this.init();
    let event = new CustomEvent('newCascade', {
      detail: {
        cascade: this
      }
    });
    if (options.newCascadeEvent != false) {
      // this is used for cascade pool. It must be explicitly set as false for multi performers
      d.dispatchEvent(event);
    }
  }

  getDocumentCssRules() {
    let proto = Element.prototype;
    let slice = Function.call.bind(Array.prototype.slice);
    let matches = Function.call.bind(proto.matchesSelector ||
      proto.mozMatchesSelector || proto.webkitMatchesSelector ||
      proto.msMatchesSelector || proto.oMatchesSelector);
    return slice(document.styleSheets).reduce(function(rules, styleSheet) {
      return rules.concat(slice(styleSheet.cssRules));
    }, []);
  }

  init() {
    if (!this.rootNode) {
      return;
    } else {
      console.info('Welcome to Cascade')
    }
    this.rootNode.id = 'c';
    this.createInstruments()
    makeColorList()

    let elNodes = this.rootNode.querySelectorAll(':scope > ' + this.cascadeClass);
    elNodes.forEach((elNode, i) => {
      this.initEl(this.rootNode, elNode);
    });
    this.addMutationObserverChildren(this.rootNode, this.rootNode);
    if (this.startButton) {
      this.createStartBtn();
    }
  }

  nextTick() {
    if (!this.state.playing) {
      this.state.tick = -1
      return
    }
    // BPM
    if (this.bpm != this.getbpm()) {
      this.bpm = this.getbpm()
      console.info('BPM = ' + this.bpm);
      let event = new CustomEvent('update', {
        detail: {
          element: this.rootNode,
        }
      })
      // dispatch the event
      this.rootNode.dispatchEvent(event);

    }
    // Interpret all elements
    if (this.els.length == 0 && !this.state.userHasBeenWarned) {
      console.info("No HTML element found, try adding one with add()");
      this.state.userHasBeenWarned = true;
    } else if (this.els.length != 0) {
      this.els.forEach((el, i) => {
        this.interpret(el)
      });
    }
    this.state.tick++
    this.interval = Math.round(this.intervalBpmBasis / this.bpm);
    return setTimeout(function() {
      return this.nextTick();
    }.bind(this), this.interval);
  }

  initEl(parent, elNode, elsArray) {
    let el = new cElement(elNode, window.getComputedStyle(elNode), this);
    this.addMutationObserverChildren(el, elNode)
    if (parent == this.rootNode) {
      let newIdNumber;
      if (this.els[this.els.length-1]) {
        newIdNumber = Number(this.els[this.els.length-1].htmlNode.id.split('-').pop());
        newIdNumber++;
      } else {
        newIdNumber = 0
      }
      this.els.push(el);
      elNode.id = parent.id + "-" + newIdNumber;
    } else {
      let newIdNumber;
      if (parent.children[parent.children.length-1]) {
        newIdNumber = Number(parent.children[parent.children.length-1].htmlNode.id.split('-').pop());
        newIdNumber++;
      } else {
        newIdNumber = 0
      }
      parent.children.push(el);
      elNode.id = parent.htmlNode.id + "-" + newIdNumber;
    }
    let children = elNode.querySelectorAll(this.cascadeClass);
    children.forEach((childNode, i) => {
      this.initEl(el, childNode);
    });
  }

  addMutationObserverChildren(parent, parentNode) {
    // watches for new nodes added to the page and adds them to the cascade
    let config = {
      childList: true,
    };
    let self = this;
    let mutationCallbackChildren = function(mutationsList) {
      mutationsList.forEach((mutation, i) => {
        if (mutation.type == 'childList') {
          mutation.addedNodes.forEach((newNode, i) => {
            if (newNode.classList && newNode.classList.contains(self.cascadeClass.slice(1))) {

              self.initEl(parent, newNode);
              if (parent.htmlNode) {
                console.info('Added new element ' + newNode.id + ' to ' + parent.htmlNode.id);
              } else {
                console.info('Added new element ' + newNode.id + ' to ' + parent.id);
              }

              let event = new CustomEvent('add', {
                detail: {
                  parent: parent,
                  newNode: newNode,
                }
              })
              // dispatch the event
              self.rootNode.dispatchEvent(event);

              if (parent != self.rootNode) {
                parent.htmlNode.setAttribute('data-childs', parent.children.length);
              }

            } else {
              // Leaving this for now because there is unnecessaty divs being created
              // and it needs investigation
              // console.log(newNode);
            }
          });

          mutation.removedNodes.forEach((deletedNode, i) => {
            if (deletedNode.classList.contains(self.cascadeClass.slice(1))) {
              let event = new CustomEvent('rm', {
                detail: {
                  params: {
                    id: deletedNode.id
                  }
                }
              })
              // dispatch the event
              self.rootNode.dispatchEvent(event);

              let filterRule = itemFilter => itemFilter.htmlNode == deletedNode;
              let elToDelete = filterRecursive(self.els, filterRule)[0];
              let pathElToDelete = findInRecursiveArray(self.els, elToDelete)[0].path.reverse();
              if (pathElToDelete) {
                if (pathElToDelete.length == 1) {
                  self.els[pathElToDelete[0]].computedProperties.currentInstrument.numberOfElsPlaying--;
                  self.els.splice(pathElToDelete[0], 1)
                } else {
                  let parentOfElToDelete = self.els[pathElToDelete[i]]
                  for (var i = 1; i < pathElToDelete.length-1; i++) {
                    parentOfElToDelete = parentOfElToDelete.children[pathElToDelete[i]]
                  }
                  parentOfElToDelete.children[pathElToDelete[pathElToDelete.length-1]].computedProperties.currentInstrument.numberOfElsPlaying--;
                  parentOfElToDelete.children.splice(pathElToDelete[pathElToDelete.length-1], 1)
                }
              }
            }
          });
        }
      });
    };
    let childrenObserver = new MutationObserver(mutationCallbackChildren);
    childrenObserver.observe(parentNode, config);
  }

  interpret(element) {
    // check if something changed in the style of the element
    if (!element.compare(window.getComputedStyle(element.htmlNode))) {
      this.documentCssRules = this.getDocumentCssRules();
      // update the element
      element.update()
    }

    let elProp = element.computedProperties
    let cycle = Number(element.htmlNode.getAttribute('data-cycle'))
    if (element.htmlNode.getAttribute('data-cycle') == undefined) {
      element.htmlNode.setAttribute('data-cycle', 0)
    }
    let probRan = Math.floor(Math.random() * 10)
    if (
      element.cssProperties['display'] !== "none" &&
      element.cssProperties['visibility'] !== "hidden" &&
      (elProp.euclPat[cycle - 1]) == 1
    ) {
      setTimeout(function() {
        if (this.debugTime) {
          if (typeof timeTracking === "function") {
            timeTracking(element, arguments[0], elProp.delay);
          } else {
            console.info('Cannot debug: deubugTime is `true`, but debug.js is not linked to this page.');
          }
        }

        if (elProp.probability > probRan) {
          if (!this.state.isMute && element.children.length == 0) { // not muted & has no child
            // console.log(elProp.panVal);
            // if(elProp.panVal < -10){elProp.panVal = -10}else if(elProp.panVal > 10){elProp.panVal = 10}
            if (elProp.insSynthType !== "none") {
              // console.log(elProp.panVal / 20 + .5);
              //  console.log(panner.pan);
              //  panner.connect()
              // Change volume depending on element surface and volume correction
              elProp.currentInstrument.volume.value = Math.round(elProp.surface / 20000) + elProp.volumeCorrection
              // Caps volume value to 10db
              if (elProp.currentInstrument.volume.value >= 10) {
                elProp.currentInstrument.volume.value = 10
              }
            }

            if (elProp.insSynthType === "NoiseSynth") {
              try {
                elProp.currentInstrument.triggerAttackRelease(elProp.duration);
                // elProp.currentInstrument.envelope.sustain = elProp.duration;
                // elProp.currentInstrument.start()
                // setTimeout(() => {
                //   elProp.currentInstrument.stop()
                // }, elProp.duration);
              } catch (e) {
                console.info("Multiple overlapping synths. Higher instrumentDuplicate advised.");
              }
            } else if (elProp.insSynthType === "PluckSynth") {
              try {
                elProp.currentInstrument.triggerAttack(elProp.note, elProp.duration);
              } catch (e) {
                console.info("Multiple overlapping synths. Higher instrumentDuplicate advised.");
              }
            } else if (elProp.insSynthType === "none") {
              // do nothing :3
            } else {
              try {
                elProp.currentInstrument.triggerAttackRelease(elProp.note, elProp.duration);
              } catch (e) {
                console.info("Multiple overlapping synths. Higher instrumentDuplicate advised.");
              }
            }
          }
          activatecElement(element.htmlNode);
          // interpret children
          element.children.forEach((child, i) => {
            this.interpret(child);
          });
        }
      }.bind(this), elProp.delay, Date.now() /* only used if debugTime */ );
    }
    if (cycle >= elProp.euclPat.length) {
      cycle = 0
    }
    cycle++
    element.htmlNode.setAttribute('data-cycle', cycle)
  }

  createInstruments() {
    if (typeof this.instruments !== 'undefined' ) {
      this.instruments.forEach((instrument, index) => {
        let synthType = instrument.synth
        let insOptions = instrument.options;
        this.insList[instrument.name] = [];
        let newSynth = {}

        if (synthType == "none") {
          // newSynth = new Tone.Synth().toDestination()
        } else {
          newSynth = new Tone[synthType](insOptions).toDestination()
        }
        newSynth.numberOfElsPlaying = 0;
        this.insList[instrument.name].push(newSynth);
      });
    }else{
      console.info('Instruments missing');
    }
  }

  getbpm() {
    let color = window.getComputedStyle(this.rootNode).getPropertyValue('background-color');
    let lum = RGBtoHSL(color)['lum']
    let bpm = Math.round(lum * 3) + 20; // *2 makes enlarge the bpm range, currently in test
    bpm = bpm >= 0 ? bpm : 1;
    // sets interval as CSS variable for animation syncing
    this.rootNode.style.setProperty('--interval', this.interval / 1000);
    return bpm
  }
}

class cElement {
  constructor(htmlNode, computedStyle, cascade) {
    this.cascadeParent = cascade;
    this.htmlNode = htmlNode;
    this.previousCssPropertiesObj = this.cssStyleDeclarationToJsObj(computedStyle);
    this.cssProperties = this.setCssProperties(computedStyle);
    this.children = [];
    this.computedProperties = this.setComputedProperties();
    this.htmlNode.setAttribute('data-ratio', this.computedProperties["ratio"][0] + ":" + this.computedProperties["ratio"][1])
    this.htmlNode.setAttribute('data-instrument', this.computedProperties["insID"])
  }

  update() {
    this.previousCssPropertiesObj = this.cssStyleDeclarationToJsObj(window.getComputedStyle(this.htmlNode));
    this.cssProperties = this.setCssProperties(window.getComputedStyle(this.htmlNode));
    this.computedProperties = this.setComputedProperties();
    this.htmlNode.setAttribute('data-ratio', this.computedProperties["ratio"][0] + ":" + this.computedProperties["ratio"][1])
    this.htmlNode.setAttribute('data-instrument', this.computedProperties["insID"]);
    let event = new CustomEvent('update', {
      detail: {
        element: this,
      }
    })
    // dispatch the event
    this.cascadeParent.rootNode.dispatchEvent(event);
  }

  compare(currentComputedStyle) {
    let currentComputedStyleObj = this.cssStyleDeclarationToJsObj(currentComputedStyle)
    return JSON.stringify(this.previousCssPropertiesObj) === JSON.stringify(currentComputedStyleObj)
  }
  setCssProperties(computedStyle) {
    // combine computed style with nonComputedStyle in order to also
    // gather non explicitly defined css properties.
    let computedStyleObj = this.cssStyleDeclarationToJsObj(computedStyle);
    let nonComputedStyleObj = this.getNonComputedStyle();
    let arrayTemp = [computedStyleObj, nonComputedStyleObj];
    arrayTemp = arrayTemp.reduce(function(result, current) {
      return Object.assign(result, current);
    }, {});

    return this.filterCssProperties(arrayTemp, allowedCssProperties)
  }
  cssStyleDeclarationToJsObj(styleDeclaration) {
    // CSSStyleDeclaration https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration
    let obj = {};
    for (var i = 0; i < styleDeclaration.length; i++) {
      obj[styleDeclaration[i]] = styleDeclaration.getPropertyValue(styleDeclaration[i]);
    }
    return obj;
  }
  filterCssProperties(cssProperties, allowedCssProperties) {
    // Modified version of https://stackoverflow.com/questions/38750705/filter-object-properties-by-key-in-es6
    // Filters the array so that only the relevant p
    let filteredArray = Object.keys(cssProperties).filter(key => allowedCssProperties.includes(key))
    return filteredArray.reduce((obj, key) => {
      obj[key] = cssProperties[key];
      return obj;
    }, {});
  }

  getNonComputedStyle() {
    var elementMatchCSSRule = function(element, cssRule) {
      let proto = Element.prototype;
      let slice = Function.call.bind(Array.prototype.slice);
      let matches = Function.call.bind(proto.matchesSelector ||
        proto.mozMatchesSelector || proto.webkitMatchesSelector ||
        proto.msMatchesSelector || proto.oMatchesSelector);
      return matches(element, cssRule.selectorText);
    };
    // based on this wonderfull piece of code https://gist.github.com/ZER0/5267608
    // Only gather explicitly defined css properties
    // For example, if there is no border on an element,
    // the property "border" won't be part of the array returned
    let cssRules = this.cascadeParent.documentCssRules.filter(elementMatchCSSRule.bind(null, this.htmlNode));
    cssRules = cssRules.map(function(item) {
      return item["style"];
    });
    cssRules.push(this.htmlNode.style)
    let arrayTemp = [];
    cssRules.forEach((item, i) => {
      arrayTemp.push(this.cssStyleDeclarationToJsObj(item));
    });

    return arrayTemp.reduce(function(result, current) {
      return Object.assign(result, current);
    }, {});
  }

  setComputedProperties() {
    let obj = {}
    let instruments = this.cascadeParent.instruments;
    if ((!this.computedProperties) || (this.computedProperties && this.computedProperties.insID != getVarNbr(this.cssProperties['background-color']))) {
      // if the instrument isn't setuped yet or
      // if the element is updated and the instrument has changed
      if (this.computedProperties) {
        this.computedProperties.currentInstrument.numberOfElsPlaying > 0 ? this.computedProperties.currentInstrument.numberOfElsPlaying-- : this.computedProperties.currentInstrument.numberOfElsPlaying = 0;
      }
      obj.insID = getVarNbr(this.cssProperties['background-color']);
      obj.instrumentDuplicate = instruments[obj.insID].instrumentDuplicate ? instruments[obj.insID].instrumentDuplicate : 0;
      obj.currentInstrument = this.getInstrument(obj.insID, obj.instrumentDuplicate)
    } else if (this.computedProperties) {
      obj.insID = this.computedProperties.insID;
      obj.instrumentDuplicate = instruments[obj.insID].instrumentDuplicate ? instruments[obj.insID].instrumentDuplicate : 0;
      obj.currentInstrument = this.computedProperties.currentInstrument;
    }
    obj.insName = Object.keys(this.cascadeParent.insList)[obj.insID];
    obj.insSynthType = instruments[obj.insID].synth;
    obj.volumeCorrection = instruments[obj.insID].volumeCorrection
    obj.relativePos = this.getRelativePos(this.htmlNode);
    obj.delay = Math.round(obj.relativePos.x * this.cascadeParent.interval / 100) < 0 ? 0 : Math.round(obj.relativePos.x * this.cascadeParent.interval / 100);
    obj.ratio = getRatio(parseInt(this.cssProperties.width), parseInt(this.cssProperties.height))
    // Surface has to be pixel based otherwise vol will change with ≠ units
    obj.surface = this.getSurfaceInPixels(this.htmlNode)
    obj.note = Math.min(300, Math.round(obj.relativePos.y) + 30)
    obj.borderTW = parseInt(this.cssProperties['border-top-width']);
    obj.borderRW = parseInt(this.cssProperties['border-right-width'])
    obj.borderBW = parseInt(this.cssProperties['border-bottom-width'])
    obj.borderLW = parseInt(this.cssProperties['border-left-width'])
    obj.radTL = parseInt(this.cssProperties['border-top-left-radius'])
    obj.radTR = parseInt(this.cssProperties['border-top-right-radius'])
    obj.radBR = parseInt(this.cssProperties['border-bottom-right-radius'])
    obj.radBL = parseInt(this.cssProperties['border-bottom-left-radius'])
    obj.totalBorderRadius = (obj.radTL + obj.radTR + obj.radBR + obj.radBL) / 4;
    obj.probability = this.cssProperties['opacity'] * 10
    obj.duration = obj.totalBorderRadius == 0 ? .01 : obj.totalBorderRadius / 20
    obj.euclSteps = Math.max(obj.ratio[0], obj.ratio[1])
    obj.euclBeats = Math.min(obj.ratio[0], obj.ratio[1])
    obj.panVal = (obj.borderRW - obj.borderLW)
    obj.euclPat = generatePattern(obj.euclBeats, obj.euclSteps);
    shiftPat(obj.euclPat, obj.borderTW);

    // problem with negative duration;

    return obj;
  }

  getRelativePos(element) {
    let pos = element.getBoundingClientRect()
    let parentPos = element.parentNode.getBoundingClientRect()
    let relativePos = []
    relativePos.top = pos.top - parentPos.top,
      relativePos.right = pos.right - parentPos.right,
      relativePos.bottom = pos.bottom - parentPos.bottom,
      relativePos.left = pos.left - parentPos.left;
    let propPosX = (pos.left - parentPos.left) * 100 / this.cascadeParent.rootNode.getBoundingClientRect().width;
    let propPosY = pos.top * 100 / this.cascadeParent.rootNode.getBoundingClientRect().height;
    return {
      x: propPosX,
      y: propPosY
    }
  }

  getSurfaceInPixels(element){
    return Math.floor(element.offsetWidth * element.offsetHeight)
  }
  getInstrument(index, instrumentDuplicate) {
    let currentInstrument = {};
    if (index) {
      let insList = this.cascadeParent.insList;
      let instruments = this.cascadeParent.instruments;

      let currentInstrumentArray = insList[Object.keys(insList)[index]];
      let filterRule = itemFilter => itemFilter.computedProperties.insID == index;
      let numberOfElsPlayingSameInstrument = filterRecursive(this.cascadeParent.els, filterRule);
      if (Math.round(instrumentDuplicate * numberOfElsPlayingSameInstrument.length + 1) > currentInstrumentArray.length) {
        console.info("Adding a new tonejs synth");
        let synthType = instruments[index].synth;
        let insName = instruments[index].name;
        let insOptions = instruments[index].options;
        if (synthType == "none") {
          currentInstrument = new Tone.Synth(insOptions).toDestination()
        } else {
          currentInstrument = new Tone[synthType](insOptions).toDestination();
        }
        currentInstrument.numberOfElsPlaying = 1;
        insList[insName].push(currentInstrument);
      } else {
        // assign to the element the synth with the least amount of element plaing it
        let minNumberOfElsPlaying = Math.min(...insList[instruments[index].name].map(item => item.numberOfElsPlaying));
        currentInstrument = insList[instruments[index].name].filter(item => item.numberOfElsPlaying === minNumberOfElsPlaying)[0]
        currentInstrument.numberOfElsPlaying++;
      }
    } else {
      // if the element has no defined synth, fallback on the first one of the list
      currentInstrument = this.insList[Object.keys(this.insList)[0][0]];
    }
    return currentInstrument;
  }
}


const findInRecursiveArray = (items, itemToFind) => {
      // https://stackoverflow.com/questions/57717986/track-path-of-recursive-function
      // the path is backward and needs to be reversed before use
     let path = []
     // console.log(items);
     items.forEach((item,i) => {

        if('children' in item){
             let item_path = findInRecursiveArray(item.children, itemToFind)

             if(item_path.length > 0){
                 item_path[0].path.push(i)
                 path.push(item_path[0])
             }
        }
        if(items.indexOf(itemToFind) != -1){
            path.push({path:[items.indexOf(itemToFind)]})
        }
     })
     return path
}

//
// function findInRecursiveArray(array, itemToFind, path) {
//   // console.log(array, itemToFind, path);
//   // console.log(array, itemToFind);
//   let result;
//   if (array.indexOf(itemToFind) != -1) {
//     // console.log("here");
//     result = path.concat(array.indexOf(itemToFind));
//     // console.log();
//   } else {
//     for (var i = 0; i < array.length; i++) {
//       if (array[i].children) {
//         return findInRecursiveArray(array[i].children, itemToFind, path.concat(i))
//       } else {
//         return;
//       }
//     }
//   }
//   return result;
// }

function filterRecursive(arrayTofilter, filterRule) {
  let destinationArray = [];
  arrayTofilter.forEach((item, i) => {
    // console.log(item);
    if (item.children) {
      destinationArray = destinationArray.concat(filterRecursive(item.children, filterRule));
    }
    if (filterRule(item)) {
      destinationArray.push(item)
    }
  });
  return destinationArray
}

// System functions
// Cascade API

Cascade.prototype.start = function(delay, sendEvent) {
  setTimeout(function() {
    if (!this.state.playing) {
      this.state.playing = true
      this.nextTick()
      console.info('Cascade started');
      this.initTimer();
      if (sendEvent != false) {
        let event = new CustomEvent('start')
        this.rootNode.dispatchEvent(event);
      }
    } else {
      console.info('Already started');
    }
    if (this.rootNode.querySelector('.start')) {
      this.rootNode.querySelector('.start').remove()
    }
  }.bind(this), delay * 1000);
}

Cascade.prototype.stop = function(sendEvent) {
  if (this.state.playing) {
    this.state.playing = false
    console.info('Cascade stopped');
    clearInterval(this.state.timerInterval)
    if (sendEvent != false) {
      let event = new CustomEvent('stop')
      this.rootNode.dispatchEvent(event);
    }
  }
}

Cascade.prototype.mute = function() {
  this.state.isMute = !this.state.isMute
  if (this.state.isMute) {
    this.rootNode.classList.add('mute')
  }else{
    this.rootNode.classList.remove('mute')
  }
}

Cascade.prototype.add = function(style = this.defaultStyle, parentId = "c", copies = 1) {
  style = style == null || style == false || style == "" ? this.defaultStyle : style;
  let elementsList = []
  if (parentId == "c") {
    parent = this.rootNode
  } else {
    parent = this.rootNode.querySelector("#" + parentId)
  }
  if (parent == undefined) {
    console.info('Chosen parent element is undefined');
    return
  } else {
    for (var i = 0; i < copies; i++) {
      let el = d.createElement("div")
      el.classList.add(this.cascadeClass.slice(1));
      if (style)
        el.style = style
      parent.appendChild(el)
      elementsList.push(el)
    }
  }
}

Cascade.prototype.rawStyle = function(css) {
  let style = d.querySelector('style').innerHTML;
  d.querySelector('style').innerHTML = style + "\n" + css
}

Cascade.prototype.mod = function(style, id) {
  if (Array.isArray(id)) {
    for (var i = 0; i < id.length; i++) {
      let el = this.rootNode.querySelector("#c-" + id[i])
      if (!checkSelector(el)){return false}
      el.style.cssText += style
    }
  }else {
    let el = this.rootNode.querySelector("#c-" + id);
    if (!checkSelector(el)){return false}
    el.style.cssText += style
  }
}

Cascade.prototype.addCl = function(cl, id) {
  let el = this.rootNode.querySelector("#c-" + id);
  if (!checkSelector(el)){return false}
  el.classList.add(cl)
}

Cascade.prototype.rmCl = function(cl, id) {
  let el = this.rootNode.querySelector("#c-" + id)
  if (!checkSelector(el)){return false}
  el.classList.remove(cl)
}

Cascade.prototype.clone = function(style, id) {
  let elToClone = this.rootNode.querySelector("#c-" + id)
  if (!checkSelector(elToClone)){return false}
  let el = elToClone.cloneNode(true);
  if (style) {
    el.style.cssText += style
  }
  parent = elToClone.parentNode;
  parent.appendChild(el);
  console.info('Cloned new element ' + id);
  let event = new CustomEvent('clone', {
    detail: {
      element: el
    }
  })
  this.rootNode.dispatchEvent(event);
}

Cascade.prototype.on = function(eventTolistenTo, callback) {
  return this.rootNode.addEventListener(eventTolistenTo, callback)
}

Cascade.prototype.rm = function(id, sendEvent) {
  if (Array.isArray(id)) {
    id.forEach((idItem, i) => {
      if (this.rootNode.querySelector("#c-" + idItem)) {
        this.rootNode.querySelector("#c-" + idItem).remove();
        console.info('cElement ' + idItem + ' removed');
      } else {
        console.info('cElement doesn’t exist');
      }
    });
  } else {
    if (this.rootNode.querySelector("#c-" + id)) {
      this.rootNode.querySelector("#c-" + id).remove();
      console.info('cElement ' + id + ' removed');
    } else {
      console.info('cElement doesn’t exist');
    }
  }
}

Cascade.prototype.clear = function() {
  this.els.forEach((element, i) => {
    element.htmlNode.remove()
  });
  console.info('Cleared all elements')
}

Cascade.prototype.ls = function() {
  this.els.forEach((element, i) => {
    console.info(element.htmlNode, element.htmlNode.id)
  });
}

Cascade.prototype.dl = function(fileName) {
  let date = new Date().getTime();
  let html = document.querySelector('html').innerHTML
  if (!fileName) {
    fileName = "cascade-" + date + ".html"
  }
  download(html, fileName, "text/html");
}

Cascade.prototype.scan = function(time = 4) {
  this.createColorTable()
  this.rootNode.classList.add('scan')
  setTimeout(function() {
    this.rootNode.classList.remove('scan')
  }.bind(this), time * 1000);
  return
}

Cascade.prototype.grid = function(time = 10) {
  if (typeof(this.rootNode.querySelector('.c-grid')) != 'undefined' &&
    this.rootNode.querySelector('.c-grid') != null) {
    let gridEl = this.rootNode.querySelector('.c-grid')
  } else {
    let gridEl = d.createElement('div')
    gridEl.classList.add('c-grid')
    this.rootNode.appendChild(gridEl)
  }
  this.rootNode.classList.add('show-grid')
  setTimeout(function() {
    this.rootNode.classList.remove('show-grid')
  }.bind(this), time * 1000);
  return
}

Cascade.prototype.copyNodeStyle = function(sourceNode, targetNode) {
  const computedStyle = window.getComputedStyle(sourceNode);
  Array.from(computedStyle).forEach(key => targetNode.style.setProperty(key, computedStyle.getPropertyValue(key), computedStyle.getPropertyPriority(key)))
}

// function

function activatecElement(element) {
  element.classList.add('active')
  setTimeout(function() {
    element.classList.remove('active')
  }, 50);
}


Cascade.prototype.createStartBtn = function() {
  let startBtn = d.createElement('button')
  startBtn.classList.add('start')
  startBtn.innerHTML = "<img class='startImg' src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA4IDExIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIHN0eWxlPSJmaWxsOiMwMDA7c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjIuODAwMDE7c3Ryb2tlLWxpbmVjYXA6cm91bmQ7cGFpbnQtb3JkZXI6c3Ryb2tlIGZpbGwgbWFya2VycyIgZD0iTTQyIDEwMXYxMGw4LTV6IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNDIgLTEwMSkiLz48L3N2Zz4='/>"
  startBtn.addEventListener('click', () => this.activateToneJs())
  this.rootNode.appendChild(startBtn)
}

Cascade.prototype.activateToneJs = function() {
  Tone.Transport.start()
  this.start()
  this.rootNode.querySelector('.start').remove()
}

Cascade.prototype.createColorTable = function() {
  if (this.rootNode.querySelector('.color-scale')) {
    this.rootNode.querySelector('.color-scale').remove()
  }
  let scale = d.createElement('div')
  scale.classList.add('color-scale')
  this.rootNode.appendChild(scale)
  for (var i = 0; i < colors.length; i++) {
    let colorBox = d.createElement('div')
    colorBox.classList.add('color-box')
    colorBox.style.backgroundColor = colors[i].hex
    colorBox.setAttribute('data-var', colors[i].var)
    if (!instruments[i] || instruments[i] == 'undefined') {
      colorBox.setAttribute('data-name', "undef")
    } else {
      colorBox.setAttribute('data-name', instruments[i].name)
    }
    scale.appendChild(colorBox)
  }
}

Cascade.prototype.initTimer = function() {
  timerMin = 0
  let timer = d.createElement('div')
  timer.classList.add('c-timer')
  timer.innerHTML = timerMin
  this.rootNode.appendChild(timer)
  this.state.timerInterval = setInterval(() => {
    timerMin++
    timer.innerHTML = timerMin
    console.info('⧗ ' + timerMin)
  }, 60000);
}

function getVarNbr(rgbColor) {
  makeColorList();
  let needleHex = allToHex(rgbColor)
  for (var i = 0; i < colors.length; i++) {
    closerColor = getClosestColor(needleHex)
    if (closerColor == colors[i].hex) { // if element’s color matches a line
      let cssVar = colors[i].var.replace("--c", "") // get number only
      return cssVar
    }
  }
}

function makeColorList() {
  colors = [] // empty the color array
  let vars = getColorCSSVars() // get colorvar and colorname
  for (var i = 0; i < vars.length; i++) {
    let colorVar = vars[i][0] // retrive var from getColorCSSVars
    let colorName = vars[i][1] // retrive name from getColorCSSVars
    let hex = allToHex(colorName)
    let color = {} // create color object
    color.name = colorName
    color.var = colorVar
    color.hex = hex
    colors.push(color) // add the color to colors array
  }
}

// Get applied CSS variables
const isSameDomain = (styleSheet) => {
  if (!styleSheet.href) {
    return true;
  }
  return styleSheet.href.indexOf(window.location.origin) === 0;
};
const isStyleRule = (rule) => rule.type === 1;
const getColorCSSVars = () => [...document.styleSheets].filter(isSameDomain).reduce(
  (finalArr, sheet) =>
  finalArr.concat(
    [...sheet.cssRules].filter(isStyleRule).reduce((propValArr, rule) => {
      const props = [...rule.style]
        .map((propName) => [
          propName.trim(),
          rule.style.getPropertyValue(propName).trim()
        ])
        .filter(([propName]) => propName.indexOf("--c") === 0);

      return [...propValArr, ...props];
    }, [])
  ),
  []
);

// Utils
function generatePattern(beats, steps) {
  // Bjorklund algorithm from https://gist.github.com/withakay/1286731
  steps = Math.round(steps)
  beats = Math.round(beats)
  if (beats > steps || beats == 0 || isNaN(beats) || steps == 0 || isNaN(steps)) {
    console.info('Element needs width / height');
    return []
  }
  let pattern = []
  let counts = []
  let remainders = []
  let divisor = steps - beats
  remainders.push(beats)
  let level = 0
  while (true) {
    counts.push(Math.floor(divisor / remainders[level]))
    remainders.push(divisor % remainders[level])
    divisor = remainders[level]
    level += 1
    if (remainders[level] <= 1) {
      break
    }
  }
  counts.push(divisor)
  let r = 0
  const build = function(level) {
    r += 1
    if (level > -1) {
      for (var i = 0; i < counts[level]; i++) {
        build(level - 1)
      }
      if (remainders[level] !== 0) {
        build(level - 2)
      }
    } else if (level === -1) {
      pattern.push(0)
    } else if (level === -2) {
      pattern.push(1)
    }
  }
  build(level)
  return pattern.reverse()
}

function checkSelector(el){
  if (el == undefined) {
    console.info('Wrong selector');
    return false
  }else{
    return true
  }
}
function RGBtoHSL(rgb) {
  // https://css-tricks.com/converting-color-spaces-in-javascript/
  // If rgba, the color is still considered valid but the a isn't taken into consideration
  let ex = /^rgb\((((((((1?[1-9]?\d)|10\d|(2[0-4]\d)|25[0-5]),\s?)){2}|((((1?[1-9]?\d)|10\d|(2[0-4]\d)|25[0-5])\s)){2})((1?[1-9]?\d)|10\d|(2[0-4]\d)|25[0-5]))|((((([1-9]?\d(\.\d+)?)|100|(\.\d+))%,\s?){2}|((([1-9]?\d(\.\d+)?)|100|(\.\d+))%\s){2})(([1-9]?\d(\.\d+)?)|100|(\.\d+))%))\)$/i;
  let ex_rgba = /^rgba\((((((((1?[1-9]?\d)|10\d|(2[0-4]\d)|25[0-5]),\s?)){3})|(((([1-9]?\d(\.\d+)?)|100|(\.\d+))%,\s?){3}))|(((((1?[1-9]?\d)|10\d|(2[0-4]\d)|25[0-5])\s){3})|(((([1-9]?\d(\.\d+)?)|100|(\.\d+))%\s){3}))\/\s)((0?\.\d+)|[01]|(([1-9]?\d(\.\d+)?)|100|(\.\d+))%)\)$/i;
  if (ex.test(rgb) || ex_rgba.test(rgb)) {
    let sep = rgb.indexOf(",") > -1 ? "," : " ";
    if (ex.test(rgb)) {
      rgb = rgb.substr(4).split(")")[0].split(sep);
    } else {
      rgb = rgb.substr(5).split(")")[0].split(sep);

    }
    for (let R in rgb) {
      let r = rgb[R];
      if (r.indexOf("%") > -1)
        rgb[R] = Math.round(r.substr(0, r.length - 1) / 100 * 255);
    }

    let r = rgb[0] / 255,
      g = rgb[1] / 255,
      b = rgb[2] / 255,
      cmin = Math.min(r, g, b),
      cmax = Math.max(r, g, b),
      delta = cmax - cmin,
      h = 0,
      s = 0,
      l = 0;
    if (delta == 0)
      h = 0;
    else if (cmax == r)
      h = ((g - b) / delta) % 6;
    else if (cmax == g)
      h = (b - r) / delta + 2;
    else
      h = (r - g) / delta + 4;
    h = Math.round(h * 60);
    if (h < 0)
      h += 360;
    l = (cmax + cmin) / 2;
    s = delta == 0 ? 0 : delta / (1 - Math.abs(2 * l - 1));
    s = +(s * 100).toFixed(1);
    l = +(l * 100).toFixed(1);
    return {
      'hue': h,
      'sat': s,
      'lum': l
    }
  } else {
    console.info('Invalid color');
    return {
      'hue': 100,
      'sat': 100,
      'lum': 100
    };
  }
}

function allToHex(colorStr) {
  var a = document.createElement('div');
  a.style.color = colorStr;
  var colors = window.getComputedStyle(document.body.appendChild(a)).color.match(/\d+/g).map(function(a) {
    return parseInt(a, 10);
  });
  document.body.removeChild(a);
  return (colors.length >= 3) ? '#' + (((1 << 24) + (colors[0] << 16) + (colors[1] << 8) + colors[2]).toString(16).substr(1)) : false;
}

function getRatio(a, b) {
  if (isNaN(a) || isNaN(b)) {
    return [0, 0]
  } else {
    return [a / gcd(a, b), b / gcd(a, b)]
  }
}

function gcd(a, b) { // greatest common divisor
  return (b == 0) ? a : gcd(b, a % b);
}

function shiftPat(pattern, shiftVal) {
  while (shiftVal > 0) {
    let last = pattern.pop()
    pattern.unshift(last)
    shiftVal--
  }
}

function getClosestColor(hex) {
  let stats = []
  for (var i = 0; i < colors.length; i++) {
    let color = {}
    color.hex = colors[i].hex
    color.score = hexColorDelta(colors[i].hex, hex)
    stats.push(color)
  }
  stats = stats.sort((a, b) => b.score - a.score)
  let bestScore = stats[0].hex
  return bestScore
}

function hexColorDelta(hex1, hex2) {
  hex1 = hex1.replace("#", "")
  hex2 = hex2.replace("#", "")
  var r1 = parseInt(hex1.substring(0, 2), 16);
  var g1 = parseInt(hex1.substring(2, 4), 16);
  var b1 = parseInt(hex1.substring(4, 6), 16);
  // get red/green/blue int values of hex2
  var r2 = parseInt(hex2.substring(0, 2), 16);
  var g2 = parseInt(hex2.substring(2, 4), 16);
  var b2 = parseInt(hex2.substring(4, 6), 16);
  // calculate differences between reds, greens and blues
  var r = 255 - Math.abs(r1 - r2);
  var g = 255 - Math.abs(g1 - g2);
  var b = 255 - Math.abs(b1 - b2);
  // limit differences between 0 and 1
  r /= 255;
  g /= 255;
  b /= 255;
  // 0 means opposit colors, 1 means same colors
  return (r + g + b) / 3;
}
const getRealCssVal = (el, property) => {
  // Chrome only
  // let styleMap = el.computedStyleMap();
  // const unitvalue = styleMap.get(property);

  // Firefox compatible
  const unitvalue = getComputedStyle(el).getPropertyValue(property)
  if (unitvalue.unit == undefined) { // avoid fatal js error
    return "0px"
  }
  return unitvalue.value
}
