with text_io;                             use text_io;
with Communications_with_User;            use Communications_with_User;
with Standard_Natural_Numbers;            use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;         use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;            use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;         use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;           use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;        use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;            use Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;         use Standard_Complex_Numbers_io;
with Standard_Natural_Vectors;
with Standard_Natural_Vectors_io;         use Standard_Natural_Vectors_io;
with Standard_Natural_VecVecs;
with Standard_Complex_Vectors;
with Standard_Complex_Vectors_io;         use Standard_Complex_Vectors_io;
with Standard_Complex_Norms_Equals;       use Standard_Complex_Norms_Equals;
with Standard_Random_Numbers;
with Standard_Random_Vectors;             use Standard_Random_Vectors;
with Standard_Speelpenning_Products;
with Double_Double_Numbers;               use Double_Double_Numbers;
with Double_Double_Numbers_io;            use Double_Double_Numbers_io;
with DoblDobl_Complex_Numbers;            use DoblDobl_Complex_Numbers;
with DoblDobl_Complex_Numbers_io;         use DoblDobl_Complex_Numbers_io;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_Vectors_io;         use DoblDobl_Complex_Vectors_io;
with DoblDobl_Complex_Vector_Norms;       use DoblDobl_Complex_Vector_Norms;
with DoblDobl_Random_Vectors;
with DoblDobl_Speelpenning_Products;
with Quad_Double_Numbers;                 use Quad_Double_Numbers;
with Quad_Double_Numbers_io;              use Quad_Double_Numbers_io;
with QuadDobl_Complex_Numbers;            use QuadDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers_io;         use QuadDobl_Complex_Numbers_io;
with QuadDobl_Complex_Vectors;
with QuadDobl_Complex_Vectors_io;         use QuadDobl_Complex_Vectors_io;
with QuadDobl_Complex_Vector_Norms;       use QuadDobl_Complex_Vector_Norms;
with QuadDobl_Random_Vectors;
with QuadDobl_Speelpenning_Products;
with Standard_Monomial_Evaluations;
with DoblDobl_Monomial_Evaluations;
with QuadDobl_Monomial_Evaluations;
with Symbol_Table;
with Standard_Complex_Polynomials;
with Standard_Complex_Poly_Functions;
with Standard_Complex_Polynomials_io;     use Standard_Complex_Polynomials_io;
with DoblDobl_Complex_Polynomials;
with DoblDobl_Complex_Poly_Functions;
with QuadDobl_Complex_Polynomials;
with QuadDobl_Complex_Poly_Functions;
with Coefficient_Supported_Polynomials;   use Coefficient_Supported_Polynomials;
with Standard_Gradient_Evaluations;
with DoblDobl_Gradient_Evaluations;
with QuadDobl_Gradient_Evaluations;

procedure ts_speel is

