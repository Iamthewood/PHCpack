"""
PHCpack offers numerical Schubert calculus, exported here.
"""

def prompt_for_dimensions():
    """
    Returns the triplet (m,p,q),
    where m is the dimension of the input planes,
    p is the dimension of the output planes, and
    q is the degree of the maps.
    """
    mdim = input('give the dimension of the input planes : ')
    pdim = input('give the dimension of the output planes : ')
    qdeg = input('give the degree of the solution maps : ')
    return (mdim, pdim, qdeg)

def pieri_root_count(mdim, pdim, qdeg):
    """
    Computes the number of pdim-plane producing maps of
    degree qdeg that meet mdim-planes at mdim*pdim + qdeg*(mdim+pdim) points.
    """
    from phcpy.phcpy2c import py2c_pieri_count, py2c_localization_poset
    root_count = py2c_pieri_count(mdim, pdim, qdeg)
    print 'Pieri root count for', (mdim, pdim, qdeg), 'is', root_count
    poset = py2c_localization_poset(mdim, pdim, qdeg)
    print 'the localization poset :'
    print poset

def random_complex_matrix(nbrows, nbcols):
    """
    Returns a random nbrows-by-nbcols matrix
    with randomly generated complex coefficients
    on the unit circle, as a list of rows.
    """
    from math import pi, sin, cos
    from random import uniform as u
    result = []
    for i in range(0, nbrows):
        row = []
        for j in range(0, nbcols):
            angle = u(0, 2*pi)
            cff = complex(cos(angle), sin(angle))
            row.append(cff)
        result.append(row)
    return result

def planes_to_string(planes):
    """
    Returns one long string with all numbers
    in planes, a list of lists of rows.
    The numbers are the real and imaginary parts,
    separated by space.
    """
    result = ""
    for plane in planes:
        for row in plane:
            for cff in row:
                (cffre, cffim) = (cff.real, cff.imag)
                result = result + ' ' + ('%.17e' % cffre)
                result = result + ' ' + ('%.17e' % cffim)
    return result

def points_to_string(pts):
    """
    Returns one long string with all numbers in pts,
    as sequences of real and imaginary parts,
    every number is separated by one space.
    """
    result = ""
    for row in pts:
        for cff in row:
            (xre, yre) = (cff.real, cff.imag)
            result = result + ' ' + ('%.17e' % xre)
            result = result + ' ' + ('%.17e' % yre)
    return result

def run_pieri_homotopies(mdim, pdim, qdeg, planes, *pts):
    """
    Computes the number of pdim-plane producing maps of degree qdeg
    that meet mdim-planes at mdim*pdim + qdeq*(mdim+pdim) points.
    For qdeg = 0, there are no interpolation points.
    """
    from phcpy.phcpy2c import py2c_pieri_count, py2c_pieri_homotopies
    from phcpy.phcpy2c import py2c_syscon_load_polynomial
    from phcpy.phcpy2c import py2c_solcon_number_of_solutions
    from phcpy.phcpy2c import py2c_solcon_length_solution_string
    from phcpy.phcpy2c import py2c_solcon_write_solution_string
    root_count = py2c_pieri_count(mdim, pdim, qdeg)
    print 'Pieri root count for', (mdim, pdim, qdeg), 'is', root_count
    strplanes = planes_to_string(planes)
    # print 'length of input data :', len(strplanes)
    if(qdeg > 0):
        strpts = points_to_string(pts[0])
        # print 'the interpolation points :', strpts
    else:
        strpts = ''
    # print 'calling py2c_pieri_homotopies ...'
    print 'passing %d characters for (m, p, q) = (%d,%d,%d)' \
         % (len(strplanes), mdim, pdim, qdeg)
    py2c_pieri_homotopies(mdim, pdim, qdeg, len(strplanes), strplanes, strpts)
    # print 'making the system ...'
    pols = []
    if(qdeg == 0):
        for i in range(1, mdim*pdim+1):
            pols.append(py2c_syscon_load_polynomial(i))
    else:
        for i in range(1, mdim*pdim+qdeg*(mdim+pdim)+1):
            pols.append(py2c_syscon_load_polynomial(i))
    print 'the system :'
    for poly in pols:
        print poly
    print 'root count :', root_count
    nbsols = py2c_solcon_number_of_solutions()
    sols = []
    for k in range(1, nbsols+1):
        lns = py2c_solcon_length_solution_string(k)
        sol = py2c_solcon_write_solution_string(k, lns)
        sols.append(sol)
    print 'the solutions :'
    for solution in sols:
        print solution
    return (pols, sols)

