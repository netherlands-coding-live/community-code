
function average(element, array) {
  element.timeTracking["averageDifference"] = array.reduce((a, b) => a + b) / array.length;
  // console.log("Average difference: " + element.timeTracking["average"]) + "ms";
}

function timeTracking(element, timeFunctionSet, delay) {
  if(!element.timeTracking){
    element.timeTracking = [[]];
  }
  let timeFunctionExecuted = Date.now();
  let difference = timeFunctionExecuted - (timeFunctionSet + delay);
  // As long as the difference is under 10-25ms it should be imperceptible
  element.timeTracking[element.timeTracking.length - 1].push(difference);
  average(element, element.timeTracking[0]);
}

// Used convienience during dev to see if
// there is any errors or to check on some values
function startAndStop(delay){
  setTimeout(function() {
    start();
    setTimeout(function() {
      stop()
    }, delay);
  }, 10);
}


Cascade.prototype.initAndStop = function(delay){
  setTimeout(function() {
    this.init();
    setTimeout(function() {
      this.stop()
    }.bind(this), delay);
  }.bind(this), 10);
}
