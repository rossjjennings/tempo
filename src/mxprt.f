c      $Id$
	subroutine mxprt(a,gcor,nn,mfit)

	implicit real*8 (a-h,o-z)
	include 'dim.h'
	real*8 a(NPA,NPA),sig(NPA),gcor(NPA)
	character*4 param(39),paramj
	character*1 agcor,line(NPA)
	character*11 mark
	integer*4 mfit(NPAP1)

	data param/'  f0','  f1','  f2',' Dec','  RA','pmdc','pmra',
     +    '   x','   e','  T0','  Pb','  Om','Omdt','gama','  DM',
     +    '  px','Pbdt','PPNg','   s','   M','  m2',' dth','xdot',
     +    'edot','  x2','  e2',' T02',' Pb2',' Om2','  x3','  e3',
     +    ' T03',' Pb3',' Om3','PMRV','XOmd','Xpbd','xxx4','xxx5'/
	data mark/' 123456789*'/

	close(72)
	open(72,file='matrix.tmp',status='unknown',form='unformatted')

	do 5 j=1,nn
5	sig(j)=sqrt(a(j,j))

	write(31,1005) (mod(i,10),i=1,nn)
1005	format(12x,'G  ',70i1)
	write(31,1006) ('-',i=1,nn)
1006	format(12x,'-  ',70a1)

	do 20 j=1,nn
	do 10 k=1,nn
	x=abs(a(j,k)/(sig(j)*sig(k)))
	i=1
	if(x.gt.0.9d0) i=2
	if(x.gt.0.99d0) i=3
	if(x.gt.0.999d0) i=4
	if(x.gt.0.9999d0) i=5
	if(x.gt.0.99999d0) i=6
	if(x.gt.0.999999d0) i=7
	if(x.gt.0.9999999d0) i=8
	if(x.gt.0.99999999d0) i=9
	if(x.gt.0.999999999d0) i=10
	if(x.gt.0.9999999999d0) i=11
10	line(k)=mark(i:i)
	y=abs(gcor(j))
	i=1
	if(y.gt.0.9d0) i=2
	if(y.gt.0.99d0) i=3
	if(y.gt.0.999d0) i=4
	if(y.gt.0.9999d0) i=5
	if(y.gt.0.99999d0) i=6
	if(y.gt.0.999999d0) i=7
	if(y.gt.0.9999999d0) i=8
	if(y.gt.0.99999999d0) i=9
	if(y.gt.0.999999999d0) i=10
	if(y.gt.0.9999999999d0) i=11
	agcor=mark(i:i)
	jj=mfit(j+1)

	if(jj.le.40) then
	  paramj=param(jj-1)			!One of the listed params
	else if(jj.le.50) then
	  write(paramj,1017) jj-40		!DM polynomial coeffs
1017	  format(' DM',z1)
	else if(jj.le.60) then
	  write(paramj,1018) jj-50+2		!Freq derivatives
1018	  format('  f',z1)
	else if(jj.lt.60+NGLT*NGLP)then		!Gltiches
	  jj1=jj-61
	  jj2=mod(jj1,NGLP)+1
	  jj1=jj1/NGLP+1
	  write(paramj,1030)jj1,jj2
1030	  format('GL',2i1)
	else
	  write(paramj,1019) jj-(60+NGLT*NGLP)		!Offsets
1019	  format(' O',i2)
	  if(paramj(2:3).eq.'O ') paramj(2:3)=' O'
	endif

	write(72) nn,j,paramj,gcor(j),sig(j),
     +    (a(j,k)/(sig(j)*sig(k)),k=1,nn)
20	write(31,1020) float(j),paramj,agcor,(line(i),i=1,nn)
1020	format(f4.0,2x,a4,'| ',a1,2x,70a1)

	write(31,1006) ('-',i=1,nn)
	write(31,1005) (mod(i,10),i=1,nn)

	return
	end
