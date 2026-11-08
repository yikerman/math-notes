import math
from pathlib import Path
out=Path(__file__).resolve().parents[1] / 'figures'
def plot(name,f,seeds,box,points,lines=(),h=.012,steps=1500):
 xmin,xmax,ymin,ymax=box
 s=['% Exact matrix-exponential sampling for linear systems; RK4 for nonlinear systems. Arrows follow increasing time.',r'\begin{tikzpicture}[x=0.85cm,y=0.85cm,>=latex]',rf'\clip ({xmin-.5},{ymin-.5}) rectangle ({xmax+.6},{ymax+.5});',rf'\draw[->,gray] ({xmin},0)--({xmax},0) node[right] {{$x$}};',rf'\draw[->,gray] (0,{ymin})--(0,{ymax}) node[above] {{$y$}};']
 def inside(p):return xmin<=p[0]<=xmax and ymin<=p[1]<=ymax
 def step(p,dt):
  if name!='nonlinear-combined':
   a,c=f(1,0);b,d=f(0,1);tr=(a+d)/2;disc=(a-d)**2/4+b*c
   if disc>0:
    w=math.sqrt(disc);co=math.cosh(w*dt);si=math.sinh(w*dt)/w
   elif disc<0:
    w=math.sqrt(-disc);co=math.cos(w*dt);si=math.sin(w*dt)/w
   else:co=1;si=dt
   e=math.exp(tr*dt)
   return (e*(co*p[0]+si*((a-tr)*p[0]+b*p[1])),e*(co*p[1]+si*(c*p[0]+(d-tr)*p[1])))
  a=f(*p);b=f(*(p[i]+dt*a[i]/2 for i in range(2)));c=f(*(p[i]+dt*b[i]/2 for i in range(2)));d=f(*(p[i]+dt*c[i] for i in range(2)))
  return tuple(p[i]+dt*(a[i]+2*b[i]+2*c[i]+d[i])/6 for i in range(2))
 arrow_positions=[]
 for seed in seeds:
  halves=[]
  for sign in [-1,1]:
   p=seed;ps=[p]
   for j in range(steps):
    q=step(p,sign*h)
    if not inside(q):break
    ps.append(q)
    if math.dist(p,q)<1e-6:break
    p=q
   halves.append(ps)
  ps=list(reversed(halves[0]))+halves[1][1:]
  ps=ps[::3]
  if len(ps)<3:continue
  s.append(r'\draw[blue!65!black,thin] plot coordinates {'+' '.join('({:.4f},{:.4f})'.format(*p) for p in ps)+'};')
  # Uniform time samples accumulate near equilibria. Use visible arc length
  # instead, and reserve space around marked points and other arrowheads.
  lengths=[0.0]
  for a,b in zip(ps,ps[1:]):
   lengths.append(lengths[-1]+math.dist(a,b))
  def at_distance(distance):
   import bisect
   k=min(max(bisect.bisect_right(lengths,distance)-1,0),len(ps)-2)
   segment=lengths[k+1]-lengths[k]
   t=(distance-lengths[k])/segment if segment else 0
   return tuple(ps[k][i]+t*(ps[k+1][i]-ps[k][i]) for i in range(2))
  count=0
  for frac in [.6,.82,.38,.2,.92]:
   distance=lengths[-1]*frac
   if distance<.24:continue
   tip=at_distance(distance)
   if any(math.dist(tip,(x,y))<.55 for x,y,_ in points):continue
   if any(math.dist(tip,other)<.5 for other in arrow_positions):continue
   if min(tip[0]-xmin,xmax-tip[0],tip[1]-ymin,ymax-tip[1])<.15:continue
   shaft=[at_distance(distance-.2+j*.05) for j in range(5)]
   s.append(r'\draw[->,blue!65!black,semithick] plot coordinates {'+
            ' '.join('({:.4f},{:.4f})'.format(*p) for p in shaft)+'};')
   arrow_positions.append(tip)
   count+=1
   if count >= (2 if 'spiral' in name else 1):break

 for a,b,label in lines:s.append(r'\draw[dashed,orange!80!black] '+str(a)+'--'+str(b)+r' node[above] {$'+label+'$};')
 for x,y,label in points:s.append(r'\fill '+'({},{}) circle (2pt) node[below right] {{${}$}};'.format(x,y,label))
 s.append(r'\end{tikzpicture}')
 if name=='nonlinear-combined':
  s=[v.replace('x=0.85cm,y=0.85cm','x=1.4cm,y=1.4cm').replace('node[below right] {$(0,0)$}', 'node[above left] {$(0,0)$}').replace('node[below right] {$(-1,-1)$}', 'node[left] {$(-1,-1)$}') for v in s]
 (out/(name+'.tex')).write_text('\n'.join(s))
angles=[i*math.pi/4 for i in range(8)]
plot('linear-source',lambda x,y:(7*x+y,6*x+8*y),[(.35*math.cos(a),.35*math.sin(a)) for a in angles],(-3,3,-3,3),[(0,0,'0')],[((-1,-3),(1,3),r'\mathbf{v}_1'),((-1.5,3),(1.5,-3),r'\mathbf{v}_2')],h=.003)
plot('general-source',lambda x,y:(2*x,y),[(.25*math.cos(a),.25*math.sin(a)) for a in angles],(-3,3,-3,3),[(0,0,'0')],[((-3,0),(3,0),r'\mathbf{v}_1'),((0,-3),(0,3),r'\mathbf{v}_2')])
plot('linear-spiral',lambda x,y:(-x-4*y,2*x+3*y),[(1,0),(-1,0)],(-3,3,-3,3),[(0,0,'0'),(1,0,'(1,0)')])
plot('local-saddle',lambda x,y:(x-y,-y),[(.3*math.cos(a),.3*math.sin(a)) for a in angles],(-2,2,-2,2),[(0,0,'(0,0)')])
plot('local-sink',lambda x,y:(-2*x,-2*x-y),[(1.5*math.cos(a),1.5*math.sin(a)) for a in angles],(-2,2,-2,2),[(0,0,'(1,-1)')])
plot('local-spiral',lambda x,y:(2*x-2*y,2*x-y),[(.2,0),(-.2,0)],(-2,2,-2,2),[(0,0,'(-1,-1)')])
f=lambda x,y:(x-y-x*x+x*y,-x*x-y)
seeds=[(-1+.12*math.cos(a),-1+.12*math.sin(a)) for a in angles]+[(.05,0),(-.05,0),(.02,.04),(-.02,-.04),(1,1.5),(2,1),(2,-2),(-2,-2),(0,-2),(0,1.5)]
plot('nonlinear-combined',f,seeds,(-2.5,2.5,-3,2),[(0,0,'(0,0)'),(1,-1,'(1,-1)'),(-1,-1,'(-1,-1)')],h=.008,steps=2200)
