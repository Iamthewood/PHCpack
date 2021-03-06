-- This package provides an interface to the Littlewood-Richardson
-- homotopies in PHCpack.

newPackage(
   "LRhomotopies",
   Version => "0.6" ,
   Date => "28 July 2011",
   Authors => {{Name => "Jan Verschelde",
                Email => "jan@math.uic.edu",
                HomePage => "http://www.math.uic.edu/~jan/"}},
   Headline => "interface to Littlewood-Richardson homotopies in PHCpack",
   DebuggingMode => true
)

export{"LRrule","LRtriple","wrapTriplet","LRcheater"}

needsPackage "SimpleDoc"

LRruleIn = method();
LRruleIn(ZZ,ZZ,Matrix) := (a,n,m) -> (
-- 
-- DESCRIPTION :
--   Prepares the input for phc -e option #4 to resolve a Schubert
--   intersection condition, for example: [2 4 6]^3.
--
-- ON ENTRY :
--   a         should be 4 for root count, 5 for solutions;
--   n         ambient dimension;
--   m         matrix with in rows the intersection conditions,
--             the first element of each row is the number of times
--             the intersection bracket must be taken.
-- 
-- ON RETURN :
--   s         a string with input for phc -e, i.e.: if s is place
--             in the file "input" then phc -e < input will work.
--
   s := concatenate(toString(a),"\n");
   nr := numgens target m;
   nc := numgens source m;
   s = concatenate(s,toString(n),"\n");
   for i from 0 to nr-1 do
   (
       s = concatenate(s,"[ ");
       for j from 1 to nc-1 do s = concatenate(s,toString(m_(i,j))," ");
       if m_(i,0) > 1 then
          s = concatenate(s,"]^",toString(m_(i,0)))
       else
          s = concatenate(s,"]");
       if i < nr-1 then s = concatenate(s,"*");
   );
   s = concatenate(s,";");
   s
);
dataToFile = method()
dataToFile(String,String) := (data,name) -> (
--
-- DESCRIPTION :
--   Writes the all characters in the string data to the
--   file with the given name for the LRrule computation.
--
   file := openOut name;
   file << data << endl;
   close file;
);
lastLine = method()
lastLine(String) := (name) -> (
--
-- DESCRIPTION :
--   Returns a string with the contents of the last line
--   ond file with the given name.
--
   s := get name;
   L := lines(s);
   n := #L-1;
   result := L_n;
   result
);
LRrule = method();
LRrule(ZZ,Matrix) := (n,m) -> (
-- 
-- DESCRIPTION :
--   Returns the intersection condition and its result.
--
-- ON ENTRY :
--   n         ambient dimension;
--   m         matrix with in rows the intersection conditions,
--             the first element of each row is the number of times
--             the intersection bracket must be taken.
-- 
-- ON RETURN :
--   s         a string with an equation, with at the left the
--             intersection condition and at the right the result.
--
   d := LRruleIn(4,n,m);
   stdio << "the input data for phc -e : " << endl <<  d;
   PHCinputFile := temporaryFileName() | "PHCinput";
   PHCoutputFile := temporaryFileName() | "PHCoutput";
   stdio << endl << "writing data to file " << PHCinputFile << endl;
   dataToFile(d,PHCinputFile);
   stdio << "running phc -e, writing output to " << PHCoutputFile << endl;
   run("phc -e < " | PHCinputFile | " > " | PHCoutputFile);
   stdio << "opening output file " << PHCoutputFile << endl;
   outcome := lastLine(PHCoutputFile);
   s := substring(4,#d-5,d);
   s = concatenate(s,outcome);
   s
);
systemFromFile = method();
systemFromFile(String) := (name) -> (
--
-- DESCRIPTION :
--   Given the name of the output file of a run of phc -e with option #5,
--   this method returns a string with the polynomial system solved.
--
-- ON ENTRY :
--   name      name of the output file of a run of phc -e with option #5,
--             must contain the banner "POLYNOMIAL SYSTEM" followed by
--             the polynomial equations solved.
--            
-- ON RETURN :
--   (f,p,s)   a sequence with flag and polynomial system, and solutions,
--   f         random complex coordinates of the fixed flag,
--   p         the solved polynomial equations as a string,
--   s         solutions to the polynomials in string format.
--
   data := get name;
   L := lines(data);
   nf := position(L,i->i=="THE FIXED FLAGS :");
   np := position(L,i->i=="THE POLYNOMIAL SYSTEM :");
   K := take(L,{np,#L-1});
   ns := np + position(K,i->i=="THE SOLUTIONS :");
   f := concatenate(L_(nf+1),"\n");
   for i from nf+2 to np-1 do f = concatenate(f,L_i,"\n");
   p := concatenate(L_(np+1),"\n");
   for i from np+2 to ns-1 do p = concatenate(p,L_i,"\n");
   s := concatenate(L_(ns+1),"\n");
   for i from ns+2 to #L-1 do s = concatenate(s,L_i,"\n");
   result := (f,p,s);
   result
);
LRtriple = method();
LRtriple(ZZ,Matrix) := (n,m) -> (
--
-- DESCRIPTION :
--   Solves one checker game for a triple Schubert intersection.
--
-- ON ENTRY :
--   n         ambient dimension;
--   m         matrix with in rows the intersection conditions,
--             the first element of each row is the number of times
--             the intersection bracket must be taken.
-- 
-- ON RETURN :
--   (f,p,s)   a sequence with the result of the Schubert problem:
--   f         a string representation of a fixed flag,
--   p         a string representation of a polynomial system,
--   s         a string with solutions to the polynomial system.
--
   d := LRruleIn(5,n,m);  -- option 5 of phc -e
   PHCinputFile := temporaryFileName() | "PHCinput";
   PHCoutputFile := temporaryFileName() | "PHCoutput";
   PHCsessionFile := temporaryFileName() | "PHCsession";
   PHCsolutions := temporaryFileName() | "PHCsolutions";
   d = concatenate(d,"\n0\n");  -- solve a generic instance for random flags
   d = concatenate(d,PHCoutputFile,"\n");
   d = concatenate(d,"0\n");  -- do not change default continuation parameters
   d = concatenate(d,"0\n");  -- no intermediate output during continuation
   stdio << "the input data for phc -e : " << endl <<  d;
   stdio << endl << "writing data to file " << PHCinputFile << endl;
   dataToFile(d,PHCinputFile);
   stdio << "running phc -e, session output to " << PHCsessionFile << endl;
   stdio << "                writing output to " << PHCoutputFile << endl;
   run("phc -e < " | PHCinputFile | " > " | PHCsessionFile);
   run("phc -z " | PHCoutputFile | " " | PHCsolutions);
   stdio << "opening output file " << PHCsolutions << endl;
   stdio << endl << "extracting fixed flags, polynomial system, solutions";
   stdio << endl;
   fps := systemFromFile(PHCoutputFile);
   result := (fps_0,fps_1,fps_2);
   result
);
wrapTriplet = method();
wrapTriplet(String,String,String) := (f,p,s) -> (
--
-- DESCRIPTION :
--   Wraps the triplet of strings: fixed flag f, polynomial system p,
--   and solutions s into one string suitable for parsing by phc -e.
--
   result := concatenate("THE FIXED FLAGS :\n",f);
   result = concatenate(result,"THE POLYNOMIAL SYSTEM :\n",p);
   result = concatenate(result,"THE SOLUTIONS :\n",s);
   result
);
cheaterInputFile = method();
cheaterInputFile(String) := (data) -> (
--
-- DESCRIPTION :
--   Generates a file name and writes the data in the string to it.
--   Returns the name of this input file.
-- 
-- ON ENTRY :
--   w         the outcome of LRtriple(n,m), wrapped into a string.
--
-- ON RETURN :
--   name      name of the file that contains the data.
--
   name := temporaryFileName() | "PHCcheaterInput";
   stdio << "writing start data to " << name << endl;
   file := openOut name;
   file << data << endl;
   close file;
   name
);
LRcheater = method();
LRcheater(ZZ,Matrix,String) := (n,m,w) -> (
--
-- DESCRIPTION :
--   Runs a cheater's homotopy from a generic instance of a Schubert
--   triple intersection to a real instance.
--
-- ON ENTRY :
--   n         ambient dimension;
--   m         matrix with in rows the intersection conditions,
--             the first element of each row is the number of times
--             the intersection bracket must be taken,
--   w         the outcome of LRtriple(n,m), wrapped into string.
--
-- ON RETURN :
--   t         a real triple Schubert intersection problem.
--   
   PHCinputCheater := cheaterInputFile(w);
   PHCoutputCheater := temporaryFileName() | "PHCoutputCheater";
   PHCinputSession := temporaryFileName() | "PHCinputSession";
   PHCsessionCheater := temporaryFileName() | "PHCsessionCheater";
   PHCsolutionsCheater := temporaryFileName() | "PHCsolutionsCheater";
   d := LRruleIn(5,n,m);        -- option 5 of phc -e
   d = concatenate(d,"\n1\n");  -- run Cheater's homotopy
   d = concatenate(d,PHCinputCheater,"\n");
   d = concatenate(d,"y\n");    -- generate real flags
   d = concatenate(d,PHCoutputCheater,"\n");
   stdio << "the input data for phc -e : " << endl <<  d;
   stdio << endl << "writing data to file " << PHCinputSession << endl;
   dataToFile(d,PHCinputSession);
   stdio << "running phc -e, session output to " << PHCsessionCheater << endl;
   stdio << "                writing output to " << PHCoutputCheater << endl;
   run("phc -e < " | PHCinputSession | " > " | PHCsessionCheater);
   run("phc -z " | PHCoutputCheater | " " | PHCsolutionsCheater);
   stdio << "opening output file " << PHCsolutionsCheater << endl;
   stdio << endl << "extracting fixed flags, polynomial system, solutions";
   stdio << endl;
   fp := systemFromFile(PHCoutputCheater);
   s := get PHCsolutionsCheater;
   result := (fp_0,fp_1,s);
   result
);

beginDocumentation()

doc ///
  Key
    LRhomotopies
  Headline
    interface to Littlewood-Richardson homotopies in PHCpack
  Description
    Text
      Interfaces the functionality of the software {\tt PHCpack}
      to solve Schubert problems with Littlewood-Richardson homotopies,
      a tool in {\em numerical Schubert calculus}.
      The software {\tt PHCpack} is available at
      @HREF"http://www.math.uic.edu/~jan/download.html"@.
      The site provides source code and its executable versions {\tt phc}.
      The user must have the executable program {\tt phc} available,
      preferably in the executation path.
  Caveat
    The program "phc" (at least version 2.3.52, but preferably higher)
    of PHCpack needs to in the path for execution.

    The current implementation resolves only one triple intersection
    condition (although the root count in LRrule is general).

    The current output of the calculations consist of strings
    and requires still parsing and independent verification
    with proper Macaulay 2 arithmetic.
///;

doc ///
  Key
    LRrule
    (LRrule,ZZ,Matrix)
  Headline
    calls phc -e to resolve a Schubert intersection condition
  Usage
    s = LRrule(n,m)
  Inputs
    n:ZZ
      the ambient dimension
    m:Matrix
      in the rows are the intersection conditions,
      the first element of each row is the number of times
      the intersection bracket must be taken.
  Outputs
    s:String
      contains an equation, with at the left the
      intersection condition and at the right the result.
  Description
    Text
      The LRrule computes the number of solutions to
      a Schubert intersection condition.
    Example
      R := ZZ;
      n := 7;
      m := matrix{{1, 2, 4, 6},{2, 3, 5, 7}};
      print LRrule(n,m);
    Text
      The Schubert condition [2 4 6]*[3 5 7]^2 resolves to 2[1 2 3]
      means that there are two 3-planes that satisfy the condition.
    
      If the right hand side of the equation returned by LRrule
      consists of one bracket of consecutive natural numbers starting
      at zero, then there are finitely many solutions.
      Otherwise, the problem may be underdetermined,
      consider the example:
    Example
      LRrule(7, matrix{{2,3,6,7},{1,3,5,7},{1,2,5,7}})
    Text
      Littlewood-Richardson homotopies work only for fully determined
      Schubert intersection conditions.
///;

doc ///
  Key
    LRtriple
    (LRtriple,ZZ,Matrix)
  Headline
    calls phc -e to run one checker game for a triple Schubert intersection
  Usage
    (f,p,s) = LRtriple(n,m)
  Inputs
    n:ZZ
      the ambient dimension
    m:Matrix
      in the rows are the intersection conditions,
      the first element of each row is the number of times
      the intersection bracket must be taken.
  Outputs
    f:String
      represents the fixed flag
    p:String
      represents a polynomial system
    s:String
      solutions to the polynomial system
  Description
    Text
      LRtriple applies the Littlewood-Richardson homotopies
      to solve a generic instance of a Schubert problem defined
      by three intersection conditions.

      The example below computes all 3-planes that satisfy [2 4 6]^3.
    Example
      R := ZZ;
      n := 6;
      m := matrix{{3, 2, 4, 6}};
      result := LRtriple(n,m);
      stdio << "the fixed flags :\n" << result_0;
      stdio << "polynomial system solved :\n" << result_1;
      stdio << "solutions :\n" << result_2;
///;

doc ///
  Key
    wrapTriplet
    (wrapTriplet,String,String,String)
  Headline
    Wraps a flag, system, and solutions into one string for phc -e.
  Usage
    w = wrapTriple(f,p,s)
  Inputs
    f:String
      represents the fixed flag
    p:String
      represents a polynomial system
    s:String
      solutions to the polynomial system
  Outputs
    w:String
      suitable for input to cheater in phc -e
  Description
    Text
      To pass the output of LRtriple to the LRcheater,
      the flag, the polynomial system and its solutions
      are wrapped into one string.
///;

doc ///
  Key
    LRcheater
    (LRcheater,ZZ,Matrix,String)
  Headline
    A cheater's homotopy to a real Schubert triple intersection problem
  Usage
    t = LRcheater(n,m,w)
  Inputs
    n:ZZ
      the ambient dimension
    m:Matrix
      in the rows are the intersection conditions,
      the first element of each row is the number of times
      the intersection bracket must be taken.
    w:String
      the outcome of LRtriple(n,m), wrapped into string.
  Outputs
    t:String
      solutions to a a real triple Schubert intersection problem.
  Description
    Text
      A cheater's homotopy between two polynomial systems connects
      a generic instance to a specific instance.

      The example below
      solves a generic instance of [2 4 6]^3, followed by a cheater
      homotopy to a real instance.
    Example
      R := ZZ;
      n := 6;
      m := matrix{{3, 2, 4, 6}};
      t := LRtriple(n,m);
      w := wrapTriplet(t);
      result := LRcheater(n,m,w);
      stdio << "real fixed flags :\n" << result_0;
      stdio << "polynomial system solved :\n" << result_1;
      stdio << "solutions :\n" << result_2;
///;

end  -- terminate reading

  Usage
   s = LRrule(N,M)
   S = LRtriple(N,M)
   w = wrapTriplet(S)
   R = LRcheater(N,M,w)
Inputs
   N:ZZ
     positive
   M:Matrix
Outputs
   s:String
   S:Sequence
   w:String
   R:Sequence
Description
   Text
      The Littlewood-Richardson rule is provided in LRrule.

      LRrule takes on input a Schubert intersection like [2 4 6]^3
      and returns a string with the resolution of this condition.
   Example
      R = ZZ
      N = 7
      M = matrix{{1, 2, 4, 6},{2, 3, 5, 7}}
      print LRrule(N,M)
      S = LRtriple(N,M)
      w = wrapTriplet(S)
      print LRcheater(N,M,w)
Caveat
   The program "phc" built with version 2.3.52 (or higher)
   of PHCpack needs to be executable on the computer.
   Executables for various platforms and source code for phc
   are available from the web page of the author.

   The current output of the calculations consist of strings
   and requires still parsing and independent verification
   with proper Macaulay 2 arithmetic.
///
