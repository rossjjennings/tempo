c      $Id$
      program tdbgen

c     This program uses the "tdb1ns" routine by Fairhead et al. to generate
c     sets of Chebyshev polynomial coefficients to be used for calculating
c     TDB-TDT in Tempo.

c     DJN  19 August 1997

c     Based on convert.f and dconvert.f, older programs which generated
c     tempo support files.

      integer NN, NRECL
      parameter (NN=20)         ! #coeffs calculated (not all are retained)
      parameter (NRECL=4)       ! "record length" of 4 bytes in a 
                                ! direct access file.  
                                ! Solaris, Linux: NRECL=4
                                ! Vax, OSF/1:  NRECL=1



      real*8 c(NN), f(NN), jd
      real*8 pi
      data pi/3.141592653589793d0/

      integer dt, ncf
      real*8 bma, bpa
      real*8 fac
      real*8 y
      real*8 sum


      integer i, j, k
      real*8 d1, d2
      character*160 s
      character*160 outfile

      integer iargc              ! built-in function


      if (iargc().eq.3) then
        call getarg(1,s)
        read (s,*) d1
        call getarg(2,s)
        read (s,*) d2
        call getarg(3,outfile)
      else
        write (*,*) 'Use:  dconvert d1 d2 outputfile'
        write (*,*) 'd1 and d2 are start, end date in years'
        stop
      endif

c
c	step size (days), number of coefficients per interval
c	used to calculate CTATV (aka TDT-TDB).
c	this should really be a user input.
c	16 days, 8 coefficients gives < 5 ns accuracy
c
      dt = 16                   ! days per interval
      ncf = 8                   ! coefficients retained within an interval

c       convert to JD if Years were entered
      if (d1 .LT. 3000D0) d1 = 365.25*d1 + 1721045
      if (d2 .LT. 3000D0) d2 = 365.25*d2 + 1721045
c       neaten them up a bit
      d1 = dint(d1)
      d2 = d1 + dint((d2-d1)/dt)*dt

      open (8,file=outfile,access='DIRECT',
     +     status='NEW',recl=2*NCF*NRECL)

      write (8,rec=1) d1, d2, dt, ncf, (0,i=7,2*NCF) ! pad out to full recl

c     calculate coefficients from Fairhead et al routine.
c     for information on numerical routines & Chebyshev polynomials, see 
c     Numerical Recipes, sec. 5.6;  note that our "c(1)" is half their "c(1)".
c     Note that NN=20 coefficients are calculated but only NCF are retained 
c     in the file.


      bma = 0.5d0 * dt
      fac = 2.d0 / nn
      do 300 i = 0, (d2-d1)/dt-1
        jd = d1 + i*dt
        bpa = jd + bma
        do 310 j = 1, nn
          y = cos(pi*(j-0.5d0)/nn)*bma
          call tdbtrans (bpa,y,f(j))
 310    continue
        do 320 j = 1, nn
          sum = 0.d0
          do 325 k = 1, nn
            sum = sum + f(k)*cos((pi*(j-1))*((k-0.5d0)/nn))
 325      continue
          c(j) = fac * sum
 320    continue
        c(1) = 0.5d0 * c(1) 
        write (8,rec=i+2) (c(j),j=1,ncf) ! i+2 because(a)i=0..(b)rec1 is hdr
 300  continue

      close (8)

      end
