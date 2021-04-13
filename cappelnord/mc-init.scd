(
"mushroom-clouds/mc-engine.scd".loadRelative;

~initWorld.();

// VISUALIZER
// "mushroom-clouds/mc-viz.scd".loadRelative;
// ~initViz.value("127.0.0.1", 57140, 6, 0.04, ~scanYFunc.value(1080));

~initLoadFungi.(Document.current.dir ++ "/mushroom-clouds/fungi");
~initAgents.(32);
)