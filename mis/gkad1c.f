      SUBROUTINE GKAD1C (XMD,XOD,XCR1,XCR2,XCR3,XCR4,XCR5,XCR6,XSETD)
C
C     GKAD1C SETS UP TO REDUCE STRUCTURAL MODAL
C
      INTEGER         XMD,XOD,XCR1,XCR2,XCR3,XCR4,XCR5,XCR6,XSETD,
     1                GMD,GOD,SCR1,SCR2,SCR3,SCR4,SCR5,SCR6,USETD,
     2                OMIT,SINGLE,CHECK,NAME(2)
CNV  3                MCB(7),T
      COMMON /BITPOS/ UM,UO,UR,USG,USB,UL,UA,UF,US,UN,UG,UE,UP,UNE,UFE,
     1                UD
      COMMON /BLANK / TYPE(2),APP(2),MODAL(2),G,W3,W4,IK2PP,
     1                IM2PP,IB2PP,MULTI,SINGLE,OMIT,NOUE
      DATA    NAME  / 4HGKAD,4H1C      /
C
      GMD   = XMD
      GOD   = XOD
      SCR1  = XCR1
      SCR2  = XCR2
      SCR3  = XCR3
      SCR4  = XCR4
      SCR5  = XCR5
      SCR6  = XCR6
      USETD = XSETD
      CHECK = 123456789
      RETURN
C
C
      ENTRY GKAD1D (K2PP,K2DD)
C     ========================
C
      IF (CHECK .NE. 123456789) CALL MESAGE (-37,0,NAME)
C
C     NAVY'S FIX (MARKED BY CNV) TO FORCE K2NN BE SYMMETRIC IF K2PP IS
C     SYMMETRIC. A PARAMETER OF -6 IS PASSED TO SSG2B TO FLAG THE FORM
C     OF THE MATRIX TO BE SYMMETRIC.
C     ALSO, IN SSG2B, ABOUT LINE 55, ADD FOLLOWING 2 LINES
C           IF (T1 .EQ. -6) T = 1
C           IF (T1 .EQ. -6) FILED(4) = SYMM
C
C     (THE FIX IS NOT ADOPTED HERE. A MORE GENERAL FIX IS ADDED IN SSG2B
C     WHICH SHOULD TAKE CARE OF THE PROBLEM HERE   G.C/UNISYS 3/93)
C
CNV   MCB(1) = K2PP
CNV   CALL RDTRL (MCB)
CNV   T = 1
CNV   IF (MCB(4) .EQ. 6) T = -6
C
      K2FF = K2DD
      IF (MULTI .LT. 0) GO TO 20
      IF (OMIT.LT.0 .AND. SINGLE.LT.0) GO TO 10
      K2NN = SCR4
      IF (SINGLE .LT. 0) K2NN = K2DD
      GO TO 30
   10 K2NN = K2DD
      GO TO 30
   20 K2NN = K2PP
   30 IF (SINGLE .GE. 0) GO TO 40
      K2FF = K2NN
   40 IF (MULTI .LT. 0) GO TO 50
C
C     MULTI POINT CONSTRAINTS
C
      CALL UPART (USETD,SCR1,UP,UNE,UM)
      CALL MPART (K2PP,SCR2,SCR3,SCR5,SCR4)
      CALL SSG2B (SCR4,GMD,SCR3,SCR1,0,2,1,SCR6)
      CALL SSG2B (SCR5,GMD,SCR2,SCR3,0,2,1,SCR6)
C
CNV   CALL SSG2B (GMD,SCR1,SCR3,K2NN,T,2,1,SCR6)
      CALL SSG2B (GMD,SCR1,SCR3,K2NN,1,2,1,SCR6)
C
   50 IF (SINGLE .LT. 0) GO TO 60
      CALL UPART (USETD,SCR1,UNE,UFE,US)
      CALL MPART (K2NN,K2FF,0,0,0)
   60 IF (OMIT .LT. 0) GO TO 70
      CALL UPART (USETD,SCR1,UFE,UD,UO)
      CALL MPART (K2FF,SCR2,SCR3,SCR5,SCR4)
      CALL SSG2B (SCR4,GOD,SCR3,SCR1,0,2,1,SCR6)
      CALL SSG2B (SCR5,GOD,SCR2,SCR3,0,2,1,SCR6)
C
CNV   CALL SSG2B (GOD,SCR1,SCR3,K2DD,T,2,1,SCR6)
      CALL SSG2B (GOD,SCR1,SCR3,K2DD,1,2,1,SCR6)
C
   70 RETURN
      END
