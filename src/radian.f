c      $Id$
      SUBROUTINE RADIAN (DEC,IDEG,MIN,SEC,M,N)

C  IF N=+1,CONVERT FORM RADIANS TO DEG,MIN,SEC.
C  IF N=-1,CONVERT FROM DEG,MIN,SEC, TO RADIANS
C  IF M=123, READ HOURS,MIN,SEC, FOR DEG,MIN,SEC.

      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER*4 HH
      DATA HH/123/

      IF (N.LT.0) GO TO 10
      IF (M.EQ.HH) DEC=DEC/15.D0
      DEG=DEC*57.2957795131D0
      IDEG=DEG
      XMIN=(DEG-IDEG)*60.D0
      MIN=XMIN
      SEC=(XMIN-MIN)*60.D0
      MIN=IABS(MIN)
      SEC=DABS(SEC)
      IF (M.EQ.HH) DEC=DEC*15.D0
      RETURN

10    DEG=IDEG
      DEC=(IDEG+ISIGN(MIN,IDEG)/60.D0+DSIGN(SEC,DEG)/3600.D0) /
     +  57.2957795131D0
      IF (M.EQ.HH) DEC=DEC*15.D0

      RETURN
      END