-- DESCRIPTION :
--   Elaboration of the example of Speelpenning to evaluate a product
--   of n variables along with all its derivatives.

  procedure Run_Standard_Speelpenning_Example ( n : in integer32 ) is

  -- DESCRIPTION :
  --   Compares the evaluation and differentiation of a product of n
  --   variables with and without algorithm differentiation techniques,
  --   using standard complex arithmetic.

    x : constant Standard_Complex_Vectors.Vector(1..n)
      := Standard_Random_Vectors.Random_Vector(1,n);
    y,z : Standard_Complex_Vectors.Vector(0..n);
    sum,d : double_float;

    use Standard_Speelpenning_Products;

  begin
    put_line("Speelpenning's example at a random vector :");
    y := Straight_Speel(x); put_line(y);
    put_line("Running Speelpenning's example in reverse mode :");
    z := Reverse_Speel(x); put_line(z);
    sum := 0.0;
    for i in 0..n loop
      d := AbsVal(y(i) - z(i));
      sum := sum + d;
    end loop;
    put("Sum of differences : "); put(sum); new_line;
  end Run_Standard_Speelpenning_Example;

  procedure Run_DoblDobl_Speelpenning_Example ( n : in integer32 ) is

  -- DESCRIPTION :
  --   Compares the evaluation and differentiation of a product of n
  --   variables with and without algorithm differentiation techniques,
  --   using double double complex arithmetic.

    x : constant DoblDobl_Complex_Vectors.Vector(1..n)
      := DoblDobl_Random_Vectors.Random_Vector(1,n);
    y,z : DoblDobl_Complex_Vectors.Vector(0..n);
    sum,d : double_double;

    use DoblDobl_Speelpenning_Products;

  begin
    put_line("Speelpenning's example at a random vector :");
    y := Straight_Speel(x); put_line(y);
    put_line("Running Speelpenning's example in reverse mode :");
    z := Reverse_Speel(x); put_line(z);
    sum := Create(integer(0));
    for i in 0..n loop
      d := AbsVal(y(i) - z(i));
      sum := sum + d;
    end loop;
    put("Sum of differences : "); put(sum); new_line;
  end Run_DoblDobl_Speelpenning_Example;

  procedure Run_QuadDobl_Speelpenning_Example ( n : in integer32 ) is

  -- DESCRIPTION :
  --   Compares the evaluation and differentiation of a product of n
  --   variables with and without algorithm differentiation techniques,
  --   using double double complex arithmetic.

    x : constant QuadDobl_Complex_Vectors.Vector(1..n)
      := QuadDobl_Random_Vectors.Random_Vector(1,n);
    y,z : QuadDobl_Complex_Vectors.Vector(0..n);
    sum,d : quad_double;

    use QuadDobl_Speelpenning_Products;

  begin
    put_line("Speelpenning's example at a random vector :");
    y := Straight_Speel(x); put_line(y);
    put_line("Running Speelpenning's example in reverse mode :");
    z := Reverse_Speel(x); put_line(z);
    sum := Create(integer(0));
    for i in 0..n loop
      d := AbsVal(y(i) - z(i));
      sum := sum + d;
    end loop;
    put("Sum of differences : "); put(sum); new_line;
  end Run_QuadDobl_Speelpenning_Example;

  procedure Run_Speelpenning is

  -- DESCRIPTION :
  --   Runs of basic example of Speelpenning.

    n : integer32 := 0;
    ans : character;

  begin
    new_line;
    put_line("Computing the example of Speelpenning ...");
    put("give the n, the number of variables : "); get(n);
    put("standard, double double, or quad double arithmetic ? (s/d/q) ");
    Ask_Alternative(ans,"sdq");
    case ans is
      when 's' => Run_Standard_Speelpenning_Example(n);
      when 'd' => Run_DoblDobl_Speelpenning_Example(n);
      when 'q' => Run_QuadDobl_Speelpenning_Example(n);
      when others => null;
    end case;
  end Run_Speelpenning;

  function Extract_Exponent_Vector
             ( n : integer32; p : Standard_Complex_Polynomials.Poly )
             return Standard_Natural_Vectors.Vector is

    use Standard_Complex_Polynomials;
    res : Standard_Natural_Vectors.Vector(1..n);

    procedure Visit_Term ( t : in Term; c : out boolean ) is
    begin
      for i in 1..n loop
        res(i) := t.dg(i);
      end loop;
      c := false;
    end Visit_Term;
    procedure Visit is new Visiting_Iterator(Visit_Term);

  begin
    Visit(p);
    return res;
  end Extract_Exponent_Vector;

  procedure Initialize_Symbol_Table ( n : in natural32 ) is

  -- DESCRIPTION :
  --   To initialize the symbol table properly with n symbols,
  --   the user is prompted to enter a product of all variables.

    p : Standard_Complex_Polynomials.Poly;

  begin
    Symbol_Table.Init(n);
    put("To initialize the symbol table with "); put(n,1);
    put_line(" variables,");
    put("give complete product of all variables : "); get(p);
  end Initialize_Symbol_Table;

  procedure Run_Standard_Speelpenning_Monomial
              ( n : in integer32; e : in Standard_Natural_Vectors.Vector ) is

    x : constant Standard_Complex_Vectors.Vector(1..n)
      := Standard_Random_Vectors.Random_Vector(1,n);
    y,z : Standard_Complex_Vectors.Vector(0..n);
    sum,d : double_float;

    use Standard_Speelpenning_Products;

  begin
    put_line("Speelpenning's example at a random vector :");
    y := Straight_Speel(e,x); put_line(y);
    put_line("Running Speelspenning's example in reverse mode :");
    z := Reverse_Speel(e,x); put_line(z);
    sum := 0.0;
    for i in 0..n loop
      d := AbsVal(y(i) - z(i));
      sum := sum + d;
    end loop;
    put("Sum of differences : "); put(sum); new_line;
  end Run_Standard_Speelpenning_Monomial;

  procedure Run_DoblDobl_Speelpenning_Monomial
              ( n : in integer32; e : in Standard_Natural_Vectors.Vector ) is

    x : constant DoblDobl_Complex_Vectors.Vector(1..n)
      := DoblDobl_Random_Vectors.Random_Vector(1,n);
    y,z : DoblDobl_Complex_Vectors.Vector(0..n);
    sum,d : double_double;

    use DoblDobl_Speelpenning_Products;

  begin
    put_line("Speelpenning's example at a random vector :");
    y := Straight_Speel(e,x); put_line(y);
    put_line("Running Speelspenning's example in reverse mode :");
    z := Reverse_Speel(e,x); put_line(z);
    sum := Create(integer(0));
    for i in 0..n loop
      d := AbsVal(y(i) - z(i));
      sum := sum + d;
    end loop;
    put("Sum of differences : "); put(sum); new_line;
  end Run_DoblDobl_Speelpenning_Monomial;

  procedure Run_QuadDobl_Speelpenning_Monomial
              ( n : in integer32; e : in Standard_Natural_Vectors.Vector ) is

    x : constant QuadDobl_Complex_Vectors.Vector(1..n)
      := QuadDobl_Random_Vectors.Random_Vector(1,n);
    y,z : QuadDobl_Complex_Vectors.Vector(0..n);
    sum,d : quad_double;

    use QuadDobl_Speelpenning_Products;

  begin
    put_line("Speelpenning's example at a random vector :");
    y := Straight_Speel(e,x); put_line(y);
    put_line("Running Speelspenning's example in reverse mode :");
    z := Reverse_Speel(e,x); put_line(z);
    sum := Create(integer(0));
    for i in 0..n loop
      d := AbsVal(y(i) - z(i));
      sum := sum + d;
    end loop;
    put("Sum of differences : "); put(sum); new_line;
  end Run_QuadDobl_Speelpenning_Monomial;

  procedure Monomial_Evaluation is

  -- DESCRIPTION :
  --   Prompts the user for a number of variables and a monomial.

    n : integer32 := 0;
    p : Standard_Complex_Polynomials.Poly;
    ans : character;

  begin
    new_line;
    put("give the n, the number of variables : "); get(n);
    Initialize_Symbol_Table(natural32(n));
    put("-> give a monomial : "); get(p);
    put("your monomial : "); put(p); new_line;
    declare
      e : constant Standard_Natural_Vectors.Vector(1..n)
        := Extract_Exponent_Vector(n,p);
    begin
      put("The exponent vector is"); put(e); put_line(".");
      put("standard, double double, or quad double arithmetic ? (s/d/q) ");
      Ask_Alternative(ans,"sdq");
      case ans is
        when 's' => Run_Standard_Speelpenning_Monomial(n,e);
        when 'd' => Run_DoblDobl_Speelpenning_Monomial(n,e);
        when 'q' => Run_QuadDobl_Speelpenning_Monomial(n,e);
        when others => null;
      end case;
    end;
  end Monomial_Evaluation;

  function Random_Exponent
             ( n,d : integer32 ) return Standard_Natural_Vectors.Vector is

  -- DESCRIPTION :
  --   Returns an exponent vector in n variables
  --   with entries ranging between 0 and d.

    res : Standard_Natural_Vectors.Vector(1..n);

  begin
    for i in 1..n loop
      res(i) := natural32(Standard_Random_Numbers.Random(0,d));
    end loop;
    return res;
  end Random_Exponent;

  procedure Random_Monomial_Evaluation is

  -- DESCRIPTION :
  --   Generates a random exponent vector of zeroes and ones
  --   and applies the Speelpenning product evaluation scheme.

    n : integer32 := 0;
    ans : character;

  begin
    new_line;
    put("give the n, the number of variables : "); get(n);
    declare
      e : constant Standard_Natural_Vectors.Vector(1..n)
        := Random_Exponent(n,1);
    begin
      put("The exponent vector is"); put(e); put_line(".");
      put("standard, double double, or quad double arithmetic ? (s/d/q) ");
      Ask_Alternative(ans,"sdq");
      case ans is
        when 's' => Run_Standard_Speelpenning_Monomial(n,e);
        when 'd' => Run_DoblDobl_Speelpenning_Monomial(n,e);
        when 'q' => Run_QuadDobl_Speelpenning_Monomial(n,e);
        when others => null;
      end case;
    end;
  end Random_Monomial_Evaluation;

  function Random_Exponents
             ( n,d,m : integer32 ) return Standard_Natural_VecVecs.VecVec is

  -- DESCRIPTION :
  --   Returns m random exponents in n variables with entries
  --   ranging between 0 and d.

    res : Standard_Natural_VecVecs.VecVec(1..m);
    exp : Standard_Natural_Vectors.Vector(1..n);

  begin
    for i in 1..m loop
      exp := Random_Exponent(n,d);
      res(i) := new Standard_Natural_Vectors.Vector'(exp);
    end loop;
    return res;
  end Random_Exponents;

  procedure Write_Difference
              ( a,b : in Standard_Complex_Vectors.Vector;
                sum : in Standard_Complex_Numbers.Complex_Number ) is

  -- DESCRIPTION :
  --   Writes the difference between the two vectors a and b.
  --   The variable sum contains the sum of the evaluated monomials
  --   defined by the exponents.

    use Standard_Complex_Vectors;
    c : constant Vector(a'range) := a - b;
    d : constant double_float := Max_Norm(c);
    a_sum : constant Standard_Complex_Numbers.Complex_Number
          := Standard_Complex_Vectors.Sum(a);
    b_sum : constant Standard_Complex_Numbers.Complex_Number
          := Standard_Complex_Vectors.Sum(b);

  begin
    put_line("the first vector : "); put_line(a);
    put_line("the second vector : "); put_line(b);
    put("Difference between vectors : "); put(d,3); new_line;
    put("   The 1st sum : "); put(a_sum); new_line;
    put("   The 2nd sum : "); put(b_sum); new_line;
    put("Polynomial sum : "); put(sum); new_line;
  end Write_Difference;

  procedure Write_Difference
              ( a,b : in DoblDobl_Complex_Vectors.Vector;
                sum : in DoblDobl_Complex_Numbers.Complex_Number ) is

  -- DESCRIPTION :
  --   Writes the difference between the two vectors a and b.
  --   The variable sum contains the sum of the evaluated monomials
  --   defined by the exponents.

    use DoblDobl_Complex_Vectors;
    c : constant Vector(a'range) := a - b;
    d : constant double_double := Max_Norm(c);
    a_sum : constant DoblDobl_Complex_Numbers.Complex_Number
          := DoblDobl_Complex_Vectors.Sum(a);
    b_sum : constant DoblDobl_Complex_Numbers.Complex_Number
          := DoblDobl_Complex_Vectors.Sum(b);

  begin
    put_line("the first vector : "); put_line(a);
    put_line("the second vector : "); put_line(b);
    put("Difference between vectors : "); put(d,3); new_line;
    put("   The 1st sum : "); put(a_sum); new_line;
    put("   The 2nd sum : "); put(b_sum); new_line;
    put("Polynomial sum : "); put(sum); new_line;
  end Write_Difference;

  procedure Write_Difference
              ( a,b : in QuadDobl_Complex_Vectors.Vector;
                sum : in QuadDobl_Complex_Numbers.Complex_Number ) is

  -- DESCRIPTION :
  --   Writes the difference between the two vectors a and b.
  --   The variable sum contains the sum of the evaluated monomials
  --   defined by the exponents.

    use QuadDobl_Complex_Vectors;
    c : constant Vector(a'range) := a - b;
    d : constant quad_double := Max_Norm(c);
    a_sum : constant QuadDobl_Complex_Numbers.Complex_Number
          := QuadDobl_Complex_Vectors.Sum(a);
    b_sum : constant QuadDobl_Complex_Numbers.Complex_Number
          := QuadDobl_Complex_Vectors.Sum(b);

  begin
    put_line("the first vector : "); put_line(a);
    put_line("the second vector : "); put_line(b);
    put("Difference between vectors : "); put(d,3); new_line;
    put("   The 1st sum : "); put(a_sum); new_line;
    put("   The 2nd sum : "); put(b_sum); new_line;
    put("Polynomial sum : "); put(sum); new_line;
  end Write_Difference;

  procedure Standard_Evaluate_Monomials
              ( n,m : in integer32;
                e : in Standard_Natural_VecVecs.VecVec ) is

  -- DESCRIPTION :
  --   Evaluates m random monomials in n variables and of degrees in e
  --   using standard arithmetic, once with tables of powers,
  --   and once without, comparing the results, also with the sum
  --   of the monomials defined by the exponents in e.

    use Standard_Monomial_Evaluations;
    x : constant Standard_Complex_Vectors.Vector(1..n)
      := Standard_Random_Vectors.Random_Vector(1,n);
    y,z : Standard_Complex_Vectors.Vector(1..m);
    p : Standard_Complex_Polynomials.Poly := Create_Standard_Polynomial(e);
    w : Standard_Complex_Numbers.Complex_Number;

  begin
    y := Eval(e,x);
    z := Eval_with_Power_Table(e,x);
    w := Standard_Complex_Poly_Functions.Eval(p,x);
    Write_Difference(y,z,w);
    Standard_Complex_Polynomials.Clear(p);
  end Standard_Evaluate_Monomials;

  procedure DoblDobl_Evaluate_Monomials
              ( n,m : in integer32;
                e : in Standard_Natural_VecVecs.VecVec ) is

  -- DESCRIPTION :
  --   Evaluates m random monomials in n variables and of degrees in e
  --   using double double arithmetic, once with tables of powers,
  --   and once without, comparing the results, also with the sum
  --   of the monomials defined by the exponents in e.

    use DoblDobl_Monomial_Evaluations;
    x : constant DoblDobl_Complex_Vectors.Vector(1..n)
      := DoblDobl_Random_Vectors.Random_Vector(1,n);
    y,z : DoblDobl_Complex_Vectors.Vector(1..m);
    p : DoblDobl_Complex_Polynomials.Poly := Create_DoblDobl_Polynomial(e);
    w : DoblDobl_Complex_Numbers.Complex_Number;

  begin
    y := Eval(e,x);
    z := Eval_with_Power_Table(e,x);
    w := DoblDobl_Complex_Poly_Functions.Eval(p,x);
    Write_Difference(y,z,w);
    DoblDobl_Complex_Polynomials.Clear(p);
  end DoblDobl_Evaluate_Monomials;

  procedure QuadDobl_Evaluate_Monomials
              ( n,m : in integer32;
                e : in Standard_Natural_VecVecs.VecVec ) is

  -- DESCRIPTION :
  --   Evaluates m random monomials in n variables and of degrees in e
  --   using quad double arithmetic, once with tables of powers,
  --   and once without, comparing the results, also with the sum
  --   of the monomials defined by the exponents in e.

    use QuadDobl_Monomial_Evaluations;
    x : constant QuadDobl_Complex_Vectors.Vector(1..n)
      := QuadDobl_Random_Vectors.Random_Vector(1,n);
    y,z : QuadDobl_Complex_Vectors.Vector(1..m);
    p : QuadDobl_Complex_Polynomials.Poly := Create_QuadDobl_Polynomial(e);
    w : QuadDobl_Complex_Numbers.Complex_Number;

  begin
    y := Eval(e,x);
    z := Eval_with_Power_Table(e,x);
    w := QuadDobl_Complex_Poly_Functions.Eval(p,x);
    Write_Difference(y,z,w);
    QuadDobl_Complex_Polynomials.Clear(p);
  end QuadDobl_Evaluate_Monomials;

  procedure Evaluate_Monomials is

  -- DESCRIPTION :
  --   Interactive test for the development of the evaluation of
  --   monomials at some random vectors, with and without power table.

    n,d,m : integer32 := 0;

  begin
    new_line;
    put_line("Reading parameters for a random exponent sequence ...");
    put("  give the number of variables, n = "); get(n);
    put("  give the largest degree, d = "); get(d);
    put("  give number of monomials, m = "); get(m);
    declare
      e : Standard_Natural_VecVecs.VecVec(1..m) := Random_Exponents(n,d,m);
      ans : character;
    begin
      put_line("The exponents : ");
      for i in 1..m loop
        put(e(i).all); new_line;
      end loop;
      put("The largest degrees : ");
      put(Standard_Monomial_Evaluations.Largest_Degrees(n,e)); new_line;
      put("standard, double double, or quad double arithmetic ? (s/d/q) ");
      Ask_Alternative(ans,"sdq");
      case ans is
        when 's' => Standard_Evaluate_Monomials(n,m,e);
        when 'd' => DoblDobl_Evaluate_Monomials(n,m,e);
        when 'q' => QuadDobl_Evaluate_Monomials(n,m,e);
        when others => null;
      end case;
      Standard_Natural_VecVecs.Clear(e);
    end;
  end Evaluate_Monomials;

  procedure Check_Standard_Evaluated_Gradient
               ( e : in Standard_Natural_VecVecs.VecVec;
                 c,x,z : in Standard_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   The vector z contains the evaluated monomials defined by e at x.

    p : Standard_Complex_Polynomials.Poly
      := Create_Standard_Polynomial(c,e);
    y : Standard_Complex_Numbers.Complex_Number
      := Standard_Complex_Poly_Functions.Eval(p,x);
    diff : Standard_Complex_Numbers.Complex_Number;
    diffnorm : double_float;

  begin
    put("y : "); put(y); new_line;
    put("z : "); put(z(0));
    diff := y - z(0); diffnorm := AbsVal(diff);
    put("  d : "); put(diffnorm,3); new_line;
    for i in x'range loop
      declare
        q : Standard_Complex_Polynomials.Poly
          := Standard_Complex_Polynomials.Diff(p,i);
      begin
        y := Standard_Complex_Poly_Functions.Eval(q,x);
        put("y'("); put(i,1); put(") : "); put(y); new_line;
        put("z'("); put(i,1); put(") : "); put(z(i));
        diff := y - z(i); diffnorm := AbsVal(diff);
        put("  d : "); put(diffnorm,3); new_line;
        Standard_Complex_Polynomials.Clear(q);
      end;
    end loop;
    Standard_Complex_Polynomials.Clear(p);
  end Check_Standard_Evaluated_Gradient;

  procedure Check_DoblDobl_Evaluated_Gradient
               ( e : in Standard_Natural_VecVecs.VecVec;
                 c,x,z : in DoblDobl_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   The vector z contains the evaluated monomials defined by e at x.

    p : DoblDobl_Complex_Polynomials.Poly
      := Create_DoblDobl_Polynomial(c,e);
    y : DoblDobl_Complex_Numbers.Complex_Number
      := DoblDobl_Complex_Poly_Functions.Eval(p,x);
    diff : DoblDobl_Complex_Numbers.Complex_Number;
    diffnorm : double_double;

  begin
    put("y : "); put(y); new_line;
    put("z : "); put(z(0));
    diff := y - z(0); diffnorm := AbsVal(diff);
    put("  d : "); put(diffnorm,3); new_line;
    for i in x'range loop
      declare
        q : DoblDobl_Complex_Polynomials.Poly
          := DoblDobl_Complex_Polynomials.Diff(p,i);
      begin
        y := DoblDobl_Complex_Poly_Functions.Eval(q,x);
        put("y'("); put(i,1); put(") : "); put(y); new_line;
        put("z'("); put(i,1); put(") : "); put(z(i));
        diff := y - z(i); diffnorm := AbsVal(diff);
        put("  d : "); put(diffnorm,3); new_line;
        DoblDobl_Complex_Polynomials.Clear(q);
      end;
    end loop;
    DoblDobl_Complex_Polynomials.Clear(p);
  end Check_DoblDobl_Evaluated_Gradient;

  procedure Check_QuadDobl_Evaluated_Gradient
               ( e : in Standard_Natural_VecVecs.VecVec;
                 c,x,z : in QuadDobl_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   The vector z contains the evaluated monomials defined by e at x.

    p : QuadDobl_Complex_Polynomials.Poly
      := Create_QuadDobl_Polynomial(c,e);
    y : QuadDobl_Complex_Numbers.Complex_Number
      := QuadDobl_Complex_Poly_Functions.Eval(p,x);
    diff : QuadDobl_Complex_Numbers.Complex_Number;
    diffnorm : quad_double;

  begin
    put("y : "); put(y); new_line;
    put("z : "); put(z(0));
    diff := y - z(0); diffnorm := AbsVal(diff);
    put("  d : "); put(diffnorm,3); new_line;
    for i in x'range loop
      declare
        q : QuadDobl_Complex_Polynomials.Poly
          := QuadDobl_Complex_Polynomials.Diff(p,i);
      begin
        y := QuadDobl_Complex_Poly_Functions.Eval(q,x);
        put("y'("); put(i,1); put(") : "); put(y); new_line;
        put("z'("); put(i,1); put(") : "); put(z(i));
        diff := y - z(i); diffnorm := AbsVal(diff);
        put("  d : "); put(diffnorm,3); new_line;
        QuadDobl_Complex_Polynomials.Clear(q);
      end;
    end loop;
    QuadDobl_Complex_Polynomials.Clear(p);
  end Check_QuadDobl_Evaluated_Gradient;

  procedure Check_Standard_Evaluated_Gradient
               ( e : in Standard_Natural_VecVecs.VecVec;
                 x,z : in Standard_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   The vector z contains the evaluated monomials defined by e at x.

    p : Standard_Complex_Polynomials.Poly := Create_Standard_Polynomial(e);
    y : Standard_Complex_Numbers.Complex_Number
      := Standard_Complex_Poly_Functions.Eval(p,x);
    diff : Standard_Complex_Numbers.Complex_Number;
    diffnorm : double_float;

  begin
    put("y : "); put(y); new_line;
    put("z : "); put(z(0));
    diff := y - z(0); diffnorm := AbsVal(diff);
    put("  d : "); put(diffnorm,3); new_line;
    for i in x'range loop
      declare
        q : Standard_Complex_Polynomials.Poly
          := Standard_Complex_Polynomials.Diff(p,i);
      begin
        y := Standard_Complex_Poly_Functions.Eval(q,x);
        put("y'("); put(i,1); put(") : "); put(y); new_line;
        put("z'("); put(i,1); put(") : "); put(z(i));
        diff := y - z(i); diffnorm := AbsVal(diff);
        put("  d : "); put(diffnorm,3); new_line;
        Standard_Complex_Polynomials.Clear(q);
      end;
    end loop;
    Standard_Complex_Polynomials.Clear(p);
  end Check_Standard_Evaluated_Gradient;

  procedure Check_DoblDobl_Evaluated_Gradient
               ( e : in Standard_Natural_VecVecs.VecVec;
                 x,z : in DoblDobl_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   The vector z contains the evaluated monomials defined by e at x.

    p : DoblDobl_Complex_Polynomials.Poly := Create_DoblDobl_Polynomial(e);
    y : DoblDobl_Complex_Numbers.Complex_Number
      := DoblDobl_Complex_Poly_Functions.Eval(p,x);
    diff : DoblDobl_Complex_Numbers.Complex_Number;
    diffnorm : double_double;

  begin
    put("y : "); put(y); new_line;
    put("z : "); put(z(0));
    diff := y - z(0); diffnorm := AbsVal(diff);
    put("  d : "); put(diffnorm,3); new_line;
    for i in x'range loop
      declare
        q : DoblDobl_Complex_Polynomials.Poly
          := DoblDobl_Complex_Polynomials.Diff(p,i);
      begin
        y := DoblDobl_Complex_Poly_Functions.Eval(q,x);
        put("y'("); put(i,1); put(") : "); put(y); new_line;
        put("z'("); put(i,1); put(") : "); put(z(i));
        diff := y - z(i); diffnorm := AbsVal(diff);
        put("  d : "); put(diffnorm,3); new_line;
        DoblDobl_Complex_Polynomials.Clear(q);
      end;
    end loop;
    DoblDobl_Complex_Polynomials.Clear(p);
  end Check_DoblDobl_Evaluated_Gradient;

  procedure Check_QuadDobl_Evaluated_Gradient
               ( e : in Standard_Natural_VecVecs.VecVec;
                 x,z : in QuadDobl_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   The vector z contains the evaluated monomials defined by e at x.

    p : QuadDobl_Complex_Polynomials.Poly := Create_QuadDobl_Polynomial(e);
    y : QuadDobl_Complex_Numbers.Complex_Number
      := QuadDobl_Complex_Poly_Functions.Eval(p,x);
    diff : QuadDobl_Complex_Numbers.Complex_Number;
    diffnorm : quad_double;

  begin
    put("y : "); put(y); new_line;
    put("z : "); put(z(0));
    diff := y - z(0); diffnorm := AbsVal(diff);
    put("  d : "); put(diffnorm,3); new_line;
    for i in x'range loop
      declare
        q : QuadDobl_Complex_Polynomials.Poly
          := QuadDobl_Complex_Polynomials.Diff(p,i);
      begin
        y := QuadDobl_Complex_Poly_Functions.Eval(q,x);
        put("y'("); put(i,1); put(") : "); put(y); new_line;
        put("z'("); put(i,1); put(") : "); put(z(i));
        diff := y - z(i); diffnorm := AbsVal(diff);
        put("  d : "); put(diffnorm,3); new_line;
        QuadDobl_Complex_Polynomials.Clear(q);
      end;
    end loop;
    QuadDobl_Complex_Polynomials.Clear(p);
  end Check_QuadDobl_Evaluated_Gradient;

  procedure Standard_Evaluate_Gradient ( n,d,m : in integer32 ) is

  -- DESCRIPTION :
  --   Randomly generates a sequence of m monomials in n variables
  --   of degrees at most d, using standard arithmetic.

    e : Standard_Natural_VecVecs.VecVec(1..m) := Random_Exponents(n,d,m);
    c : constant Standard_Complex_Vectors.Vector(1..m) := Random_Vector(1,m);
    f,b : Standard_Natural_VecVecs.VecVec(1..m);
    x : constant Standard_Complex_Vectors.Vector(1..n) := Random_Vector(1,n);
    z : Standard_Complex_Vectors.Vector(0..n);

  begin
    Standard_Gradient_Evaluations.Split_Common_Factors(e,f,b);
    put_line("The exponents, with splitted factors : ");
    for i in 1..m loop
      put(e(i).all);
      put(" = "); put(f(i).all);
      put(" + "); put(b(i).all); new_line;
    end loop;
    z := Standard_Gradient_Evaluations.Gradient_Sum_of_Monomials(f,b,x);
    Check_Standard_Evaluated_Gradient(e,x,z);
    z := Standard_Gradient_Evaluations.Gradient_of_Polynomial(f,b,c,x);
    Check_Standard_Evaluated_Gradient(e,c,x,z);
    Standard_Natural_VecVecs.Clear(e);
  end Standard_Evaluate_Gradient;

  procedure DoblDobl_Evaluate_Gradient ( n,d,m : in integer32 ) is

  -- DESCRIPTION :
  --   Randomly generates a sequence of m monomials in n variables
  --   of degrees at most d, using double double arithmetic.

    e : Standard_Natural_VecVecs.VecVec(1..m) := Random_Exponents(n,d,m);
    c : constant DoblDobl_Complex_Vectors.Vector(1..m)
      := DoblDobl_Random_Vectors.Random_Vector(1,m);
    f,b : Standard_Natural_VecVecs.VecVec(1..m);
    x : constant DoblDobl_Complex_Vectors.Vector(1..n)
      := DoblDobl_Random_Vectors.Random_Vector(1,n);
    z : DoblDobl_Complex_Vectors.Vector(0..n);

  begin
    DoblDobl_Gradient_Evaluations.Split_Common_Factors(e,f,b);
    put_line("The exponents, with splitted factors : ");
    for i in 1..m loop
      put(e(i).all);
      put(" = "); put(f(i).all);
      put(" + "); put(b(i).all); new_line;
    end loop;
    z := DoblDobl_Gradient_Evaluations.Gradient_Sum_of_Monomials(f,b,x);
    Check_DoblDobl_Evaluated_Gradient(e,x,z);
    z := DoblDobl_Gradient_Evaluations.Gradient_of_Polynomial(f,b,c,x);
    Check_DoblDobl_Evaluated_Gradient(e,c,x,z);
    Standard_Natural_VecVecs.Clear(e);
  end DoblDobl_Evaluate_Gradient;

  procedure QuadDobl_Evaluate_Gradient ( n,d,m : in integer32 ) is

  -- DESCRIPTION :
  --   Randomly generates a sequence of m monomials in n variables
  --   of degrees at most d, using quad double arithmetic.

    e : Standard_Natural_VecVecs.VecVec(1..m) := Random_Exponents(n,d,m);
    c : constant QuadDobl_Complex_Vectors.Vector(1..m)
      := QuadDobl_Random_Vectors.Random_Vector(1,m);
    f,b : Standard_Natural_VecVecs.VecVec(1..m);
    x : constant QuadDobl_Complex_Vectors.Vector(1..n)
      := QuadDobl_Random_Vectors.Random_Vector(1,n);
    z : QuadDobl_Complex_Vectors.Vector(0..n);

  begin
    QuadDobl_Gradient_Evaluations.Split_Common_Factors(e,f,b);
    put_line("The exponents, with splitted factors : ");
    for i in 1..m loop
      put(e(i).all);
      put(" = "); put(f(i).all);
      put(" + "); put(b(i).all); new_line;
    end loop;
    z := QuadDobl_Gradient_Evaluations.Gradient_Sum_of_Monomials(f,b,x);
    Check_QuadDobl_Evaluated_Gradient(e,x,z);
    z := QuadDobl_Gradient_Evaluations.Gradient_of_Polynomial(f,b,c,x);
    Check_QuadDobl_Evaluated_Gradient(e,c,x,z);
    Standard_Natural_VecVecs.Clear(e);
  end QuadDobl_Evaluate_Gradient;

  procedure Evaluate_Gradient is

  -- DESCRIPTION :
  --   Interactive test for the development of the gradient evaluation of
  --   monomials at some random vectors, with and without power table.

    n,d,m : integer32 := 0;
    ans : character;

  begin
    new_line;
    put_line("Reading parameters for a random exponent sequence ...");
    put("  give the number of variables, n = "); get(n);
    put("  give the largest degree, d = "); get(d);
    put("  give number of monomials, m = "); get(m);
    put("standard, double double, or quad double arithmetic ? (s/d/q) ");
    Ask_Alternative(ans,"sdq");
    case ans is
      when 's' => Standard_Evaluate_Gradient(n,d,m);
      when 'd' => DoblDobl_Evaluate_Gradient(n,d,m);
      when 'q' => QuadDobl_Evaluate_Gradient(n,d,m);
      when others => null;
    end case;
  end Evaluate_Gradient;

  procedure Main is

    ans : character;

  begin
    new_line;
    put_line("Evaluation of a monomial and all its derivatives...");
    put_line("  1. run the example of Speelpenning;");
    put_line("  2. enter your own monomial;");
    put_line("  3. generate a random exponent vector;");
    put_line("  4. evaluate sequences of random monomials;");
    put_line("  5. evaluate gradient of a sum of random monomials.");
    put("Type 1, 2, 3, 4, or 5 to choose : ");
    Ask_Alternative(ans,"12345");
    case ans is
      when '1' => Run_Speelpenning;
      when '2' => Monomial_Evaluation;
      when '3' => Random_Monomial_Evaluation;
      when '4' => Evaluate_Monomials;
      when '5' => Evaluate_Gradient;
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_speel;
