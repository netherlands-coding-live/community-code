s0.initCam()
src(s0).out()

osc(8, 0.3, 1.5)
.modulate(src(s0).rotate(3, 0.4, 0.5))
.modulate(src(s0).rotate(-1, 0.2, 0.1))
.diff(src(s0).rotate(3, 0.3, 0.5))
.diff(shape(2).rotate(-1, 0.2, 0.3).scale(({time}) => Math.sin(time)))
.out()
