with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;      use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;          use Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;       use Standard_Complex_Numbers_io;
with Standard_Random_Numbers;
with Standard_Complex_Vectors;
with Standard_Complex_Vectors_io;       use Standard_Complex_Vectors_io;
with Standard_Complex_VecVecs;          use Standard_Complex_VecVecs;
with Standard_Complex_VecVecs_io;       use Standard_Complex_VecVecs_io;
with Standard_Complex_Matrices;         use Standard_Complex_Matrices;
with Standard_Complex_Matrices_io;      use Standard_Complex_Matrices_io;
with Standard_Random_Vectors;           use Standard_Random_Vectors;
with Standard_Plane_Representations;    use Standard_Plane_Representations;
with Standard_Point_Coordinates;        use Standard_Point_Coordinates;
with Standard_Plane_Operations;         use Standard_Plane_Operations;
with Standard_Moving_Planes;

procedure ts_planes is

-- DESCRIPTION :
--   Interactive facility to work with planes in complex space.
--   With this routine we convert between implicit and parametric
--   representations of affine planes.

  procedure Evaluate_at_Hyperplanes
              ( hyp : in VecVec; x : in Standard_Complex_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Evaluates the point x at the hyperplanes with coefficients in hyp.

    eva : constant Standard_Complex_Vectors.Vector(hyp'range)
        := Evaluate(hyp,x);

  begin
    put_line("evaluation at the hyperplanes : ");
    put_line(eva);
  end Evaluate_at_Hyperplanes;

  procedure Test_Orthogonality ( b : in Standard_Complex_Vectors.Vector;
                                 v : in VecVec ) is

    use Standard_Complex_Vectors;

    w : constant VecVec(v'range) := Orthogonalize(v);
    ip : Complex_Number;
    c1,c2 : Vector(v'range);
    x : Vector(b'range);
    tol : constant double_float := 1.0E-8;

  begin
    put_line("Testing orthogonality with inner products...");
    for i in w'range loop
      for j in w'range loop
        put("<"); put(i,1); put(","); put(j,1); put("> : ");
        ip := Inner_Product(w(i).all,w(j).all);
        put(ip); new_line;
      end loop;
    end loop;
    c1 := Random_Vector(v'first,v'last);
    x := Affine_Expand(c1,b,w);
    c2 := Project(x,b,w);
    put_line("The original random coefficient vector : ");
    put_line(c1);
    put_line("The coefficient vector computed with project : ");
    put_line(c2);
    put("The random point - basis point is");
    if In_Span(w,x-b,tol)
     then put_line(" in span.");
     else put_line(" NOT in span!");
    end if;
  end Test_Orthogonality;

  procedure Test_Orthogonality ( g : Matrix ) is

    og : constant Matrix(g'range(1),g'range(2)) := Orthogonalize(g);
    ip : Complex_Number;
    c1,c2 : Standard_Complex_Vectors.Vector(1..g'last(2));
    x : Standard_Complex_Vectors.Vector(g'range(1));

  begin
    put_line("The given matrix with generators : "); put(g,3);
    put_line("The orthonormal matrix : "); put(og,3);
    put_line("Computing inner products : ");
    for i in 1..og'last(2) loop
      for j in 1..og'last(2) loop
        ip := Create(0.0);
        for k in og'range(1) loop
          ip := ip + og(k,i)*Conjugate(og(k,j));
        end loop;
        put("<"); put(i,1); put(","); put(j,1); put("> : ");
        put(ip); new_line;
      end loop;
    end loop;
    c1 := Random_Vector(1,g'last(2));
    x := Affine_Expand(c1,og);
    c2 := Project(x,og);
    put_line("The original random coefficient vector : ");
    put_line(c1);
    put_line("The coefficient vector computed with project : ");
    put_line(c2);
  end Test_Orthogonality;

  procedure Test_Complement ( eqs,gen : in Matrix ) is

  -- DESCRIPTION :
  --   The vectors in the columns of gen should all satisfy the equations,
  --   or the product of eqs with gen should be the zero matrix.

    eva : Matrix(eqs'range(1),gen'range(2));

  begin
    for i in eqs'range(1) loop       -- evaluate i-th equation
      for j in gen'range(2) loop     -- at the j-th generator
        if j = gen'first(2)
         then eva(i,j) := eqs(i,0);        -- initialize at constant
         else eva(i,j) := Create(0.0);     -- initialize at zero
        end if;
        for k in gen'range(1) loop
          eva(i,j) := eva(i,j) + eqs(i,k)*gen(k,j);
        end loop;
      end loop;
    end loop;
    put_line("The matrix of the complement test :");
    put(eva,3);
  end Test_Complement;

  function Continue return character is

    ans : character;

  begin
    put("Do you wish to continue ? (y/n) ");
    Ask_Yes_or_No(ans);
    return ans;
  end Continue;

  procedure Test ( n,k : in integer32; hyp : in VecVec ) is

  -- DESCRIPTION :
  --   Test on computing the parametric representation of the plane.

    use Standard_Complex_Vectors;

    b,x : Standard_Complex_Vectors.Vector(1..n);
    d : VecVec(1..n-k);
    hyp_eqs : VecVec(hyp'range);
    mat_eqs : constant Matrix(hyp'range,0..n) := Equations_to_Matrix(hyp);
    mat_gen,bis_gen : Matrix(1..n,0..n-k);
    bis_eqs : Matrix(hyp'range,0..n);

  begin
    put_line("The equations in matrix format : ");
    put(mat_eqs,3);
    if (Continue /= 'y') then return; end if;
    if k = 1
     then Generators1(hyp(1).all,b,d);
     else Generators(n,k,hyp,b,d);
    end if;
    mat_gen := Generators_to_Matrix(b,d);
    put_line("The parametric representation as a matrix : ");
    put(mat_gen,3);
    bis_gen := Generators(mat_eqs);
    put_line("The parametric representation computed directly :");
    put(bis_gen,3);
    Test_Complement(mat_eqs,mat_gen);
    put_line("A basis point : "); put_line(b);
    Evaluate_at_Hyperplanes(hyp,b);
    if (Continue /= 'y') then return; end if;
    put_line("The directions : "); put_line(d);
    if (Continue /= 'y') then return; end if;
    x := Random_Point(b,d);
    put_line("A random point : "); put_line(x);
    Evaluate_at_Hyperplanes(hyp,x);
    if (Continue /= 'y') then return; end if;
    if k = n-1
     then hyp_eqs := Equations1(b,d(1).all);
     else hyp_eqs := Equations(b,d);
    end if;
    put_line("The computed equations : ");
    put_line(hyp_eqs);
    bis_eqs := Equations(mat_gen);
    put_line("The equations computed directly in matrix format :");
    put(bis_eqs,3);
    if (Continue /= 'y') then return; end if;
    put_line("testing at the basis point ...");
    Evaluate_at_Hyperplanes(hyp_eqs,b);
    if (Continue /= 'y') then return; end if;
    put_line("testing at the random point ...");
    Evaluate_at_Hyperplanes(hyp_eqs,x);
    if (Continue /= 'y') then return; end if;
    Test_Orthogonality(b,d);
    Test_Orthogonality(mat_gen);
  end Test;

  procedure Random_Test ( n,k : in integer32 ) is

    cff : VecVec(1..k);

  begin
    for i in 1..k loop
      cff(i) := new Standard_Complex_Vectors.Vector'(Random_Vector(0,n));
    end loop;
    put_line("The coefficients of the equations : ");
    put_line(cff);
    Test(n,k,cff);
  end Random_Test;

  procedure Interactive_Test ( n,k : in integer32 ) is

    cff : VecVec(1..k);

  begin
    for i in 1..k loop
      put("Reading the coefficients of the equation ");
      put(i,1); put_line(" ...");
      cff(i) := new Standard_Complex_Vectors.Vector(0..n);
      for j in 0..n loop
        put("cff("); put(i,1); put(","); put(j,1); put(") : ");
        get(cff(i)(j));
      end loop;
    end loop;
    put_line("The coefficients of the equations : ");
    put_line(cff);
    Test(n,k,cff);
  end Interactive_Test;

  procedure Test_Equations ( gen,eqs : in Matrix ) is

  -- DESCRIPTION :
  --   Tests whether a point picked a random from the generators in gen
  --   satisfies the equations in eqs.

    x : Standard_Complex_Vectors.Vector(gen'range(1));
    c : constant Standard_Complex_Vectors.Vector(1..gen'last(2)) 
      := Random_Vector(1,gen'last(2));
    res : double_float;

  begin
    for i in x'range loop
      x(i) := gen(i,0);
      for j in c'range loop
        x(i) := x(i) + c(j)*gen(i,j);
      end loop;
    end loop;
    Evaluate(eqs,x,res);
    put("residual of a random point at the equations :");
    put(res,3); new_line;
  end Test_Equations;

  function Intersection_Count ( genA,eqsB : Matrix ) return integer32 is

  -- DESCRIPTION :
  --   Returns the number of generators in genA satisfy the equations
  --   (of another plane) in eqsB.

    res : integer32 := 0;
    v : Standard_Complex_Vectors.Vector(genA'range(1));
    r : double_float;
    tol : constant double_float := 1.0E-10;
    c : constant Complex_Number := Standard_Random_Numbers.Random1;

  begin
    for j in 1..genA'last(2) loop
      for i in genA'range(1) loop
        v(i) := genA(i,0) + c*genA(i,j);
      end loop;
      Evaluate(eqsB,v,r);
      put("residual of generator "); put(j,1); put(" :"); put(r,3); new_line;
      if r < tol 
       then res := res + 1;
      end if;
    end loop;
    return res;
  end Intersection_Count;

  procedure Test_Intersection ( n,k : in integer32 ) is

  -- DESCRIPTION :
  --   Generates two random k-planes in n-space with a common offset
  --   and then computes their intersection.

    A : Matrix(1..n,0..k) := Standard_Moving_Planes.Random_Plane(n,k);
    B : Matrix(1..n,0..k) := Standard_Moving_Planes.Random_Plane(n,k);
    eqsA,eqsB : Matrix(1..n-k,0..n);
    d,n1,n2 : integer32;

  begin
    new_line;
    put("computing the intersection of two random "); put(k,1);
    put("-planes in "); put(n,1); put_line("-space ...");
    -- make sure the two planes share a common offset point
    for i in 1..n loop
      B(i,0) := A(i,0);
    end loop; 
    eqsA := Equations(A); eqsB := Equations(B);
    new_line;
    put_line("testing the equations of the first plane ...");
    Test_Equations(A,eqsA);
    put_line("testing the equations of the second plane ...");
    Test_Equations(B,eqsB);
    new_line;
    put_line("calling intersect ...");
    Intersect(standard_output,eqsA,eqsB,A,B);
    new_line;
    put_line("testing the new generators of the first plane ...");
    Test_Equations(A,eqsA);
    put_line("testing the new generators of the second plane ...");
    Test_Equations(B,eqsB);
    d := 2*k - n;
    new_line;
    put("Intersection of two "); put(k,1); put("-planes in "); put(n,1);
    put("-space has dimension "); put(d,1); new_line;
    put_line("Counting #generators of one plane satisfy other plane...");
    n1 := Intersection_Count(A,eqsB);
    put("  #generators of A that satisfy B : "); put(n1,1); new_line;
    n2 := Intersection_Count(B,eqsA);
    put("  #generators of B that satisfy A : "); put(n2,1); new_line;
  end Test_Intersection;

  procedure Main is

    ans : character;
    n,k : integer32 := 0;

  begin
    new_line;
    put_line("Representing affine planes in complex space.");
    new_line;
    put_line("Choose one of the following : ");
    put_line("  1. General test on randomly generated data;");
    put_line("  2. Interactive test on user given data;");
    put_line("  3. Test intersection of two random planes.");
    put("Type 1, 2, or 3 to select : ");
    Ask_Alternative(ans,"123");
    new_line;
    put("Give dimension of the ambient space : "); get(n);
    loop
      put("Give the co-dimension of the plane : "); get(k);
      exit when (k < n);
      put("Co-dimension should be less than the dimension of the space.");
      put_line("  Please try again...");
    end loop;
    case ans is 
      when '1' => Random_Test(n,k);
      when '2' => Interactive_Test(n,k);
      when '3' => Test_Intersection(n,k);
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_planes;
