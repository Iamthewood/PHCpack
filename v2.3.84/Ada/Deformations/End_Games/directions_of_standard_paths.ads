with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Floating_Vectors;
with Standard_Complex_Vectors;
with Standard_Floating_VecVecs;          use Standard_Floating_VecVecs;

package Directions_of_Standard_Paths is

-- DESCRIPTION :
--   This package provides some routines to estimate numerically the direction
--   of a solution path diverging to a solution of a face system,
--   using standard floating-point arithmetic.

  procedure Affine_Update_Direction
                ( t,prev_t,target : in Complex_Number;
                  x,prevx : in Standard_Complex_Vectors.Vector;
                  prevdls,prevstep : in out double_float;
                  prevdiff,v : in out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Computes an approximation of the direction of the path.
  --   When prevdls /= 0.0, a second-order extrapolation will be applied.

  -- ON ENTRY :
  --   t          current value of continuation parameter;
  --   prev_t     previous value of continuation parameter;
  --   target     target value of continuation parameter;
  --   x          current solution vector;
  --   prevx      solution vector for previous value of continuation parameter;
  --   prevdls    previous difference of the logs of distances to target;
  --   prevstep   previous step size;
  --   prevdiff   previous difference of the logs of the solution vectors;
  --   v          current approximate direction of the path.

  procedure Projective_Update_Direction
                ( t,prev_t,target : in Complex_Number;
                  x,prevx : in Standard_Complex_Vectors.Vector;
                  prevdls,prevstep : in out double_float;
                  prevdiff,v : in out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Does the same as the other procedure, under the assumption that the
  --   solution vector lies in projective space.

  -- REQUIRED : 
  --   The homogenization variable is the last element of the solution vector.

  procedure Affine_Update_Direction
                ( r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx,wvl0,wvl1,wvltmp : in out VecVec;
                  v,diferr : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  procedure Affine_Update_Direction
                ( file : in file_type;
                  r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx,wvl0,wvl1,wvltmp : in out VecVec;
                  v,diferr : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  -- DESCRIPTION :
  --   Higher-order extrapolation method that produces direction with error of
  --   order (t-target)^r, when the solution path converges to regular solution
  --   in affine space.

  -- REQUIRED : s'range = logs'range = logx'range = 0..max,
  --   wvl'range = 1..max, logx(i)'range = wvl'range(i) = 1..n,
  --   diferr'range = 0..max, max >= 1, equals maximal order of extrapolator.

  -- ON ENTRY :
  --   file       to write intermediate data, if not submitted, no output;
  --   r          last meaningful entry in logx and logs;
  --   m          current value for multiplicity;
  --   estm       current estimate for multiplicity;
  --   cntm       number of consecutive times estm has been guessed;
  --   thresm     threshold for changing the m to estm;
  --   er         order of extrapolator on the errors;
  --   t          current value of continuation parameter;
  --   target     target value of continuation parameter;
  --   x          current solution for t;
  --   dt         consecutive distances of t-values to target value;
  --   s          consecutive s-values, with proper value for m;
  --   logs       logarithms of previous values (target - t);
  --   logx       logarithms of previous solution vectors;
  --   wvl0       previous consecutive estimates for direction;
  --   wvl1       current consecutive estimates for direction;
  --   wvltmp     work space for updating wvl0 and wvl1.

  -- ON RETURN :
  --   r          if r < logs'last, then r will be raised by one,
  --              otherwise r remains unchanged;
  --   s          updated distance vector;
  --   logs       updated vector of logarithms of distances to target;
  --   logx       updated vector of solution vectors;
  --   wvl0       updated previous consecutive estimates, equals wvl1;
  --   wvl1       updated current consecutive estimates for direction;
  --   v          estimated direction of path;
  --   diferr     norms of consecutive differences of estimates for v;
  --   error      norm of errorv;

  procedure Projective_Update_Direction
                ( r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx : in out VecVec;
                  prevv,v : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  procedure Projective_Update_Direction
                ( file : in file_type;
                  r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx : in out VecVec;
                  prevv,v : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  -- DESCRIPTION :
  --   Higher-order extrapolation method that produces direction with error of
  --   order (t-target)^r, when the solution path converges to regular solution
  --   in affine space.

  -- REQUIRED :
  --   x(x'last) contains value of variable introduced to homogenize the system.

end Directions_of_Standard_Paths;
