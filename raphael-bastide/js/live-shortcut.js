let cascadeArrayShortcut = [];

d.addEventListener("newCascade", function(e) {
  let newCascadeObj = e.detail.cascade;
  cascadeArrayShortcut.push(newCascadeObj);
})


function add(style = this.defaultStyle, parentId = "c", copies = 1) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].add(style, parentId, copies)
  } else {
    errorShortcut();
  }
}

function start(delay, sendEvent) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].start(delay, sendEvent)
  } else {
    errorShortcut();
  }
}

function stop(sendEvent) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].stop(sendEvent)
  } else {
    errorShortcut();
  }
}

function mute() {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].mute()
  } else {
    errorShortcut();
  }
}

function rawStyle(style) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].rawStyle(style)
  } else {
    errorShortcut();
  }
}

function mod(style, id) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].mod(style, id)
  } else {
    errorShortcut();
  }
}

function addCl(cl, id) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].addCl(cl, id)
  } else {
    errorShortcut();
  }
}

function rmCl(cl, id) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].rmCl(cl, id)
  } else {
    errorShortcut();
  }
}

function clone(style, elToCloneID) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].clone(style, elToCloneID)
  } else {
    errorShortcut();
  }
}

function on(eventTolistenTo, callback) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].on(eventTolistenTo, callback)
  } else {
    errorShortcut();
  }
}

function rm(id, sendEvent) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].rm(id, sendEvent)
  } else {
    errorShortcut();
  }
}

function clear() {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].clear();
  } else {
    errorShortcut();
  }
}

function ls() {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].ls()
  } else {
    errorShortcut();
  }
}

function dl(fileName) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].dl()
  } else {
    errorShortcut();
  }
}

function scan(time = 4) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].scan(time)
  } else {
    errorShortcut();
  }
}

function grid(time = 10) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].grid(time)
  } else {
    errorShortcut();
  }
}

function copyNodeStyle(sourceNode, targetNode) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].copyNodeStyle(sourceNode, targetNode)
  } else {
    errorShortcut();
  }
}

function message(content) {
  if (cascadeArrayShortcut.length == 1) {
    cascadeArrayShortcut[0].message(content)
  } else {
    errorShortcut();
  }
}

function errorShortcut() {
  if (cascadeArrayShortcut == 0) {
    console.log('No Cascade instance yet');
  } else {
    console.log('Several Cascade instances are running. Please use refToCascadeInstance.function()');
  }
}
