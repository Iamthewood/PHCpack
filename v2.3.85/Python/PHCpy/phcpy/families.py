"""
The module families contains scripts to generate polynomial systems
for any dimension.
"""

def cyclic(dim):
    """
    Returns a list of string representing the polynomials
    of the cyclic n-roots system.
    This system entered the computer algebra literature in a technical
    report by J. Davenport on Looking at a set of equations,
    published in 1987 as Bath Computer Science Technical Report 87-06.
    Another technical report by J. Backelin in 1989 has the title
    Square multiples n give infinitely many cyclic n-roots, publised as
    Reports, Matematiska Institutionen 8, Stockholms universitet.
    Another interesting preprint is written by U. Haagerup,
    available at http://www.math.ku.dk/~haagerup, on cyclic p-roots
    of prime length p and related complex Hadamard matrices.
    """
    result = []
    for i in range(dim-1):
        pol = ''
        for j in range(dim):
            term = 'x' + str(j)
            for k in range(i):
                term = term + '*' + 'x' + str((j+k+1) % dim)
            if(j == 0):
                pol = term
            else:
                pol = pol + ' + ' + term
        result.append(pol + ';')
    pol = 'x0'
    for i in range(1, dim):
        pol = pol + '*x' + str(i)
    pol = pol + ' - 1;'
    result.append(pol)
    return result

def katsura_variable(var, dim):
    """
    Returns the variable U(var, dim) for use in the function katsura.
    """
    if(var > dim or var < -dim):
        return ''
    elif(var < 0):
        return 'u' + str(-var)
    else:
        return 'u' + str(var)

def katsura(dim):
    """
    Returns the list of strings to represent the system of Katsura.
    The system originated in a paper by S. Katsura on
    Spin glass problem by the method of integral equation
    of the effective field, published in 1990 by World Scientific
    in the volume New Trends in Magnetism, edited
    by M. D. Coutinho-Filho and S. M. Resende, pages 110-121.
    The note by S. Katsura on Users posing problems to PoSSo appeared
    in 1994 in the second number of the PoSSo Newsletter,
    edited by L. Gonzalez-Vega and T. Recio.
    """
    result = []
    pol = katsura_variable(-dim, dim)
    for i in range(-dim+1, dim+1):
        pol = pol + ' + ' + katsura_variable(i, dim)
    pol = pol + ' - 1'
    result.append(pol + ';')
    for ind in range(dim):
        pol = katsura_variable(-dim, dim) + '*' + katsura_variable(dim, dim)
        for i in range(-dim+1, dim+1):
            pol = pol + ' + ' + katsura_variable(i, dim)
            var = katsura_variable(ind-i, dim)
            if(var != ''):
                pol = pol +  '*' + katsura_variable(ind-i, dim)
        pol = pol + ' - ' + katsura_variable(ind, dim)
        result.append(pol + ';')
    return result

def noon(dim, parameter=1.1):
    """
    Returns the list of strings to represent the system of Noonburg.
    The system originates in a paper by V. W. Noonburg on
    a neural network modeled by an adaptive Lotka-Volterra system,
    published in 1989 in volume 49 of SIAM Journal on Applied Mathematics,
    pages 1779-1792.
    It appeared also in a paper by K. Gatermann entitled Symbolic solution
    of polynomial equation systems with symmetry, published by ACM in 1990
    in the proceedings of ISSAC-90, pages 112-119.
    """
    result = []
    for i in range(dim):
        pol = 'x' + str(i+1) + '*('
        for j in range(dim):
            if(i != j):
                if(pol[-1] != '('):
                    pol = pol + ' + '
                pol = pol + 'x' + str(j+1) + '^2'
        pol = pol + ') - ' + str(parameter) + '*x' + str(i+1)
        pol = pol + ' + 1;'
        result.append(pol)
    return result

def indeterminate_matrix(rows, cols):
    """
    Returns a list of lists with as many lists
    as the value of rows.  Each rows has as many
    indeterminates as the value of cols.
    The lists of lists contains the data for a
    matrix of dimension rows by cols of variables.
    """
    result = []
    for i in range(0, rows):
        ithrow = []
        for j in range(0, cols):
            name = 'x' + '_' + str(i+1) + '_' + str(j+1)
            ithrow.append(name)
        result.append(ithrow)
    return result

