"""
PHCpy --- a package for Polynomial Homotopy Continuation
========================================================

PHCpy is a collection of Python modules to compute solutions
of polynomial systems using PHCpack.

A homotopy defines the deformation of a start system
(system with known solutions) into the target system
(system that has to be solved).
Continuation or path tracking methods apply numerical
predictor-corrector techniques to track the solution paths
defined by the homotopy, starting at the known solutions of the
start system and ending at the solutions of the target system.

Available modules
-----------------
solver
   exports the blackbox solver of PHCpack, a mixed volume calculator,
   a path tracker, functions to construct start systems, and deflation
   to recondition isolated singular solutions.
phcsols
   solutions of phcpy.solve are lists of PHCpack solution strings
   and the phcsols module exports operations to convert the solution
   strings into Python dictionaries, e.g. for evaluation.
phcmaps
   module to work with monomial maps, defined as solution of systems
   that have exactly two monomials in every equation (binomial systems).
phcsets
   offers tools to work with positive dimensional solution sets.
examples
   defines some interesting examples taken from the research literature,
   the test() solves all systems, performing a regression test.
families
   polynomial system often occur in families and are defined for any
   number of equations and variables, e.g.: the cyclic n-roots system.
schubert
   exports the hypersurface and quantum Pieri homotopies to compute
   isolated solutions to problems in enumerative geometry.
phcwulf
   defines a simple client/server interaction to solve random trinomials.

Calling the blackbox solver
---------------------------

Polynomials and solutions are represented as strings.
Below is an illustration of a session with the blackbox solver
on a system of two random trinomials, polynomials with three
monomials with random coefficients.

   >>> from phcpy.solver import random_trinomials
   >>> f = random_trinomials()
   >>> print f[0]
   (0.583339727743+0.81222826966115*i)*x^0*y^0\
+(-0.730410130891-0.68300881450520*i)*x^5*y^5\
+(0.547878834338+0.83655769847920*i)*x^5*y^0;
   >>> print f[1]
   (0.830635910813+0.55681593338247*i)*x^0*y^4\
+(0.456430547798-0.88975904324518*i)*x^1*y^4\
+(0.034113254002-0.99941797357332*i)*x^2*y^1;
   >>> from phcpy.solver import solve
   >>> s = solve(f,silent=True)
   >>> len(s)
   30
   >>> print s[2]
   t :  1.00000000000000E+00   0.00000000000000E+00
   m : 1
   the solution for t :
    x : -9.99963006604849E-01   8.60147787997449E-03
    y :  0.00000000000000E+00   0.00000000000000E+00
   == err :  4.325E-17 = rco :  2.020E-01 = res :  1.665E-16 =
   >>>

The solve command returned a list of 30 strings in s,
each string represents a solution that makes the polynomials in f vanish.
The module phcsols offers function to evaluate the solutions
in the polynomials given as strings.
"""
try:
    from phcpy.phcpy2c import py2c_PHCpack_version_string
    print py2c_PHCpack_version_string() + ' works!'
except:
    print 'Is the phcpy2c.so not suited for this platform?'

# Definition of the version number
__version__ = '0.1.4'
