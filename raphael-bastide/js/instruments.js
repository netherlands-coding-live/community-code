let instruments =[
  {
    "name":"default",
    "synth":"none",
  },
  {
    "name":"kick",
    "synth":"MembraneSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -10,
    "options": {
      "envelope" : {
        "attack" : 0.1,
        "attackCurve" :  "exponential",
        "decay" : 0.8,
        "sustain" : 0,
        "release" : .4,
      },
      "pitch-decay" : 0.3,
      "octaves" : 3,
    }
  },
  {
    "name":"chi",
    "synth":"MetalSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -20,
    "options": {
      "envelope": {
        "attack": 0.01,
        "decay": 0.01,
        "sustain": 0,
        "release":0,
			},
    }
  },
  {
    "name":"noise",
    "synth":"NoiseSynth",
    "instrumentDuplicate":0,
    "volumeCorrection":-30,
    "options":{
      "type":'white',
      "fadeOut":.3,
      "envelope" : {
        "attack" : 0.0005 ,
        "decay" : 0.1,
        "sustain" : 1,
        "release" :0.2
      }
    },
  },
  {
    "name":"Violin",
    "synth":"AMSynth",
    "instrumentDuplicate":2,
    "volumeCorrection":-10,
    "options": {
      "harmonicity": 2.5,
      "portamento": 2,
      "oscillator": {
        "type": "fatsawtooth"
      }
    },
  },
  {
    "name":"80org",
    "synth":"MonoSynth",
    "instrumentDuplicate":0,
    "volumeCorrection":-25,
    "options": {
      "envelope": {
        "attack": 0.02,
        "decay": 0.1,
        "release": 1,
        "sustain": .9,
      }
    }
  },
  {
    "name":"Marble",
    "synth":"Synth",
    "instrumentDuplicate":0,
    "volumeCorrection": -10,
    "options":{
      "detune": 0,
      "portamento": 0.05,
      "envelope": {
        "attack": 0.01,
        "decay": 0.1,
        "sustain": 0.2,
        "release": 0.5,
      },
      "oscillator": {
        "partialCount": 0,
        "partials": [],
        "type": "amtriangle",
        "phase": 0,
        "harmonicity": 20.5,
        "modulationType": "sine"
      }
    }
  },
  {
    "name":"pun",
    "synth":"Synth",
    "instrumentDuplicate":0,
    "volumeCorrection": -10,
    "options": {
      "detune": 4700,
      "envelope": {
        "attack": 0.005,
        "decay": .01,
        "sustain": 0.01,
        "release": 0.1,
      },
      "oscillator":{
        "type": "sine"
      }
    }
  },
  {
    "name":"bun",
    "synth":"Synth",
    "instrumentDuplicate":0,
    "volumeCorrection": -10,
    "options": {
      "detune": 2450,
      "envelope": {
        "attack": 0.1,
        "decay": 0.4,
        "sustain": 0,
        "release": .5,
      },
      "oscillator":{
        "type": "sine"
      }
    }
  },
  {
    "name": "dinx",
    "synth": "MetalSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -40,
    "options":{
      "harmonicity": 12,
			"resonance": 800,
      "detune": 800,
			"modulationIndex": 20,
			"envelope": {
				"decay": 0.4,
			},
    },
  },
  {
    "name": "ovni",
    "synth": "AMSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -5,
    "options":{
      "detune": 0,
      "portamento": 0,
      "harmonicity": 2.5,
      "oscillator": {
        "partialCount": 0,
        "partials": [],
        "phase": 0,
        "type": "sine"
      },
      "envelope": {
        "attack": 0.01,
        "attackCurve": "linear",
        "decay": 0.01,
        "decayCurve": "exponential",
        "release": 1,
        "releaseCurve": "exponential",
        "sustain": 1
      },
      "modulation": {
        "partialCount": 0,
        "partials": [],
        "phase": 0,
        "type": "sine"
      },
      "modulationEnvelope": {
        "attack": 0,
        "attackCurve": "linear",
        "decay": 0,
        "decayCurve": "exponential",
        "release": 0.5,
        "releaseCurve": "exponential",
        "sustain": 1
      }
    }
  },
  {
    "name":"dze",
    "synth":"MembraneSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -20,
    "options": {
      "detune": 800,
      "portamento": 3,
      "envelope": {
        "attack": 0.03,
        "decay": .2,
        "release": 0.4,
        "sustain": 0
      },
      "oscillator": {
        "partialCount": 0,
        "partials": [],
        "phase": 2,
        "type": "sawtooth"
      },
      "octaves": 2,
      "pitchDecay": 2
    }
  },
  {
    "name":"wih",
    "synth":"AMSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -10,
    "options": {
      "detune": 2350,
      "portamento": 1,
      "harmonicity": 1,
      "oscillator": {
        "partialCount": 1,
        "partials": [1],
        "phase": 0,
        "type": "custom"
      },
      "envelope": {
        "attack": 0.01,
        "attackCurve": "linear",
        "decay": 1,
        "decayCurve": "exponential",
        "release": 1,
        "releaseCurve": "exponential",
        "sustain": 1
      },
      "modulation": {
        "partialCount": 0,
        "partials": [],
        "phase": 0,
        "type": "sine"
      },
      "modulationEnvelope": {
        "attack": .01,
        "attackCurve": "linear",
        "decay": 0,
        "decayCurve": "exponential",
        "release": 0.5,
        "releaseCurve": "exponential",
        "sustain": 1
      }
    }
  },
  {
    "name":"bip",
    "synth":"AMSynth",
    "instrumentDuplicate":3,
    "volumeCorrection":-5,
    "options": {
      "detune": 4700,
      "envelope": {
        "attack": 0.01,
        "decay": 0.9,
        "release": .1,
        "sustain": .3,
      }
    }
  },
  {
    "name": "ting",
    "synth": "MetalSynth",
    "instrumentDuplicate":2,
    "volumeCorrection": -40,
    "options":{
      "harmonicity": 0,
			"resonance": 0,
      "detune": 6000,
			"modulationIndex": 10,
			"envelope": {
				"decay": 2.4,
        "release":1.2,
        "sustain":2,
        "attack":0.001
			},
    },
  },
  {
    "name": "wii",
    "synth": "MonoSynth",
    "instrumentDuplicate":0,
    "volumeCorrection": -30,
    "options":{
      "volume": 0,
      "detune": 2690,
      "portamento": .5,
      "harmonicity": 0,
      "oscillator": {
        "phase": 0,
        "type": "sine"
      },
    },
  },
]
