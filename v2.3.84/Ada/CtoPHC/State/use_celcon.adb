with text_io;                           use text_io;
with Interfaces.C;                      use Interfaces.C;
with Communications_with_User;          use Communications_with_User;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;       use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Integer_Vectors;
with Standard_Floating_Vectors;
with Lists_of_Floating_Vectors;         use Lists_of_Floating_Vectors;
with Arrays_of_Integer_Vector_Lists;
with Arrays_of_Floating_Vector_Lists;   use Arrays_of_Floating_Vector_Lists;
with Standard_Complex_Poly_Systems;     use Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_Systems_io;  use Standard_Complex_Poly_Systems_io;
with Standard_Complex_Laur_Systems;     use Standard_Complex_Laur_Systems;
with Standard_Complex_Solutions;        use Standard_Complex_Solutions;
with Supports_of_Polynomial_Systems;
with Floating_Mixed_Subdivisions;       use Floating_Mixed_Subdivisions;
with Floating_Mixed_Subdivisions_io;    use Floating_Mixed_Subdivisions_io;
with Floating_Lifting_Functions;
with Floating_Integer_Convertors;
with Floating_Lifting_Utilities;        use Floating_Lifting_Utilities;
with Induced_Permutations;
with Mixed_Volume_Computation;          use Mixed_Volume_Computation;
with PHCpack_Operations;
with Standard_PolySys_Container;
with Laurent_Systems_Container;
with Standard_Solutions_Container;
with Cells_Container;                   use Cells_Container;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;