def adjacent_minors(rows, cols):
    """
    Returns all adjacent 2-by-2 minors of a general
    matrix of dimensions rows by cols.
    This system originated in a paper on lattice walks and
    primary decomposition, written by P. Diaconis, D. Eisenbud,
    and B. Sturmfels, published by Birkhauser in 1998 in
    Mathematical Essays in Honor of Gian-Carlo Rota,
    edited by B. E. Sagan and R. P. Stanley,
    volume 161 of Progress in Mathematics, pages 173--193.
    See also the paper by S. Hosten and J. Shapiro on
    Primary decomposition of lattice basis ideals, published in 2000
    in the Journal of Symbolic Computation, volume 29, pages 625-639.
    """
    vrs = indeterminate_matrix(rows, cols)
    result = []
    for i in range(0, rows-1):
        for j in range(0, cols-1):
            equ = vrs[i][j] + '*' + vrs[i+1][j+1]
            equ = equ +  '-'
            equ = equ + vrs[i+1][j] + '*' + vrs[i][j+1]
            result.append(equ + ';')
    return result

def pieri_problem(mdim, pdim, real=True):
    """
    Returns a system that expresses the intersection of pdim-planes
    with mdim*pdim general mdim-planes in (mdim+pdim)-space.
    When real is True, the generated mdim-planes are osculating
    a rational normal curve and all solutions are expected to be real.
    If real is False, then random complex planes are generated.
    For reality of solutions of polynomial systems, see the book by
    Frank Sottile: Real Solutions to Equations from Geometry,
    volume 57 of University Lecture Series, AMS, 2011.
    """
    from schubert import make_pieri_system
    from schubert import real_osculating_planes
    from schubert import random_complex_matrices
    if real:
        planes = real_osculating_planes(mdim, pdim, 0)
    else:
        planes = random_complex_matrices(mdim*pdim, mdim, pdim)
    return make_pieri_system(mdim, pdim, 0, planes)

def recpol(nbplayers, player, ind, acc):
    """
    Recursive generation of one polynomial,
    called by the function nash below.
    """
    from random import uniform
    result = ''
    prob = 'p' + str(ind)
    if(ind != player):
        (r1u, r2u) = (uniform(0,1), uniform(0,1))
        if(acc == '1'):
            result += ' + ' + str(r1u) + '*' + prob + ' + ' \
                   + str(r2u) + '*(1 - ' + prob + ')'
        else:
            result += ' + ' + str(r1u) + '*' + prob + '*' + acc + ' + ' \
                   + str(r2u) + '*(1 - ' + prob + ')*' + acc 
        if(ind < nbplayers):
            if(acc == '1'):
                result += recpol(nbplayers, player, ind+1, prob) \
                       + recpol(nbplayers, player, ind+1, \
                                '(1 - ' + prob + ')')
            else:
                result += recpol(nbplayers, player, ind+1, \
                                 prob + '*' + acc) \
                       + recpol(nbplayers, player, ind+1, \
                                '(1 - ' + prob + ')*' + acc)
    elif(ind < nbplayers):
        result = recpol(nbplayers, player, ind+1, acc)
    return result

def nash(nbplayers, player):
    """
    Returns the string representation of one equation for a player 
    to compute the totally mixed Nash equibria for nbplayers with 
    two pure strategies, with random positive utilities.
    """
    equ = recpol(nbplayers, player, 1, '1')
    return equ[2:] + ';' # bite off leading ' +'

def generic_nash_system(nbplayers):
    """
    Returns a list of strings representing polynomials that
    define totally mixed Nash equilibria for a number of players
    equals to nbplayers with two pure strategies.
    The problem setup is generic in the sense that the utilities
    are uniformly generated positive floats in [0,1].
    For n players, the n-homogeneous Bezout number provides
    a generically exact count on the number of equilibria, 
    see the paper by Richard D. McKelvey and Andrew McLennan on
    the maximal number of regular totally mixed Nash equilibria,
    published in the Journal of Economic Theory, volume 72,
    pages 411-425, 1997.
    """
    result = [nash(nbplayers,k) for k in range(1,nbplayers+1)]
    return result

def test():
    """
    Writes particular instances of the systems
    in the families.
    """
    print '\ncyclic 5-roots :\n'
    for pol in cyclic(5):
        print pol
    print '\nnoon for n = 5 :\n'
    for pol in noon(5):
        print pol
    print '\nkatsura for n = 5 :\n'
    for pol in katsura(5):
        print pol
    print '\nadjacent 2-by-2 minors of a 3-by-5 matrix :\n'
    for pol in adjacent_minors(3, 5):
        print pol
    print '\nintersection of 6 general 3-planes with 2-planes :\n'
    for pol in pieri_problem(3, 2):
        print pol
    print '\nNash equilibria for game with 4 players and 2 strategies :\n'
    for pol in generic_nash_system(4):
        print pol

if __name__ == "__main__":
    test()
