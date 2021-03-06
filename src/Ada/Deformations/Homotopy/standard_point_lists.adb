with unchecked_deallocation;

package body Standard_Point_Lists is

-- HASH FUNCTIONS :

  function Complex_Inner_Product
             ( x,y : Standard_Complex_Vectors.Vector )
	     return Complex_Number is

    res : Complex_Number := Create(0.0);

  begin
    for i in x'range loop
      res := res + x(i)*Conjugate(y(i));
    end loop;
    return res;
  end Complex_Inner_Product;

-- CREATORS :

  function Create ( sv,h1,h2 : Standard_Complex_Vectors.Vector;
                    label : integer ) return Point is

    res : Point;
    ip1 : constant Complex_Number := Complex_Inner_Product(h1(sv'range),sv);
    ip2 : constant Complex_Number := Complex_Inner_Product(h2(sv'range),sv);

  begin
    res.label := label;
    res.x := REAL_PART(ip1) + IMAG_PART(ip1);
    res.y := REAL_PART(ip2) + IMAG_PART(ip2);
    return res;
  end Create;

  function Create ( ls : Link_to_Solution;
                    h1,h2 : Standard_Complex_Vectors.Vector;
                    label : integer ) return Point is
  begin
    return Create(ls.v,h1,h2,label);
  end Create;

  procedure Append ( first,last : in out Point_List;
                     h1,h2 : in Standard_Complex_Vectors.Vector;
                     label : in integer;
                     sv : in Standard_Complex_Vectors.Vector ) is

    lp : constant Link_to_Point := new Point'(Create(sv,h1,h2,label));

  begin
    Append(first,last,lp);
  end Append;

  procedure Append ( first,last : in out Point_List;
                     h1,h2 : in Standard_Complex_Vectors.Vector;
                     label : in integer; ls : in Link_to_Solution ) is

    lp : constant Link_to_Point := new Point'(Create(ls,h1,h2,label));

  begin
    Append(first,last,lp);
  end Append;

-- SELECTOR :

  procedure Center ( pl : in Point_List; cx,cy : out double_float ) is

    cnt : natural := 0;
    tmp : Point_List := pl;
    lp : Link_to_Point;

  begin
    cx := 0.0; cy := 0.0;
    while not Is_Null(tmp) loop
      lp := Head_Of(tmp);
      cnt := cnt + 1;
      cx := cx + lp.x;
      cy := cy + lp.y;
      tmp := Tail_Of(tmp);
    end loop;
    cx := cx/double_float(cnt);
    cy := cy/double_float(cnt);
  end Center;

-- SORTING :

  function "<" ( lp1,lp2 : Link_to_Point ) return boolean is
  begin
    if lp1.x < lp2.x then
      return true;
    elsif lp1.x > lp2.x then
      return false;
    elsif lp1.y < lp2.y then
      return true;
    else
      return false;
    end if;
  end "<";

  procedure Swap ( lp1,lp2 : in out Link_to_Point ) is

    b : integer;
    z : double_float;

  begin
    b := lp1.label;
    lp1.label := lp2.label;
    lp2.label := b;
    z := lp1.x; lp1.x := lp2.x; lp2.x := z;
    z := lp1.y; lp1.y := lp2.y; lp2.y := z;
  end Swap;

  procedure Sort ( pl : in out Point_List ) is

    t1 : Point_List := pl;
    t2 : Point_List;
    lp1,lp2,min : Link_to_Point;

  begin
    while not Is_Null(t1) loop
      lp1 := Head_Of(t1);
      min := lp1;
      t2 := t1;
      while not Is_Null(t2) loop
        lp2 := Head_Of(t2);
        if lp2 < min
         then min := lp2;
        end if;
        t2 := Tail_Of(t2);
      end loop;
      if min /= lp1
       then Swap(min,lp1);
      end if;
      t1 := Tail_Of(t1);
    end loop;
  end Sort;

  function Equal ( lp1,lp2 : Link_to_Point;
                   tol : double_float ) return boolean is
  begin
    if abs(lp1.x - lp2.x) > tol then
      return false;
    elsif abs(lp1.y - lp2.y) > tol then
      return false;
    else
      return true;
    end if;
  end Equal;

  procedure Clusters ( pl : in Point_List; tol : in double_float ) is

    t1,t2 : Point_List;
    p1,p2 : Link_to_Point;

  begin
    if not Is_Null(pl) then
      t1 := pl; t2 := Tail_Of(t1);
      while not Is_Null(t2) loop
        p1 := Head_Of(t1); p2 := Head_Of(t2);
        if Equal(p1,p2,tol)
         then Report(p1,p2);
        end if;
        t1 := Tail_Of(t1); t2 := Tail_Of(t2);
      end loop;
    end if;
  end Clusters;

-- DESTRUCTORS :

  procedure free is new unchecked_deallocation(Point,Link_to_Point);

  procedure Clear ( lp : in out Link_to_Point ) is
  begin
    free(lp);
  end Clear;

  procedure Shallow_Clear ( pl : in out Point_List ) is
  begin
    List_of_Points.Clear(List_of_Points.List(pl));
  end Shallow_Clear;

  procedure Deep_Clear ( pl : in out Point_List ) is

    tmp : Point_List := pl;
    lp : Link_to_Point;

  begin
    while not Is_Null(tmp) loop
      lp := Head_Of(tmp);
      free(lp);
      tmp := Tail_Of(tmp);
    end loop;
    List_of_Points.Clear(List_of_Points.List(pl));
  end Deep_Clear;

end Standard_Point_Lists;
