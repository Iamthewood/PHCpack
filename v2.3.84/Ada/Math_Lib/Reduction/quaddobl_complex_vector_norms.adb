with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with QuadDobl_Mathematical_Functions;    use QuadDobl_Mathematical_Functions;
with QuadDobl_Complex_Numbers;           use QuadDobl_Complex_Numbers;

package body QuadDobl_Complex_Vector_Norms is

  function Norm2 ( v : Vector ) return quad_double is

    res : quad_double := Create(integer(0));

  begin
    for i in v'range loop
       res := res + REAL_PART(v(i))*REAL_PART(v(i))
                  + IMAG_PART(v(i))*IMAG_PART(v(i));
    end loop;
    res := SQRT(res);
    return res;
  end Norm2;

  function Sum_Norm ( v : Vector ) return quad_double is

    res : quad_double := Create(0.0);

  begin
    for i in v'range loop
      res := res + AbsVal(v(i));
    end loop;
    return res;
  end Sum_Norm;

  function Max_Norm ( v : Vector ) return quad_double is

    res : quad_double := AbsVal(v(v'first));
    tmp : quad_double;

  begin
    for i in v'first+1..v'last loop
      tmp := AbsVal(v(i));
      if tmp > res
       then res := tmp;
      end if;
    end loop;
    return res;
  end Max_Norm;

end QuadDobl_Complex_Vector_Norms;
