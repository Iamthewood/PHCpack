with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Abstract_Ring;
with Generic_Laurent_Polynomials;

generic

  with package Ring is new Abstract_Ring(<>);
  with package Polynomials is new Generic_Laurent_Polynomials(Ring);

package Generic_Laur_Poly_Systems is 

-- DESCRIPTION :
--   This package provides polynomial systems as an array of polynomials
--   with some arithmetic operations.

  use Ring,Polynomials;

-- DATA STRUCTURES :

  type Laur_Sys is array ( integer32 range <> ) of Poly;
  type Link_to_Laur_Sys is access Laur_Sys;

-- COPYING :

  procedure Copy ( p : in Laur_Sys; q : in out Laur_Sys );

-- ARITHMETIC OPERATIONS :

  function "+" ( p,q : Laur_Sys ) return Laur_Sys;            -- return p+q
  function "-" ( p,q : Laur_Sys ) return Laur_Sys;            -- return p-q
  function "-" ( p : Laur_Sys ) return Laur_Sys;              -- return -p
  function "*" ( a : number; p : Laur_Sys ) return Laur_Sys;  -- return a*p
  function "*" ( p : Laur_Sys; a : number) return Laur_Sys;   -- return p*a

  procedure Add ( p : in out Laur_Sys; q : in Laur_Sys );     -- p := p+q
  procedure Sub ( p : in out Laur_Sys; q : in Laur_Sys );     -- p := p-q
  procedure Min ( p : in out Laur_Sys );                      -- p := -p
  procedure Mul ( p : in out Laur_Sys; a : in number );       -- p := a*p

-- DIFFERENTIATORS :

  function  Diff ( p : Laur_Sys; i : integer32 ) return Laur_Sys;
  procedure Diff ( p : in out Laur_Sys; i : in integer32 );

-- DESTRUCTORS :

  procedure Clear ( p : in out Laur_Sys );
  procedure Clear ( p : in out Link_to_Laur_Sys );

end Generic_Laur_Poly_Systems;
