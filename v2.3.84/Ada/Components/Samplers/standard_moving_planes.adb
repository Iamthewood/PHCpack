with Standard_Mathematical_Functions;   use Standard_Mathematical_Functions;
with Standard_Random_Numbers;
with Standard_Complex_Vectors;
with Standard_Complex_Norms_Equals;
with Standard_Plane_Representations;

package body Standard_Moving_Planes is

  function Random_Plane ( n,k : integer32 ) return Matrix is

    res : Matrix(1..n,0..k);

  begin
    for i in 1..n loop
      for j in 0..k loop
        res(i,j) := Standard_Random_Numbers.Random1;
      end loop;
    end loop;
    return Standard_Plane_Representations.Orthogonalize(res);
  end Random_Plane;

  function One_Random_Direction ( m : Matrix ) return Matrix is

    res : Matrix(m'range(1),m'range(2));

  begin
    for i in m'range(1) loop
      for j in m'first(2)..(m'last(2)-1) loop
        res(i,j) := m(i,j);
      end loop;
      res(i,m'last(2)) := Standard_Random_Numbers.Random1;
    end loop;
    return Standard_Plane_Representations.Orthogonalize(res);
  end One_Random_Direction;

  function Rotate ( A : Matrix; theta : double_float;
                    i1,i2 : integer32 ) return Matrix is

    res : Matrix(A'range(1),A'range(2)) := A;
    cot : constant double_float := cos(theta);
    sit : constant double_float := sin(theta);
    c : constant Complex_Number := Create(cot);
    s : constant Complex_Number := Create(sit);

  begin
    for j in 1..A'last(2) loop
      res(i1,j) := c*A(i1,j) - s*A(i2,j);
      res(i2,j) := s*A(i1,j) + c*A(i2,j);
    end loop;
    return res;
  end Rotate;

  function Rotating_Plane ( A : Matrix; i1,i2 : integer32;
                            t : Complex_Number ) return Matrix is

    rt : constant double_float := REAL_PART(t);

  begin
    if rt = 0.0 or rt = 1.0
     then return A;
     else return Rotate(A,2.0*PI*rt,i1,i2);
    end if;
  end Rotating_Plane;

  function Moving_Plane ( A,B : Matrix; t : Complex_Number ) return Matrix is

    res : Matrix(A'range(1),A'range(2));

  begin
    if t = Create(0.0) then
      res := A;
    elsif t = Create(1.0) then
      res := B;
    else
      declare
        tt : constant Complex_Number := Create(1.0) - t;
      begin
        for i in A'range(1) loop
          for j in A'range(2) loop
            res(i,j) := tt*A(i,j) + t*B(i,j);
          end loop;
        end loop;
      end;
      -- res := Standard_Plane_Representations.Orthogonalize(res);
    end if;
    return res;
  end Moving_Plane;

  function Moving_Plane ( A,B : Matrix; gamma,t : Complex_Number )
                        return Matrix is

    res : Matrix(A'range(1),A'range(2));

  begin
    if t = Create(0.0) then
      res := A;
    elsif t = Create(1.0) then
      res := B;
    else 
      declare
        mt : constant Complex_Number := Create(1.0) - t;
        tt : constant Complex_Number := mt + gamma*t*mt;
      begin
        for i in A'range(1) loop
          for j in A'range(2) loop
            res(i,j) := tt*A(i,j) + t*B(i,j);
          end loop;
        end loop;
      end;
      -- res := Standard_Plane_Representations.Orthogonalize(res);
    end if;
    return res;
  end Moving_Plane;

  function Moving_Directions
              ( A,B : Matrix; t : Complex_Number; ortho : boolean )
              return Matrix is

    res : Matrix(A'range(1),A'range(2));

  begin
    if t = Create(0.0) then
      res := A;
    elsif t = Create(1.0) then
      res := B;
    else
      declare
        tt : constant Complex_Number := Create(1.0) - t;
      begin
        for i in A'range(1) loop
          for j in 1..A'last(2) loop
            res(i,j) := tt*A(i,j) + t*B(i,j);
          end loop;
          res(i,0) := B(i,0);
        end loop;
      end;
      if ortho
       then res := Standard_Plane_Representations.Orthogonalize(res);
      end if;
    end if;
    return res;
  end Moving_Directions;

  procedure Normalize ( A : in out Matrix; col : in integer32 ) is

    v : Standard_Complex_Vectors.Vector(A'range(1));
    nrm : double_float;

  begin
    for i in v'range loop
      v(i) := A(i,col);
    end loop;
    nrm := Standard_Complex_Norms_Equals.Norm2(v);
    for i in v'range loop
      A(i,col) := A(i,col)/nrm;
    end loop;
  end Normalize;

  procedure Normalize ( A : in out Matrix; col : in integer32;
                        nrm : out double_float ) is

    v : Standard_Complex_Vectors.Vector(A'range(1));

  begin
    for i in v'range loop
      v(i) := A(i,col);
    end loop;
    nrm := Standard_Complex_Norms_Equals.Norm2(v);
    for i in v'range loop
      A(i,col) := A(i,col)/nrm;
    end loop;
  end Normalize;

end Standard_Moving_Planes;
