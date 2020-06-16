//hydra

osc([30,40,100],0.05,[0.001,0.2,0.7])
.posterize(4,10)
.scrollX( ()=> a.fft[2]*0.01)
.rotate(0.6,0.1)
.scale(0.2)
.out(o1)


solid(0,0,0)
.add(o1,1)
.mult(shape(4).rotate(0.8,0.2).repeat([4],1,0.4,0.5).modulateScale(osc(0.2,0.0005).scale(0.01)))
.scrollX( () => a.fft[0]*0.01,0.01)
.scrollY(0.01,0.1)
.scale(0.1)
.out(o3)

render(o3)
