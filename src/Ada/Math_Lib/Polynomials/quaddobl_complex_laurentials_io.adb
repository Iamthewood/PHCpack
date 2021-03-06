with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Quad_Double_Numbers_io;             use Quad_Double_Numbers_io;
with QuadDobl_Complex_Numbers;           use QuadDobl_Complex_Numbers;
with Symbol_Table,Symbol_Table_io;

package body QuadDobl_Complex_Laurentials_io is

-- AUXILIARIES FOR OUTPUT ROUTINES :

  procedure Write_Number ( file : in file_type; c : in Complex_Number ) is

  -- DESCRIPTION :
  --   Writes the double double complex number to file
  --   in the format ( real_part(c) + imag_part(c)*I ).

    re : constant quad_double := REAL_PART(c);
    im : constant quad_double := IMAG_PART(c);

  begin
    put(file,"+ ("); put(file,re);
    if im >= 0.0
     then put(file,"+");
    end if;
    put(file,im);
    put(file,"*I)");
  end Write_Number;

  procedure Write_Factor ( file : in file_type; d,i : in integer32;
                           standard : in boolean; pow : in character ) is

  -- DESCRIPTION :
  --   Writes the factor corresponding with the ith unknown on file.

    sb : Symbol_Table.Symbol;

  begin
    if standard then
      put(file,'x');
      if i < 10
       then put(file,i,1);
       else put(file,i,2);
      end if;
    else 
      sb := Symbol_Table.get(natural32(i)); Symbol_Table_io.put(file,sb);
    end if;
    if d > 1 then
      if pow = '^'
       then put(file,'^');
       else put(file,"**");
      end if;
      if d < 10
       then put(file,d,1);
       else put(file,d,2);
      end if;
    end if;
  end Write_Factor;

-- THE OUTPUT OPERATIONS :

  procedure put ( p : in Poly ) is
  begin
    put_line(standard_output,p);
  end put;
 
  procedure put ( file : in file_type; p : in Poly ) is
  begin
    put_line(file,p);
  end put;

  procedure put_line ( p : in Poly ) is
  begin
    put_line(standard_output,p);
  end put_line;

  procedure put_line ( file : in file_type; p : in Poly ) is

    n : constant natural32 := Number_of_Unknowns(p);
    standard : constant boolean := ( Symbol_Table.Number < n );

    procedure Write_Term ( t : in Term; continue : out boolean ) is
 
    -- DESCRIPTION : 
    --   Writes a term to file.

    begin
      new_line(file);
      Write_Number(file,t.cf);
      if Sum(t.dg) /= 0 then
        for i in t.dg'range loop
          if t.dg(i) > 0 then
            put(file,'*');
            Write_Factor(file,t.dg(i),i,standard,'^');
          end if;
        end loop;
      end if;
      continue := true;
    end Write_Term;
    procedure Write_Terms is new Visiting_Iterator(Write_Term);

  begin
    Write_Terms(p);
    put_line(file,";");
  end put_line;

end QuadDobl_Complex_Laurentials_io;