function use_celcon ( job : integer32;
                      a : C_intarrs.Pointer;
                      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32 is

  function Select_Point ( L : List; k : natural32 )
                        return Standard_Floating_Vectors.Link_to_Vector is

  -- DESCRIPTION :
  --   Returns the k-th point from the list l.

    res : Standard_Floating_Vectors.Link_to_Vector;
    tmp : List := l;

  begin
    for i in 1..(k-1) loop
      exit when Is_Null(tmp);
      tmp := Tail_Of(tmp);
    end loop;
    if not Is_Null(tmp)
     then res := Head_Of(tmp);
    end if;
    return res;
  end Select_Point;

  function Job0 return integer32 is  -- read mcc and initialize container
  
    file : file_type;
    n,m : natural32;
    r : integer32;
    mix : Standard_Integer_Vectors.Link_to_Vector;
    lif : Link_to_Array_of_Lists;
    sub : Mixed_Subdivision;

  begin
    new_line;
    put_line("Reading the file name for a mixed-cell configuration.");
    Read_Name_and_Open_File(file);
    get(file,n,m,mix,sub);
    close(file);
    r := mix'last;
    lif := new Array_of_Lists'(Lifted_Supports(r,sub));
    Cells_Container.Initialize(mix,lif,sub);
    return 0;
  end Job0;

  function Job1 return integer32 is -- write the mcc in the container

    mcc : Mixed_Subdivision := Cells_Container.Retrieve;
    mix : Standard_Integer_Vectors.Link_to_Vector;
    n,mv : natural32;

  begin
    if not Is_Null(mcc) then
      n := Cells_Container.Dimension;
      mix := Cells_Container.Type_of_Mixture;
      put(standard_output,n-1,mix.all,mcc,mv);
      put("The mixed volume is "); put(mv,1); put_line(".");
    end if;
    return 0;
  end Job1;

  function Job4 return integer32 is -- return type of mixture

    use Standard_Integer_Vectors;
    mix : Link_to_Vector;
    r : integer32;

  begin
    mix := Cells_Container.Type_of_Mixture;
    if mix /= null
     then r := mix'last; Assign(mix.all,b);
     else r := 0;
    end if;
    Assign(r,a);
    return 0;
  end Job4;

  function Job5 return integer32 is -- return cardinalities of supports

    lif : Link_to_Array_of_Lists;
    r : integer32;

  begin
    lif := Cells_Container.Lifted_Supports;
    if lif /= null then
      r := lif'last;
      declare
        nl : Standard_Integer_Vectors.Vector(1..r);
      begin
        for i in nl'range loop
          nl(i) := integer32(Length_Of(lif(i)));
        end loop;
        Assign(nl,b);
      end;
    else
      r := 0;
    end if;
    Assign(r,a);
    return 0;
  end Job5;

  function Job6 return integer32 is -- return point in support

    lif : Link_to_Array_of_Lists;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    v_b : constant C_Integer_Array := C_intarrs.Value(b);
    k_a : constant integer32 := integer32(v_a(v_a'first));
    k_b : constant natural32 := natural32(v_b(v_b'first));
    use Standard_Floating_Vectors;
    lpt : Link_to_Vector;

  begin
    lif := Cells_Container.Lifted_Supports;
   -- put("retrieving point "); put(k_b,1);
   -- put(" from list "); put(k_a,1); put_line(" ...");
    if lif /= null then
      lpt := Select_Point(lif(k_a),k_b);
      if lpt /= null then
        Assign(lpt.all,c);     
        return 0;
      end if;
    end if;
    return 1;
  end Job6;

  function Job7 return integer32 is -- return innner normal

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mic : Mixed_Cell;
    fail : boolean;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if fail
     then return 1;
     else Assign(mic.nor.all,c); return 0;
    end if;
  end Job7;

  function Job8 return integer32 is -- return #elements in cell

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mic : Mixed_Cell;
    fail : boolean;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if not fail then
      declare
        nl : Standard_Integer_Vectors.Vector(mic.pts'range);
      begin
        for i in mic.pts'range loop
          nl(i) := integer32(Length_Of(mic.pts(i)));
        end loop;
        Assign(nl,b);
      end;
      return 0;
    end if;
    return 1;
  end Job8;

  function Job9 return integer32 is -- return point in a cell

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    v_b : constant C_Integer_Array
        := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    k : constant natural32 := natural32(v_a(v_a'first));
    i : constant integer32 := integer32(v_b(v_b'first));
    j : constant natural32 := natural32(v_b(v_b'first+1));
    mic : Mixed_Cell;
    fail : boolean;
    use Standard_Floating_Vectors;
    lpt : Link_to_Vector;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if not fail then
      lpt := Select_Point(mic.pts(i),j);
      if lpt /= null 
       then Assign(lpt.all,c); return 0;
      end if;
    end if;
    return 1;
  end Job9;

  function Job10 return integer32 is -- return mixed volume of a cell

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Cells_Container.Type_of_Mixture;
    mic : Mixed_Cell;
    fail : boolean;
    mv : natural32;
    n : constant integer32 := integer32(Cells_Container.Dimension)-1;
    use Standard_Integer_Vectors;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if fail or mix = null then
      return 1;
    else
      Mixed_Volume(n,mix.all,mic,mv);
      Assign(integer32(mv),b);
      return 0;
    end if;
  end Job10;

  function Job11 return integer32 is -- sets type of mixture

    v : constant C_Integer_Array := C_intarrs.Value(a);
    r : constant integer32 := integer32(v(v'first));
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := new Standard_Integer_Vectors.Vector(1..r);
    r1 : constant Interfaces.C.size_t := Interfaces.C.size_t(r-1);
    mbv : constant C_Integer_Array(0..r1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(r));

  begin
    for i in 0..r-1 loop
      mix(i+1) := integer32(mbv(Interfaces.C.size_t(i)));
    end loop;
    Cells_Container.Initialize(mix);
    return 0;
  end Job11;

  function Job12 return integer32 is -- append point to a support

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    n : constant integer32 := integer32(vb(vb'first));
    x : Standard_Floating_Vectors.Vector(1..n);
    fail : boolean;

  begin
    Assign(natural32(n),c,x);
    fail := Cells_Container.Append_to_Support(k,x);
    if fail
     then return 1;
     else return 0;
    end if;
  end Job12;

  function Job13 return integer32 is -- append mixed cell to container

    va : constant C_Integer_Array
       := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    r : constant integer32 := integer32(va(va'first));
    n : constant integer32 := integer32(va(va'first+1));
    d : constant Interfaces.C.size_t := Interfaces.C.size_t(va(2));
    vb : constant C_Integer_Array(0..d-1)
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(d));
    m : constant integer32 := integer32(vb(0));
    x : Standard_Floating_Vectors.Vector(1..n);
    cnt : Standard_Integer_Vectors.Vector(1..r);
    lab : Standard_Integer_Vectors.Vector(1..m);

  begin
   -- put("  r = "); put(r,1);
   -- put("  n = "); put(n,1);
   -- put("  d = "); put(natural(d),1); new_line;
    for i in cnt'range loop
      cnt(i) := integer32(vb(Interfaces.C.size_t(i)));
    end loop;
    for i in lab'range loop
      lab(i) := integer32(vb(Interfaces.C.size_t(i+r)));
    end loop;
   -- put("the number of points in each support :"); put(cnt); new_line;
   -- put("the labels of points in each support :"); put(lab); new_line;
    Assign(natural32(n),c,x);
    Cells_Container.Append_Mixed_Cell(cnt,lab,x);
    return 0;
  end Job13;

  function Job15 return integer32 is -- retrieve a mixed cell

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    cnt,lab : Standard_Integer_Vectors.Link_to_Vector;
    normal : Standard_Floating_Vectors.Link_to_Vector;
    fail : boolean;

  begin
    Cells_Container.Retrieve_Mixed_Cell(k,fail,cnt,lab,normal);
    if fail then
      return 1;
    else
      declare
        sum : constant integer32 := Standard_Integer_Vectors.Sum(cnt.all);
        cntlab : Standard_Integer_Vectors.Vector(1..cnt'last+lab'last+1);
        ind : integer32 := 0;
      begin
        ind := ind + 1;
        cntlab(ind) := sum;
        for i in cnt'range loop
          ind := ind + 1;
          cntlab(ind) := cnt(i);
        end loop;
        for i in lab'range loop
          ind := ind + 1;
          cntlab(ind) := lab(i);
        end loop;
        Assign(cntlab,b);
      end;
      Assign(normal.all,c);
      return 0;
    end if;
  end Job15;

  function Job17 return integer32 is -- initialize random coefficient system

    q : Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a random coefficient polynomial system ...");
    get(q);
    Cells_Container.Initialize_Random_Coefficient_System(q.all);
    return 0;
  end Job17;

  function Job18 return integer32 is -- write random coefficient system

    q : constant Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_Coefficient_System;

  begin
    if PHCpack_Operations.Is_File_Defined then
      put_line(PHCpack_Operations.output_file,q.all);
      new_line(PHCpack_Operations.output_file);
      put_line(PHCpack_Operations.output_file,"THE SOLUTIONS :");
    else
      put_line(standard_output,q.all);
      new_line(standard_output);
      put_line(standard_output,"THE SOLUTIONS :");
    end if;
    return 0;
  end Job18;

  function Job19 return integer32 is -- copy into systems container

    q : constant Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_Coefficient_System;

  begin
    Standard_PolySys_Container.Initialize(q.all);
    return 0;
  end Job19;

  function Job20 return integer32 is -- copy from systems container

    q : constant Link_to_Poly_Sys := Standard_PolySys_Container.Retrieve;

  begin
    Cells_Container.Initialize_Random_Coefficient_System(q.all);
    return 0;
  end Job20;

  function Job22 return integer32 is -- solve a start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
   -- put("Entering Job22 with k = "); put(k,1); put_line(" ...");
    Cells_Container.Solve_Start_System(k,mv);
    Assign(integer32(mv),b);
   -- put("... leaving Job22 with mv = "); put(mv,1); put_line(".");
    return 0;
  end Job22;

  function Job23 return integer32 is -- track a solution path

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    vb : constant C_Integer_Array
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    i : constant natural32 := natural32(vb(vb'first));
    otp : constant natural32 := natural32(vb(vb'first+1));

  begin
    Cells_Container.Track_Solution_Path(k,i,otp);
    return 0;
  end Job23;

  function Job24 return integer32 is -- copy target solution to container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : Link_to_Solution;

  begin
    ls := Cells_Container.Retrieve_Target_Solution(k,i);
    Standard_Solutions_Container.Append(ls.all);
    return 0;
  end Job24;

  function Job25 return integer32 is -- permute system in container 

    mixsub : constant Mixed_Subdivision := Cells_Container.Retrieve;
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Cells_Container.Type_of_Mixture;
    lp : constant Link_to_Poly_Sys := Standard_PolySys_Container.Retrieve;
    lq : constant Link_to_Laur_Sys := Laurent_Systems_Container.Retrieve;

  begin
    if lp /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lp'range)
            := Supports_of_Polynomial_Systems.Create(lp.all);
        stlb : constant double_float 
             := Floating_Lifting_Functions.Lifting_Bound(lp.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        Induced_Permutations.Remove_Artificial_Origin(ls,stlb);
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
       -- put("the permutation : "); put(ip); new_line;
       -- put_line("before permute :"); put(lp.all);
        Induced_Permutations.Permute(ip,lp.all);
       -- put_line("after permute :"); put(lp.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    if lq /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lq'range)
            := Supports_of_Polynomial_Systems.Create(lq.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
        Induced_Permutations.Permute(ip,lq.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    return 0;
  end Job25;
 
  function Handle_Jobs return integer32 is
  begin
    case job is
      when 0 => return Job0;   -- read a mcc and initialize the container
      when 1 => return Job1;   -- write the mcc in the container
      when 2 => Assign(integer32(Cells_Container.Length),a); return 0;
      when 3 => Assign(integer32(Cells_Container.Dimension),a); return 0;
      when 4 => return Job4;   -- return type of mixture
      when 5 => return Job5;   -- return cardinalities of supports
      when 6 => return Job6;   -- return point in support 
      when 7 => return Job7;   -- return innner normal
      when 8 => return Job8;   -- return #elements in cell
      when 9 => return Job9;   -- return point in a cell
      when 10 => return Job10; -- return mixed volume of a cell
      when 11 => return Job11; -- set type of mixture
      when 12 => return Job12; -- append point to a support
      when 13 => return Job13; -- append mixed cell to container
      when 14 => Cells_Container.Clear; return 0;
      when 15 => return Job15; -- retrieve a mixed cell
      when 16 => Cells_Container.Generate_Random_Coefficient_System; return 0;
      when 17 => return Job17; -- initialize random coefficient system
      when 18 => return Job18; -- write random coefficient system
      when 19 => return Job19; -- copy into systems container
      when 20 => return Job20; -- copy from systems container
      when 21 => Cells_Container.Create_Polyhedral_Homotopy; return 0;
      when 22 => return Job22; -- solve a start system
      when 23 => return Job23; -- track a solution path
      when 24 => return Job24; -- copy target solution to container
      when 25 => return Job25; -- permute a given target system
      when others => put_line("invalid operation"); return 1;
    end case;
  exception
    when others => put("Exception raised in use_celcon handling job ");
                   put(job,1); put_line(".  Will try to ignore...");
                   return 1;
  end Handle_Jobs;

begin
  return Handle_Jobs;
end use_celcon;