def verify(pols, sols):
    """
    Verifies whether the solutions in sols
    satisfy the polynomials of the system in pols.
    """
    from phcpy.phcsols import strsol2dict, evaluate
    dictsols = [strsol2dict(sol) for sol in sols]
    checksum = 0
    for sol in dictsols:
        sumeval = sum(evaluate(pols, sol))
        print sumeval
        checksum = checksum + sumeval
    print 'the total check sum :', checksum

def real_osculating_planes(mdim, pdim, qdeg):
    """
    Returns m*p + qdeg*(m+p) real m-planes osculating
    a rational normal curves.
    """
    from phcpy.phcpy2c import py2c_osculating_planes
    dim = mdim*pdim + qdeg*(mdim+pdim)
    from random import uniform as u
    pts = ""
    for k in range(dim):
        cff = '%.17lf' % u(-1, +1)
        pts = pts + ' ' + cff
    # print 'the points :', pts
    osc = py2c_osculating_planes(mdim, pdim, qdeg, len(pts), pts)
    # print 'the coefficients of the planes :'
    # print osc
    items = osc.split(' ')
    ind = 0
    planes = []
    for k in range(0, dim):
        plane = []
        for i in range(0, mdim+pdim):
            row = []
            for j in range(0, mdim):
                row.append(eval(items[ind]))
                ind = ind + 1
            plane.append(row)
        planes.append(plane)
    return planes

def make_pieri_system(mdim, pdim, qdeg, planes, is_real=False):
    """
    Makes the polynomial system defined by the mdim-planes
    in the list planes.
    """
    from phcpy.phcpy2c import py2c_pieri_system
    from phcpy.phcpy2c import py2c_syscon_load_polynomial
    strplanes = planes_to_string(planes)
    # print 'the string of planes :', strplanes
    if is_real:
        py2c_pieri_system(mdim, pdim, qdeg, len(strplanes), strplanes, 1)
    else:
        py2c_pieri_system(mdim, pdim, qdeg, len(strplanes), strplanes, 0)
    result = []
    if(qdeg == 0):
        for i in range(1, mdim*pdim+1):
            result.append(py2c_syscon_load_polynomial(i))
    return result

def cheater(mdim, pdim, qdeg, start, startsols):
    """
    Generates a random Pieri problem of dimensions (mdim,pdim,qdeg)
    and solves it with a Cheater's homotopy, starting from
    the Pieri system in start, at the solutions in startsols.
    """
    dim = mdim*pdim + qdeg*(mdim+pdim)
    planes = [random_complex_matrix(mdim+pdim, mdim) for k in range(0, dim)]
    pols = make_pieri_system(mdim, pdim, qdeg, planes)
    from phcpy.solver import track
    print 'cheater homotopy with %d paths' % len(startsols)
    sols = track(pols, start, startsols)
    for sol in sols:
        print sol
    verify(pols, sols)

def osculating_input(mdim, pdim, qdeg, start, startsols):
    """
    Generates real mdim-planes osculating a rational normal curve
    and solves this Pieri problem using the system in start,
    with corresponding solutions in startsols.
    """
    target_planes = real_osculating_planes(mdim, pdim, qdeg)
    # print 'real osculating planes :', target_planes
    target_system = make_pieri_system(mdim, pdim, qdeg, target_planes, False)
    print 'the start system of length %d :' % len(start)
    for pol in start:
        print pol
    print 'the target system of length %d :' % len(target_system)
    for pol in target_system:
        print pol
    from phcpy.solver import track
    target_solutions = track(target_system, start, startsols)
    for sol in target_solutions:
        print sol
    verify(target_system, target_solutions)

def test():
    """
    Does a test on the Pieri homotopies.
    """
    (mdim, pdim, qdeg) = prompt_for_dimensions()
    pieri_root_count(mdim, pdim, qdeg)
    dim = mdim*pdim + qdeg*(mdim+pdim)
    planes = [random_complex_matrix(mdim+pdim, mdim) for k in range(0, dim)]
    # print '%d random %d-planes :' % (dim, m)
    # for A in planes:
    #    for row in A: print row
    #    print ''
    if(qdeg > 0):
        points = random_complex_matrix(dim, 1)
        print 'interpolation points :'
        for point in points:
            print point
        (system, sols) = run_pieri_homotopies(mdim, pdim, qdeg, planes, points)
    else:
        (system, sols) = run_pieri_homotopies(mdim, pdim, qdeg, planes)
    print 'evaluation of the solutions :'
    verify(system, sols)
    from phcpy.solver import newton_step
    print 'verification with one Newton step :'
    newton_step(system, sols)
    # cheater(m,p,qdeg,system,sols)
    if(qdeg == 0):
        osculating_input(mdim, pdim, qdeg, system, sols)

if __name__ == "__main__":
    test()
