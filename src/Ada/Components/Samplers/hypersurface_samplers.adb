with Standard_Natural_Numbers_io;       use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;      use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;          use Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;       use Standard_Complex_Numbers_io;
with Standard_Complex_Numbers_Polar;    use Standard_complex_Numbers_Polar;
with Standard_Random_Numbers;           use Standard_Random_Numbers;
with Standard_Complex_Norms_Equals;     use Standard_Complex_Norms_Equals;
with Standard_Complex_Vectors_io;       use Standard_Complex_Vectors_io;
with Sets_of_Unknowns;                  use Sets_of_Unknowns;
with Degrees_in_Sets_of_Unknowns;       use Degrees_in_Sets_of_Unknowns;
with Set_Structure;

package body Hypersurface_Samplers is

-- PART I : computation of generic points with root finder

  function Roots_of_Unity ( d : natural32 ) return Vector is

  -- DESCRIPTION :
  --   Returns a vector with the d complex roots of unity.
  --   We take roots as unity as start values for the univariate
  --   root finder.

    res : Vector(1..integer32(d));
    one : constant Complex_Number := Create(1.0);

  begin
    for i in 1..d loop
      res(integer32(i)) := Root(one,d,i);
    end loop;
    return res;
  end Roots_of_Unity;

  function Compute_q ( i : integer32; a : Vector ) return Complex_Number is

  -- DESCRIPTION :
  --   Computes the quotient needed in the Durand-Kerner step.

    res : Complex_Number;

  begin
    res := Create(1.0);
    for j in a'range loop
      if j /= i
       then res := res*(a(i)-a(j));
      end if;
    end loop;
    return res;
  end Compute_q;

  function Eval ( p : Eval_Poly; b,v : Vector; t : Complex_Number )
                return Complex_Number is

  -- DESCRIPTION :
  --   Returns the function value of p at the point b + t*v.

    point : constant Vector(b'range) := b + t*v;

  begin
    return Eval(p,point);
  end Eval;

  procedure DK ( p : in Eval_Poly; b,v : in Vector;
                 lc : Complex_Number; z,res : in out Vector ) is

  -- DESCRIPTION :
  --   Computes one step in the Durand-Kerner iteration with
  --   the polynomial p/lc, where lc is the leading coefficient
  --   for the parameteric representation using the direction v.
  --   For high degrees, overflow exceptions often occur.
  --   To handle this, we just choose another random starting point.

  begin
    for i in z'range loop
      declare
      begin
        z(i) := z(i) - Eval(p,b,v,z(i))/(lc*Compute_q(i,z));
        res(i) := Eval(p,b,v,z(i))/lc;
      exception
        when others => --put("Exception occurred at component ");
                       --put(i,1); put_line(".");
                       z(i) := Random1;
      end;
    end loop;
  end DK;

  procedure Silent_Durand_Kerner
              ( p : in Eval_Poly; b,v : in Vector; lc : in Complex_Number;
                z : in out Vector; res : out Vector;
                maxit : in natural32; eps : in double_float;
                numit : out natural32; fail : out boolean ) is

  -- DESCRIPTION :
  --   Applies the method of Weierstrass to the polynomial p,
  --   in order to find points on a general line.

  -- ON ENTRY :
  --   p        multivariate polynomial;
  --   b        base point of general line x(t) = b + t*v;
  --   v        direction of general line;
  --   lc       leading coefficient of the polynomial p;
  --   z        current approximations for the roots;
  --   maxit    maximal number of iterations;
  --   eps      desired accuracy on the residuals.

  -- ON RETURN :
  --   z        new approximations for the roots;
  --   res      residuals at the roots z;
  --   numit    number of iterations performed;
  --   fail     is true when desired accuracy is not reached,
  --            false otherwise.

  -- IMPLEMENTATION NOTE :
  --   The iteration stops before the maximal allowed number
  --   if the desired accuracy is reached and the method is
  --   no longer converging.

    nrm,previous_nrm : double_float;

  begin
    previous_nrm := 1.0;
    fail := true;
    for k in 1..maxit loop
      DK(p,b,v,lc,z,res);
      nrm := Max_Norm(res);
      if nrm <= eps
       then if nrm > previous_nrm
             then fail := false;
                  numit := k; return;
            end if;
      end if;
      previous_nrm := nrm;
    end loop;
    if fail
     then fail := (nrm <= eps);
    end if;
    numit := maxit;
  end Silent_Durand_Kerner;

  procedure Reporting_Durand_Kerner
              ( file : in file_type;
                p : in Eval_Poly; b,v : in Vector; lc : in Complex_Number;
                z : in out Vector; res : out Vector;
                maxit : in natural32; eps : in double_float;
                numit : out natural32; fail : out boolean ) is

  -- DESCRIPTION :
  --   Except for the first parameter "file", all parameters have the
  --   same meaning as the silent version above.

    nrm,previous_nrm,absres : double_float;

  begin
    previous_nrm := 1.0;
    fail := true;
    numit := maxit;
    for k in 1..maxit loop
      DK(p,b,v,lc,z,res);
      nrm := Max_Norm(res);
      if nrm <= eps
       then if nrm >= previous_nrm
             then fail := false;
                  numit := k; exit;
            end if;
      end if;
      previous_nrm := nrm;
    end loop;
    if fail
     then fail := (nrm > eps);
    end if;
    put(file,"Max norm at last step "); put(file,numit,1);
    put(file," : "); put(file,nrm); new_line(file);
    if fail
     then put(file,"Failed to reached desired accuracy");
     else put(file,"Reached desired accuracy");
    end if;
    put(file,eps,3); put_line(file,".");
    for i in z'range loop
      put(file,z(i)); put(file," : ");
      absres := AbsVal(res(i));
      put(file,absres); new_line(file);
    end loop;
  end Reporting_Durand_Kerner;

  --function Lead_Coefficient ( t : Term; v : Vector ) return Complex_Number is
  --
  -- DESCRIPTION :
  --   For x(i) = a + l*v(i), with l some parameter, the function
  --   return the coefficients of the highest degree term in l when
  --   expanding the x(i) in terms of a + l*v(i).
  --
  -- REQUIRED : v has no zero components.
  --
  --  res : Complex_Number := t.cf;
  --
  --begin
  --  for i in t.dg'range loop
  --    if v(i) /= Create(0.0)
  --     then for j in 1..t.dg(i) loop
  --            res := res*v(i);
  --          end loop;
  --    end if;
  --  end loop;
  --  return res;
  --end Lead_Coefficient;

 -- function Lead_Coefficient ( p : Poly; d : natural32; v : Vector )
 --                           return Complex_Number is
 --
  -- DESCRIPTION :
  --   Applies Lead_Coefficient to every term of degree d in the
  --   polynomials and returns the sum.
 --
  -- REQUIRED : v has no zero components.
 --
 --   res : Complex_Number := Create(0.0);
 --
 --   procedure Lead_by_Term ( t : in Term; cont : out boolean ) is
 --
 --   begin
 --     if Standard_Natural_Vectors.Sum
 --          (Standard_Natural_Vectors.Vector(t.dg.all)) = d
 --      then res := res + Lead_Coefficient(t,v);
 --     end if;
 --     cont := true;
 --   end Lead_by_Term;
 --   procedure Lead_by_Terms is new Visiting_Iterator(Lead_by_Term);
 --
 -- begin
 --   Lead_by_Terms(p);
 --   return res;
 -- end Lead_Coefficient;

  function Lead_Coefficient ( t : Term; b,v : Vector ) return Complex_Number is

  -- DESCRIPTION :
  --   For x(i) = b + l*v(i), with l some parameter, the function
  --   return the coefficients of the highest degree term in l when
  --   expanding the x(i) in terms of b + l*v(i).

    res : Complex_Number := t.cf;

  begin
    for i in t.dg'range loop
      if v(i) = Create(0.0)
       then for j in 1..t.dg(i) loop
              res := res*b(i);
            end loop;
       else for j in 1..t.dg(i) loop
              res := res*v(i);
            end loop;
      end if;
    end loop;
    return res;
  end Lead_Coefficient;

  function Lead_Coefficient ( p : Poly; d : natural32; b,v : Vector )
                            return Complex_Number is

  -- DESCRIPTION :
  --   Applies Lead_Coefficient to every term of degree d in the
  --   polynomial p(b + t*v) and returns the sum.  The vector b is
  --   used for those components i  for which v(i) is zero.

    res : Complex_Number := Create(0.0);

    procedure Lead_by_Term ( t : in Term; cont : out boolean ) is

      sum : natural32 := 0;

    begin
      for i in t.dg'range loop
        if v(i) /= Create(0.0)
         then sum := sum + t.dg(i);
        end if;
      end loop;
      if sum = d
       then res := res + Lead_Coefficient(t,b,v);
      end if;
      cont := true;
    end Lead_by_Term;
    procedure Lead_by_Terms is new Visiting_Iterator(Lead_by_Term);

  begin
    Lead_by_Terms(p);
    return res;
  end Lead_Coefficient;

-- PART II : moving hyperplanes to continue the generic points

  procedure Predict ( b0,v0,b1,v1 : in Vector; lambda : in Complex_Number;
                      b,v : out Vector ) is

  -- DESCRIPTION :
  --   Computes the line (b,v) := (b0,v0)*(1-lambda) + (b1,v1)*lambda.

  -- ON ENTRY :
  --   b0             base point of line at the start;
  --   v0             direction of line at the start;
  --   b1             base point of line at the end;
  --   v1             direction of line at the end;
  --   lambda         continuation parameter moves from zero to one.

  -- ON RETURN :
  --   b              base point for new general line;
  --   v              direction for new general line.

    aux : constant Complex_Number := Create(1.0) - lambda;

  begin
    b := aux*b0 + lambda*b1;
    v := aux*v0 + lambda*v1;
  end Predict;

  procedure Newton ( p : in Eval_Poly_Sys;
                     b,v : in Vector; t : in out Complex_Number;
                     ft,dt : out Complex_Number ) is

  -- DESCRIPTION
  --   Does one Newton step on the line b + t*v intersected with
  --   the hypersurface p(0) to determine a new value for t.

  -- ON ENTRY :
  --   p             Horner forms of multivariate polynomials :
  --                   p(0) is the original polynomial,
  --                   p(i) is the i-th derivative;
  --   b             base point for the line;
  --   v             direction of the line x(t) = b + t*v;
  --   t             parameter to determine location on the line.

  -- ON RETURN :
  --   t             new location on the line, closer to surface;
  --   ft            previous function value at t;
  --   dt            increment for t, measures also closeness to surface.

    x : constant Vector(b'range) := b + t*v;
    dp : Complex_Number := Create(0.0);

  begin
    ft := Eval(p(0),x);
    for i in 1..p'last loop                -- apply the chain rule
      dp := dp + v(i)*Eval(p(i),x);
    end loop;
    dt := -ft/dp;
    t := t + dt;
  end Newton;

  procedure Modified_Newton 
                   ( p : in Eval_Poly_Sys; b,v : in Vector;
                     m : in natural32; t : in out Complex_Number;
                     ft,dt : out Complex_Number ) is

  -- DESCRIPTION
  --   Does one Newton step on the line b + t*v intersected with
  --   the hypersurface p(0) to determine a new value for t,
  --   using m as value for the multiplicity of the root.

  -- ON ENTRY :
  --   p             Horner forms of multivariate polynomials :
  --                   p(0) is the original polynomial,
  --                   p(i) is the i-th derivative;
  --   b             base point for the line;
  --   v             direction of the line x(t) = b + t*v;
  --   m             multiplicity of the root;
  --   t             parameter to determine location on the line.

  -- ON RETURN :
  --   t             new location on the line, closer to surface;
  --   ft            previous function value at t;
  --   dt            increment for t, measures also closeness to surface.

    x : constant Vector(b'range) := b + t*v;
    dp : Complex_Number := Create(0.0);
    cm : constant Complex_Number := Create(m);

  begin
    ft := Eval(p(0),x);
    for i in 1..p'last loop                -- apply the chain rule
      dp := dp + v(i)*Eval(p(i),x);
    end loop;
    dt := -cm*ft/dp;
    t := t + dt;
  end Modified_Newton;

  procedure Correct ( p : Eval_Poly_Sys;
                      b,v : in Vector; t : in out Complex_Number;
                      maxit : in natural32; numit : out natural32;
                      eps : in double_float; fail : out boolean ) is

  -- DESCRIPTION :
  --   Applies Newton's method to correct the solution back.

  -- ON ENTRY :
  --   p             Horner forms of multivariate polynomials :
  --                   p(0) is the original polynomial,
  --                   p(i) is the i-th derivative;
  --   b             base point for the line;
  --   v             direction of the line x(t) = b + t*v;
  --   t             parameter to determine location on the line.
  --   maxit         maximal number of Newton iterations;
  --   eps           desired accuracy.

  -- ON RETURN :
  --   t             new location on the line, closer to surface;
  --   numit         number of iterations performed;
  --   fail          true if desired accuracy not reached.

    ft,dt : Complex_Number;

  begin
    for k in 1..maxit loop
      Newton(p,b,v,t,ft,dt);
      if (AbsVal(ft) < eps) or (AbsVal(dt) < eps)
       then numit := k; fail := false;
            return;
      end if;
    end loop;
    numit := maxit; fail := true;
  end Correct;

  procedure Correct ( file : in file_type; p : Eval_Poly_Sys;
                      b,v : in Vector; t : in out Complex_Number;
                      maxit : in natural32; numit : out natural32;
                      eps : in double_float; fail : out boolean ) is

  -- DESCRIPTION :
  --   Applies Newton's method to correct the solution back.

  -- ON ENTRY :
  --   file          for intermediate output and diagnostics;
  --   p             Horner forms of multivariate polynomials :
  --                   p(0) is the original polynomial,
  --                   p(i) is the i-th derivative;
  --   b             base point for the line;
  --   v             direction of the line x(t) = b + t*v;
  --   t             parameter to determine location on the line.
  --   maxit         maximal number of Newton iterations;
  --   eps           desired accuracy.

  -- ON RETURN :
  --   t             new location on the line, closer to surface;
  --   numit         number of iterations performed;
  --   fail          true if desired accuracy not reached.

    ft,dt : Complex_Number;
    aft,adt : double_float;

  begin
    for k in 1..maxit loop
      Newton(p,b,v,t,ft,dt);
      aft := AbsVal(ft);
      adt := AbsVal(dt);
      put(file,"  |ft| : "); put(file,aft,3);
      put(file,"  |dt| : "); put(file,aft,3); new_line(file);
      if (aft < eps) or (adt < eps)
       then numit := k; fail := false;
            return;
      end if;
    end loop;
    numit := maxit; fail := true;
  end Correct;

  procedure Step_Control ( fail : in boolean; maxstep : in double_float;
                           thres : in natural32; succnt : in out natural32;
                           step : in out double_float ) is

  -- DESCRIPTION :
  --   Implements a simple adaptive step control strategy.

  -- ON ENTRY :
  --   fail        if fail, then the step size will be multiplied with 0.75,
  --               otherwise, the step size will be multiplied with 1.5,
  --               provided the number of consecutive successes exceeds
  --               the thres value, also step <= maxstep;
  --   maxstep     maximal step size;
  --   thres       threshold to augment the step size;
  --   succnt      counts the number of successful corrections;
  --   step        current value of the step size.

  -- ON RETURN :
  --   succnt      updated counter;
  --   step        new step size. 

  begin
    if fail
     then succnt := 0;
          step := step*0.5;
     else succnt := succnt + 1;
          if succnt > thres
           then step := step*1.25;
                if step > maxstep
                 then step := maxstep;
                end if;
          end if;
    end if;
  end Step_Control;

  procedure Silent_Path_Tracker 
                ( p : Eval_Poly_Sys; b0,v0,b1,v1 : in Vector;
                  t : in out Complex_Number;
                  numbsteps : out natural32; fail : out boolean ) is

  -- DESCRIPTION :
  --   Performs path tracking from b0 + t*v0 to b1 + t*v1.

  -- ON ENTRY :
  --   p          polynomial with its derivatives;
  --   (b0,v0)    start line b0 + t*v0;
  --   (b1,v1)    target line b1 + t*v1;
  --   output     flag for intermediate predictor-corrector output;
  --   t          value for t at the start of the path.
 
  -- ON RETURN :
  --   t          value for t at the end of the path;
  --   numbsteps  number of predictor-corrector steps executed;
  --   fail       true if end of path not reached.

    maxsteps : constant natural32 := 5000;
    maxstep : constant double_float := 0.01;
    maxit : constant natural32 := 4;
    eps : constant double_float := 1.0E-8;
    thres : constant natural32 := 3;
    succnt : natural32 := 0;
    step : double_float := maxstep;
    lambda : Complex_Number := Create(step);
    b,v : Vector(b0'range);
    numit : natural32;
    fail_newt : boolean := false;
    backup_t,t0 : Complex_Number := t;
    backup_lambda : Complex_Number := Create(0.0);

  begin
    for i in 1..maxsteps loop
      Predict(b0,v0,b1,v1,lambda,b,v);
      t := t + Create(step)*(backup_t - t0);
      Correct(p,b,v,t,maxit,numit,eps,fail_newt);
      Step_Control(fail_newt,maxstep,thres,succnt,step);
      if fail_newt
       then t := backup_t;
            lambda := backup_lambda + Create(step);
       else if (REAL_PART(lambda) = 1.0)
             then numbsteps := i; fail := false;
                  return;
             else t0 := backup_t;
                  backup_t := t;
                  backup_lambda := lambda;
                  lambda := lambda + Create(step);
                  if REAL_PART(lambda) > 1.0
                   then lambda := Create(1.0);
                  end if;
            end if;
      end if;
    end loop;
    numbsteps := maxsteps; fail := true;
  end Silent_Path_Tracker;

  procedure Reporting_Path_Tracker
                  ( file : in file_type; p : Eval_Poly_Sys;
                    b0,v0,b1,v1 : in Vector; output : in boolean;
                    t : in out Complex_Number;
                    numbsteps : out natural32; fail : out boolean ) is

  -- DESCRIPTION :
  --   Performs path tracking from b0 + t*v0 to b1 + t*v1.

  -- ON ENTRY :
  --   file         for intermediate output and diagnostics;
  --   p            polynomial with its derivatives;
  --   (b0,v0)      start line b0 + t*v0;
  --   (b1,v1)      target line b1 + t*v1;
  --   output       flag for intermediate predictor-corrector output;
  --   t            value for t at the start of the path.
 
  -- ON RETURN :
  --   t            value for t at the end of the path;
  --   numbsteps    number of predictor-corrector steps executed;
  --   fail         true if end of path not reached.

    maxsteps : constant natural32 := 5000;
    maxstep : constant double_float := 0.01;
    maxit : constant natural32 := 4;
    eps : constant double_float := 1.0E-8;
    thres : constant natural32 := 3;
    succnt : natural32 := 0;
    step : double_float := maxstep;
    lambda : Complex_Number := Create(step);
    b,v : Vector(b0'range);
    numit : natural32;
    fail_newt : boolean := false;
    backup_t,t0 : Complex_Number := t;
    backup_lambda : Complex_Number := Create(0.0);

  begin
    for i in 1..maxsteps loop
      Predict(b0,v0,b1,v1,lambda,b,v);
      t := t + Create(step)*(backup_t - t0);
      if output
       then put(file,"Step "); put(file,i,1);
            put(file," at "); put(file,REAL_PART(lambda),3);
            put(file," with step "); put(file,step,3); new_line(file);
            Correct(file,p,b,v,t,maxit,numit,eps,fail_newt);
       else Correct(p,b,v,t,maxit,numit,eps,fail_newt);
      end if;
      Step_Control(fail_newt,maxstep,thres,succnt,step);
      if fail_newt
       then t := backup_t;
            lambda := backup_lambda + Create(step);
       else if (REAL_PART(lambda) = 1.0)
             then numbsteps := i; fail := false;
                  return;
             else t0 := backup_t;
                  backup_t := t;
                  backup_lambda := lambda;
                  lambda := lambda + Create(step);
                  if REAL_PART(lambda) > 1.0
                   then lambda := Create(1.0);
                  end if;
            end if;
      end if;
    end loop;
    numbsteps := maxsteps; fail := true;
  end Reporting_Path_Tracker;

-- AUXILIARIES FOR MULTIPLE GENERIC POINTS :

  function Multiplicities ( t : Vector; tol : double_float )
                          return Standard_Natural_Vectors.Vector is

  -- DESCRIPTION :
  --   A root has multiplicity m if there are m-1 other roots within
  --   distance tol of the root.

    res : Standard_Natural_Vectors.Vector(t'range) := (t'range => 1);

  begin
    for i in t'range loop
      for j in i+1..t'last loop
        if Radius(t(i)-t(j)) <= tol
         then res(i) := res(i)+1;
              res(j) := res(j)+1;
        end if;
      end loop;
    end loop;
    return res;
  end Multiplicities;

  function Random_Derivative
	      ( n : natural32; p : Poly;
	        a : Standard_Complex_Vectors.Vector ) return Poly is

  -- DESCRIPTION :
  --   Returns a random combination of the partial derivatives of p.

    res: Poly := Null_Poly;
    dp : Poly;

  begin
    for i in 1..integer32(n) loop
      dp := Diff(p,i);
      Mul(dp,a(i));
      Add(res,dp);
      Clear(dp);
    end loop;
    return res;
  end Random_Derivative;

  function Random_Derivatives
	      ( n,m : natural32; p : Poly;
	        a : Standard_Complex_Vectors.Vector ) return Poly_Sys is

    res : Poly_Sys(1..integer32(m));

  begin
    Copy(p,res(1));
    for i in 2..res'last loop
      res(i) := Random_Derivative(n,res(i-1),a);
    end loop;
    return res;
  end Random_Derivatives;

  function Max ( m : Standard_Natural_Vectors.Vector ) return natural32 is

    res : natural32 := m(m'first);

  begin
    for i in m'first+1..m'last loop
      if res < m(i)
       then res := m(i);
      end if;
    end loop;
    return res;
  end Max;

  function Failure ( t,dt,ft : Vector; eps : double_float ) return boolean is

  -- DESCRIPTION :
  --   Returns true if |dt(i)| > eps and |ft(i)| > eps, for some i.

    fail : boolean := false;
    relax,wrk_eps : double_float;

  begin
    for i in dt'range loop
      relax := AbsVal(t(i));
      if relax > 1.0
       then wrk_eps := eps*relax;
       else wrk_eps := eps;
      end if;
      if (AbsVal(dt(i)) > wrk_eps) and (AbsVal(ft(i)) > wrk_eps)
       then fail := true;
      end if;
      exit when fail;
    end loop;
    return fail;
  end Failure;

  procedure Refine_Roots ( n : in natural32; p : in Poly;
                           b,v : in Vector; t : in out Vector;
                           eps : in double_float; fail : out boolean ) is

    s : Eval_Poly_Sys(0..integer32(n));
    ft,dt : Vector(t'range);
    dp : Poly;

  begin
    s(0) := Create(p);
    for i in 1..s'last loop
      dp := Diff(p,i);
      s(i) := Create(dp);
      Clear(dp);
    end loop;
    Silent_Refiner(s,b,v,t,ft,dt,eps,8);
    fail := Failure(t,dt,ft,eps);
  end Refine_Roots;

  procedure Refine_Roots ( file : in file_type; n : in natural32; p : in Poly;
                           b,v : in Vector; t : in out Vector;
                           eps : in double_float; fail : out boolean ) is

    s : Eval_Poly_Sys(0..integer32(n));
    ft,dt : Vector(t'range);
    dp : Poly;

  begin
    s(0) := Create(p);
    for i in 1..s'last loop
      dp := Diff(p,i);
      s(i) := Create(dp);
      Clear(dp);
    end loop;
    Reporting_Refiner(file,s,b,v,t,ft,dt,eps,8);
    fail := Failure(t,dt,ft,eps);
  end Refine_Roots;

  procedure Refine_Roots ( n,max_m : in natural32; p : in Poly;
                           b,v : in Vector;
                           m : in Standard_Natural_Vectors.Vector;
                           t : in out Vector;
                           eps : in double_float; fail : out boolean;
                           rdp : out Link_to_Poly_Sys ) is

    mp : constant Poly_Sys(1..integer32(max_m))
       := Random_Derivatives(n,max_m,p,v);

  begin
    for i in t'range loop
      Refine_Roots(n,mp(integer32(m(i))),b,v,t(i..i),eps,fail);
      exit when fail;
    end loop;
    rdp := new Poly_Sys'(mp);
  end Refine_Roots;

  procedure Refine_Roots ( file : in file_type;
                           n,max_m : in natural32; p : in Poly;
                           b,v : in Vector;
                           m : in Standard_Natural_Vectors.Vector;
                           t : in out Vector;
                           eps : in double_float; fail : out boolean;
                           rdp : out Link_to_Poly_Sys ) is

    mp : constant Poly_Sys(1..integer32(max_m))
       := Random_Derivatives(n,max_m,p,v);

  begin
    for i in t'range loop
      Refine_Roots(file,n,mp(integer32(m(i))),b,v,t(i..i),eps,fail);
      exit when fail;
    end loop;
    rdp := new Poly_Sys'(mp);
  end Refine_Roots;

-- TARGET PROCEDURES, PART I :

  procedure Generic_Points
                ( file : in file_type;
                  p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean ) is

    roots : Vector(1..integer32(d)) := Roots_of_Unity(d);
    resid : Vector(1..integer32(d));
    lc : constant Complex_Number := Lead_Coefficient(p,d,b,v);
    numit : natural32 := 0;

  begin
    Reporting_Durand_Kerner(file,ep,b,v,lc,roots,resid,maxit,eps,numit,fail);
    t := roots;
  end Generic_Points;

  procedure Generic_Points
                ( file : in file_type;
                  p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean;
                  m : out Standard_Natural_Vectors.Vector ) is

    rdp : Link_to_Poly_Sys;

  begin
    Generic_Points(file,p,ep,d,b,v,eps,maxit,t,fail,m,rdp);
    Clear(rdp);
  end Generic_Points;

  procedure Generic_Points
                ( file : in file_type;
                  p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean;
                  m : out Standard_Natural_Vectors.Vector;
                  rdp : out Link_to_Poly_Sys;
                  rad,dst : out Standard_Floating_Vectors.Vector ) is

    n : constant integer32 := b'length;
    tol : constant double_float := 0.1;
    roots : Vector(1..integer32(d)) := Roots_of_Unity(d);
    resid : Vector(1..integer32(d));
    lc : constant Complex_Number := Lead_Coefficient(p,d,b,v);
    numit,max_m : natural32 := 0;

  begin
    Reporting_Durand_Kerner(file,ep,b,v,lc,roots,resid,maxit,eps,numit,fail);
    t := roots;
    m := Multiplicities(roots,tol);
    Cluster_Analysis(roots,tol,rad,dst);
    put_line(file,"After the cluster analysis : ");
    for i in t'range loop
      put(file,"  r : "); put(file,rad(i),3);
      put(file,"  R : "); put(file,dst(i),3);
      put(file,"  m = "); put(file,m(i),1); new_line(file);
    end loop;
    max_m := Max(m);
    Refine_Roots(file,natural32(n),max_m,p,b,v,m,t,eps,fail,rdp);
  end Generic_Points;

  procedure Generic_Points
                ( file : in file_type;
                  p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean;
                  m : out Standard_Natural_Vectors.Vector;
                  rdp : out Link_to_Poly_Sys ) is

    rad,dst : Standard_Floating_Vectors.Vector(1..integer32(d));

  begin
    Generic_Points(file,p,ep,d,b,v,eps,maxit,t,fail,m,rdp,rad,dst);
  end Generic_Points;

  procedure Generic_Points
                ( p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean ) is

    roots : Vector(1..integer32(d)) := Roots_of_Unity(d);
    resid : Vector(1..integer32(d));
    lc : constant Complex_Number := Lead_Coefficient(p,d,b,v);
    numit : natural32 := 0;

  begin
    Silent_Durand_Kerner(ep,b,v,lc,roots,resid,maxit,eps,numit,fail);
    t := roots;
  end Generic_Points;

  procedure Generic_Points
                ( p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean;
                  m : out Standard_Natural_Vectors.Vector ) is

    rdp : Link_to_Poly_Sys;

  begin
    Generic_Points(p,ep,d,b,v,eps,maxit,t,fail,m,rdp);
    Clear(rdp);
  end Generic_Points;

  procedure Generic_Points
                ( p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean;
                  m : out Standard_Natural_Vectors.Vector;
                  rdp : out Link_to_Poly_Sys;
                  rad,dst : out Standard_Floating_Vectors.Vector ) is

    n : constant integer32 := b'length;
    tol : constant double_float := 0.1;
    roots : Vector(1..integer32(d)) := Roots_of_Unity(d);
    resid : Vector(1..integer32(d));
    lc : constant Complex_Number := Lead_Coefficient(p,d,b,v);
    numit,max_m : natural32;

  begin
    Silent_Durand_Kerner(ep,b,v,lc,roots,resid,maxit,eps,numit,fail);
    t := roots;
    m := Multiplicities(roots,tol);
    Cluster_Analysis(roots,tol,rad,dst);
    max_m := Max(m);
    Refine_Roots(natural32(n),max_m,p,b,v,m,t,eps,fail,rdp);
  end Generic_Points;

  procedure Generic_Points
                ( p : in Poly; ep : in Eval_Poly;
                  d : in natural32; b,v : in Vector;
                  eps : in double_float; maxit : in natural32;
                  t : out Vector; fail : out boolean;
                  m : out Standard_Natural_Vectors.Vector;
                  rdp : out Link_to_Poly_Sys ) is

    rad,dst : Standard_Floating_Vectors.Vector(1..integer32(d));

  begin
    Generic_Points(p,ep,d,b,v,eps,maxit,t,fail,m,rdp,rad,dst);
  end Generic_Points;

-- PART II : exploitation of structure

  function Random_Multihomogeneous_Directions 
               ( n : natural32; z : Partition ) return VecVec is

    res : VecVec(integer32(z'first)..integer32(z'last));

  begin
    for i in z'range loop
      declare
        v : Vector(1..integer32(n)) := (1..integer32(n) => Create(0.0));
      begin
        for j in 1..n loop
          if Is_In(z(i),j)
           then v(integer32(j)) := Random1;
          end if;
        end loop;
        res(integer32(i)) := new Vector'(v);
      end;
    end loop;
    return res;
  end Random_Multihomogeneous_Directions;

  function Random_Set_Structure_Directions
                  ( n,i : natural32 ) return VecVec is

    res : VecVec(1..integer32(Set_Structure.Number_of_Sets(i)));

  begin
    for j in res'range loop
      declare
        v : Vector(1..integer32(n)) := (1..integer32(n) => Create(0.0));
      begin
        for k in 1..n loop
          if Set_Structure.Is_In(i,natural32(j),k)
           then v(integer32(k)) := Random1;
          end if;
        end loop;
        res(j) := new Vector'(v);
      end;
    end loop;
    return res;
  end Random_Set_Structure_Directions;

  procedure Generic_Points
                ( p : in Poly; ep : in Eval_Poly;
                  z : in Partition; b : in Vector; v : in VecVec;
                  eps : in double_float; maxit : in natural32;
                  t : out VecVec; fail : out boolean ) is
  begin
    fail := false;
    for i in z'range loop
      declare
        d : constant integer32 := Degree(p,z(i));
        r : Vector(1..d);
      begin
        if d > 0 then
          Generic_Points(p,ep,natural32(d),b,v(integer32(i)).all,
                         eps,maxit,r,fail);
          if not fail
           then t(integer32(i)) := new Vector'(r);
          end if;
        end if;
      end;
      exit when fail;
    end loop;
  end Generic_Points;

  procedure Generic_Points
                ( file : in file_type; p : in Poly; ep : in Eval_Poly;
                  z : in Partition; b : in Vector; v : in VecVec;
                  eps : in double_float; maxit : in natural32;
                  t : out VecVec; fail : out boolean ) is
  begin
    fail := false;
    for i in z'range loop
      declare
        d : constant integer32 := Degree(p,z(i));
        r : Vector(1..d);
      begin
        if d = 0 then
          put(file,"There are no roots to compute for set ");
          put(file,i,1);
          put_line(file," with the special direction : ");
          put_line(file,v(integer32(i)).all);
        else
          put(file,"Computing "); put(file,d,1);
          put(file," roots for set "); put(file,i,1);
          put_line(file," with special direction :");
          put_line(file,v(integer32(i)).all);
          put_line(file,"Computing generic points"
                      & " on a special random line ...");
          Generic_Points(file,p,ep,natural32(d),b,v(integer32(i)).all,
                         eps,maxit,r,fail);
          put(file,"Calculation of generic points for set ");
          put(file,i,1); 
          if fail then
            put_line(file," failed.");
          else
            put_line(file," succeeded.");
            t(integer32(i)) := new Vector'(r);
          end if;
        end if;
      end;
      exit when fail;
    end loop;
  end Generic_Points;

--  procedure Generic_Points
--                ( p : in Poly; ep : in Eval_Poly;
--                  i : in natural32; b : in Vector; v : in VecVec;
--                  eps : in double_float; maxit : in natural32;
--                  t : out VecVec; fail : out boolean ) is
--  begin
--    null;
--  end Generic_Points;

--  procedure Generic_Points
--                ( file : in file_type; p : in Poly; ep : in Eval_Poly;
--                  i : in natural32; b : in Vector; v : in VecVec;
--                  eps : in double_float; maxit : in natural32;
--                  t : out VecVec; fail : out boolean ) is
--  begin
--    null;
--  end Generic_Points;

  procedure Cluster_Analysis
                 ( x : in Standard_Complex_Vectors.Vector;
                   tol : in double_float;
                   radius,distance : out Standard_Floating_Vectors.Vector ) is
  
    rad : double_float;

  begin
    for i in x'range loop
      radius(i) := 0.0;
      distance(i) := -1.0;
    end loop;
    for i in x'range loop
      for j in i+1..x'last loop
        if j /= i
         then rad := Standard_Complex_Numbers_Polar.Radius(x(i)-x(j));
              if rad < tol
               then if rad > radius(i)
                     then radius(i) := rad;
                    end if;
                    if rad > radius(j)
                     then radius(j) := rad;
                    end if;
               else if distance(i) < 0.0
                      or else rad < distance(i)
                     then distance(i) := rad;
                    end if;
                    if distance(j) < 0.0
                      or else rad < distance(j)
                     then distance(j) := rad;
                    end if;
              end if;
        end if;
      end loop;
    end loop;
  end Cluster_Analysis;

-- PART III : sampling and refining along moving lines

  procedure Silent_Refiner
               ( p : in Eval_Poly_Sys; b,v : in Vector; 
                 t : in out Vector; ft,dt : out Vector;
                 eps : in double_float; maxit : in natural32 ) is

  begin
    for i in t'range loop
      for k in 1..maxit loop
        Newton(p,b,v,t(i),ft(i),dt(i));
        exit when (AbsVal(ft(i)) < eps) or (AbsVal(dt(i)) < eps);
      end loop;   
    end loop;
  end Silent_Refiner;

  procedure Silent_Refiner
               ( p : in Eval_Poly_Sys; b,v : in Vector;
                 m : in Standard_Natural_Vectors.Vector;
                 t : in out Vector; ft,dt : out Vector;
                 eps : in double_float; maxit : in natural32 ) is

  begin
    for i in t'range loop
      for k in 1..maxit loop
        Modified_Newton(p,b,v,m(i),t(i),ft(i),dt(i));
        exit when (AbsVal(ft(i)) < eps) or (AbsVal(dt(i)) < eps);
      end loop;   
    end loop;
  end Silent_Refiner;

  procedure Reporting_Refiner
               ( file : in file_type;
                 p : in Eval_Poly_Sys; b,v : in Vector;
                 t : in out Vector; ft,dt : out Vector;
                 eps : in double_float; maxit : in natural32 ) is

    fail : boolean;
    aft,adt : double_float;
    nb : natural32 := maxit;

  begin
    for i in t'range loop
     -- put(file,"Refined root "); put(file,i,1); put(file," : ");
     -- put(file,t(i)); new_line(file);
      fail := true;
      for k in 1..maxit loop
        Newton(p,b,v,t(i),ft(i),dt(i));
        aft := AbsVal(ft(i));
        adt := AbsVal(dt(i));
        if (adt < eps) or (aft < eps)
         then nb := k; fail := false; exit;
        end if;
      end loop;
      put(file,"Refined root "); put(file,i,1); put(file," : ");
      put(file,t(i)); new_line(file);
      put(file,"  err : "); put(file,adt,3);
      put(file,"  res : "); put(file,aft,3);
      put(file,"  #it : "); put(file,nb,1);
      if fail
       then put_line(file,"  failure.");
       else put_line(file,"  success.");
      end if;
    end loop;
  end Reporting_Refiner;

  procedure Reporting_Refiner
               ( file : in file_type;
                 p : in Eval_Poly_Sys; b,v : in Vector;
                 m : in Standard_Natural_Vectors.Vector;
                 t : in out Vector; ft,dt : out Vector;
                 eps : in double_float; maxit : in natural32 ) is

    fail : boolean;
    aft,adt : double_float;
    nb : natural32 := maxit;

  begin
    for i in t'range loop
     -- put(file,"Refined root "); put(file,i,1); put(file," : ");
     -- put(file,t(i)); new_line(file);
      fail := true;
      for k in 1..maxit loop
        Modified_Newton(p,b,v,m(i),t(i),ft(i),dt(i));
        aft := AbsVal(ft(i));
        adt := AbsVal(dt(i));
        if (adt < eps) --or (aft < eps)
         then nb := k; fail := false; exit;
        end if;
      end loop;
      put(file,"Refined root "); put(file,i,1); put(file," : ");
      put(file,t(i)); new_line(file);
      put(file,"  err : "); put(file,adt,3);
      put(file,"  res : "); put(file,aft,3);
      put(file,"  #it : "); put(file,nb,1);
      if fail
       then put_line(file,"  failure.");
       else put_line(file,"  success.");
      end if;
    end loop;
  end Reporting_Refiner;

  procedure Silent_Hypersurface_Sampler
               ( p : in Eval_Poly_Sys; b0,v0,b1,v1 : in Vector;
                 t : in out Vector ) is

    nbstp : natural32 := 0;
    fail : boolean;

  begin
    for i in t'range loop
      Silent_Path_Tracker(p,b0,v0,b1,v1,t(i),nbstp,fail);
    end loop;
  end Silent_Hypersurface_Sampler;

  procedure Reporting_Hypersurface_Sampler
               ( file : in file_type;
                 p : in Eval_Poly_Sys; b0,v0,b1,v1 : in Vector;
                 output : in boolean; t : in out Vector ) is

    nbstp : natural32 := 0;
    fail : boolean;

  begin
    for i in t'range loop
      put(file,"Path "); put(file,i,1);
      if output
       then put_line(file," :");
      end if;
      Reporting_Path_Tracker(file,p,b0,v0,b1,v1,output,t(i),nbstp,fail);
      if fail
       then put_line(file," failed to reach the end.");
       else put(file," reached end in "); put(file,nbstp,1);
            put_line(file," steps.");
      end if;
    end loop;
  end Reporting_Hypersurface_Sampler;

end Hypersurface_Samplers;
