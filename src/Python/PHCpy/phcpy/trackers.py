"""
The module trackers offers functions to track paths starting
at the known solutions of a start system and leading to
the desired solutions of a target system.
The path tracking functions in this module can track all solution paths
in several levels of precision: standard double, double double,
quad double, or arbitrary multiprecision arithmetic.
"""

def tune_track_parameters(difficulty=0, digits=16, \
                          interactive=False, silent=True):
    """
    Tunes the numerical continuation parameters for use
    during path tracking based on two parameters:
    the difficulty of the solution path (difficulty)
    and the number of decimal places (digits) for the
    accuracy of the approximations along a path.
    Increasing difficulty will decrease the step size
    and increase the number of steps along a path.
    Increasing digits will decrease the tolerances on
    the numerical approximations.
    If interactive is True, then the user can interactively
    adjust specific numerical continuation parameters.
    If silent is False, then the current values of the
    numerical continuation parameters are shown.
    """
    from phcpy2c import py2c_autotune_continuation_parameters
    from phcpy2c import py2c_tune_continuation_parameters
    from phcpy2c import py2c_show_continuation_parameters
    py2c_autotune_continuation_parameters(difficulty, digits)
    if interactive:
        py2c_tune_continuation_parameters()
    elif not silent:
        py2c_show_continuation_parameters()

def standard_double_track(target, start, sols, gamma=0):
    """
    Does path tracking with standard double precision.
    On input are a target system, a start system with solutions,
    and optionally a (random) gamma constant.
    The target is a list of strings representing the polynomials
    of the target system (which has to be solved).
    The start is a list of strings representing the polynomials
    of the start system, with known solutions in sols.
    The sols is a list of strings representing start solutions.
    By default, a random gamma constant is generated,
    otherwise gamma must be a nonzero complex constant.
    On return are the string representations of the solutions
    computed at the end of the paths.
    """
    from phcpy2c import py2c_copy_container_to_target_system
    from phcpy2c import py2c_copy_container_to_start_system
    from phcpy2c import py2c_copy_container_to_start_solutions
    from phcpy2c import py2c_create_homotopy
    from phcpy2c import py2c_create_homotopy_with_gamma
    from phcpy2c import py2c_solve_by_homotopy_continuation
    from phcpy2c import py2c_solcon_clear_solutions
    from phcpy2c import py2c_copy_target_solutions_to_container
    from solver import store_standard_system
    from solver import store_standard_solutions, load_standard_solutions
    store_standard_system(target)
    py2c_copy_container_to_target_system()
    store_standard_system(start)
    py2c_copy_container_to_start_system()
    # py2c_clear_homotopy()
    if(gamma == 0):
        py2c_create_homotopy()
    else:
        py2c_create_homotopy_with_gamma(gamma.real, gamma.imag)
    dim = len(start)
    store_standard_solutions(dim, sols)
    py2c_copy_container_to_start_solutions()
    py2c_solve_by_homotopy_continuation()
    py2c_solcon_clear_solutions()
    py2c_copy_target_solutions_to_container()
    return load_standard_solutions()

def double_double_track(target, start, sols, gamma=0):
    """
    Does path tracking with double double precision.
    On input are a target system, a start system with solutions,
    and optionally a (random) gamma constant.
    The target is a list of strings representing the polynomials
    of the target system (which has to be solved).
    The start is a list of strings representing the polynomials
    of the start system with known solutions in sols.
    The sols is a list of strings representing start solutions.
    By default, a random gamma constant is generated,
    otherwise gamma must be a nonzero complex constant.
    On return are the string representations of the solutions
    computed at the end of the paths.
    """
    from phcpy2c import py2c_copy_dobldobl_container_to_target_system
    from phcpy2c import py2c_copy_dobldobl_container_to_start_system
    from phcpy2c import py2c_copy_dobldobl_container_to_start_solutions
    from phcpy2c import py2c_create_dobldobl_homotopy
    from phcpy2c import py2c_create_dobldobl_homotopy_with_gamma
    from phcpy2c import py2c_solve_by_dobldobl_homotopy_continuation
    from phcpy2c import py2c_solcon_clear_dobldobl_solutions
    from phcpy2c import py2c_copy_dobldobl_target_solutions_to_container
    from solver import store_dobldobl_system
    from solver import store_dobldobl_solutions, load_dobldobl_solutions
    store_dobldobl_system(target)
    py2c_copy_dobldobl_container_to_target_system()
    store_dobldobl_system(start)
    py2c_copy_dobldobl_container_to_start_system()
    # py2c_clear_homotopy()
    if(gamma == 0):
        py2c_create_dobldobl_homotopy()
    else:
        py2c_create_dobldobl_homotopy_with_gamma(gamma.real, gamma.imag)
    dim = len(start)
    store_dobldobl_solutions(dim, sols)
    py2c_copy_dobldobl_container_to_start_solutions()
    py2c_solve_by_dobldobl_homotopy_continuation()
    py2c_solcon_clear_dobldobl_solutions()
    py2c_copy_dobldobl_target_solutions_to_container()
    return load_dobldobl_solutions()

def quad_double_track(target, start, sols, gamma=0):
    """
    Does path tracking with quad double precision.
    On input are a target system, a start system with solutions,
    and optionally a (random) gamma constant.
    The target is a list of strings representing the polynomials
    of the target system (which has to be solved).
    The start is a list of strings representing the polynomials
    of the start system with known solutions in sols.
    The sols is a list of strings representing start solutions.
    By default, a random gamma constant is generated,
    otherwise gamma must be a nonzero complex constant.
    On return are the string representations of the solutions
    computed at the end of the paths.
    """
    from phcpy2c import py2c_copy_quaddobl_container_to_target_system
    from phcpy2c import py2c_copy_quaddobl_container_to_start_system
    from phcpy2c import py2c_copy_quaddobl_container_to_start_solutions
    from phcpy2c import py2c_create_quaddobl_homotopy
    from phcpy2c import py2c_create_quaddobl_homotopy_with_gamma
    from phcpy2c import py2c_solve_by_quaddobl_homotopy_continuation
    from phcpy2c import py2c_solcon_clear_quaddobl_solutions
    from phcpy2c import py2c_copy_quaddobl_target_solutions_to_container
    from solver import store_quaddobl_system
    from solver import store_quaddobl_solutions, load_quaddobl_solutions
    store_quaddobl_system(target)
    py2c_copy_quaddobl_container_to_target_system()
    store_quaddobl_system(start)
    py2c_copy_quaddobl_container_to_start_system()
    # py2c_clear_homotopy()
    if(gamma == 0):
        py2c_create_quaddobl_homotopy()
    else:
        py2c_create_quaddobl_homotopy_with_gamma(gamma.real, gamma.imag)
    dim = len(start)
    store_quaddobl_solutions(dim, sols)
    py2c_copy_quaddobl_container_to_start_solutions()
    py2c_solve_by_quaddobl_homotopy_continuation()
    py2c_solcon_clear_quaddobl_solutions()
    py2c_copy_quaddobl_target_solutions_to_container()
    return load_quaddobl_solutions()

def multiprecision_track(target, start, sols, gamma=0, decimals=80):
    """
    Does path tracking with multiprecision.
    On input are a target system, a start system with solutions,
    and optionally a (random) gamma constant.
    The target is a list of strings representing the polynomials
    of the target system (which has to be solved).
    The start is a list of strings representing the polynomials
    of the start system with known solutions in sols.
    The sols is a list of strings representing start solutions.
    By default, a random gamma constant is generated,
    otherwise gamma must be a nonzero complex constant.
    The number of decimal places in the working precision is
    given by the value of decimals.
    On return are the string representations of the solutions
    computed at the end of the paths.
    """
    from phcpy2c import py2c_copy_multprec_container_to_target_system
    from phcpy2c import py2c_copy_multprec_container_to_start_system
    from phcpy2c import py2c_copy_multprec_container_to_start_solutions
    from phcpy2c import py2c_create_multprec_homotopy
    from phcpy2c import py2c_create_multprec_homotopy_with_gamma
    from phcpy2c import py2c_solve_by_multprec_homotopy_continuation
    from phcpy2c import py2c_solcon_clear_multprec_solutions
    from phcpy2c import py2c_copy_multprec_target_solutions_to_container
    from solver import store_multprec_system
    from solver import store_multprec_solutions, load_multprec_solutions
    store_multprec_system(target, decimals)
    py2c_copy_multprec_container_to_target_system()
    store_multprec_system(start, decimals)
    py2c_copy_multprec_container_to_start_system()
    # py2c_clear_multprec_homotopy()
    if(gamma == 0):
        py2c_create_multprec_homotopy()
    else:
        py2c_create_multprec_homotopy_with_gamma(gamma.real, gamma.imag)
    dim = len(start)
    store_multprec_solutions(dim, sols)
    py2c_copy_multprec_container_to_start_solutions()
    py2c_solve_by_multprec_homotopy_continuation(decimals)
    py2c_solcon_clear_multprec_solutions()
    py2c_copy_multprec_target_solutions_to_container()
    return load_multprec_solutions()

def track(target, start, sols, precision='d', decimals=80, gamma=0):
    """
    Runs the path trackers to track solutions in sols
    at the start system in start to the target system
    in the target list using the current settings of
    the numerical continuation parameters as tuned by
    the function tune_track_parameters().
    Three levels of precision are supported:
    d  : standard double precision (1.1e-15 or 2^(-53)),
    dd : double double precision (4.9e-32 or 2^(-104)),
    qd : quad double precision (1.2e-63 or 2^(-209)).
    mp : arbitrary multiprecision, with as many decimal places
    in the working precision as the value of decimals.
    The last parameter is optional.  By default,
    a random complex number will be used for gamma,
    otherwise, gamma can be any nonzero complex number.
    """
    if(precision == 'd'):
        return standard_double_track(target, start, sols, gamma)
    elif(precision == 'dd'):
        return double_double_track(target, start, sols, gamma)
    elif(precision == 'qd'):
        return quad_double_track(target, start, sols, gamma)
    elif(precision == 'mp'):
        return multiprecision_track(target, start, sols, gamma, decimals)
    else:
        print 'wrong argument for precision'
        return None

def initialize_standard_tracker(target, start):
    """
    Initializes a path tracker with a generator for a target
    and start system given in standard double precision.
    """
    from phcpy2c import py2c_copy_container_to_target_system
    from phcpy2c import py2c_copy_container_to_start_system
    from phcpy2c import py2c_initialize_standard_homotopy
    from solver import store_standard_system
    store_standard_system(target)
    py2c_copy_container_to_target_system()
    store_standard_system(start)
    py2c_copy_container_to_start_system()
    py2c_initialize_standard_homotopy()

def initialize_dobldobl_tracker(target, start):
    """
    Initializes a path tracker with a generator for a target
    and start system given in double double precision.
    """
    from phcpy2c import py2c_copy_dobldobl_container_to_target_system
    from phcpy2c import py2c_copy_dobldobl_container_to_start_system
    from phcpy2c import py2c_initialize_dobldobl_homotopy
    from solver import store_dobldobl_system
    store_dobldobl_system(target)
    py2c_copy_dobldobl_container_to_target_system()
    store_dobldobl_system(start)
    py2c_copy_dobldobl_container_to_start_system()
    py2c_initialize_dobldobl_homotopy()

def initialize_quaddobl_tracker(target, start):
    """
    Initializes a path tracker with a generator for a target
    and start system given in quad double precision.
    """
    from phcpy2c import py2c_copy_quaddobl_container_to_target_system
    from phcpy2c import py2c_copy_quaddobl_container_to_start_system
    from phcpy2c import py2c_initialize_quaddobl_homotopy
    from solver import store_quaddobl_system
    store_quaddobl_system(target)
    py2c_copy_quaddobl_container_to_target_system()
    store_quaddobl_system(start)
    py2c_copy_quaddobl_container_to_start_system()
    py2c_initialize_quaddobl_homotopy()

def initialize_multprec_tracker(target, start, decimals=100):
    """
    Initializes a path tracker with a generator for a target
    and start system given in arbitrary multiprecision, with
    the number of decimal places in the working precision
    given by the value of decimals.
    """
    from phcpy2c import py2c_copy_multprec_container_to_target_system
    from phcpy2c import py2c_copy_multprec_container_to_start_system
    from phcpy2c import py2c_initialize_multprec_homotopy
    from solver import store_multprec_system
    store_multprec_system(target, decimals)
    py2c_copy_multprec_container_to_target_system()
    store_multprec_system(start, decimals)
    py2c_copy_multprec_container_to_start_system()
    py2c_initialize_multprec_homotopy(decimals)

def initialize_standard_solution(nvar, sol):
    """
    Initializes a path tracker with a generator
    for a start solution sol given in standard double precision.
    The value of nvar must equal the number of variables in the
    solution sol and sol is a PHCpack solution string.
    """
    from phcpy2c import py2c_initialize_standard_solution
    from solver import store_standard_solutions
    store_standard_solutions(nvar, [sol])
    py2c_initialize_standard_solution(1)

def initialize_dobldobl_solution(nvar, sol):
    """
    Initializes a path tracker with a generator
    for a start solution sol given in double double precision.
    The value of nvar must equal the number of variables in the
    solution sol and sol is a PHCpack solution string.
    """
    from phcpy2c import py2c_initialize_dobldobl_solution
    from solver import store_dobldobl_solutions
    store_dobldobl_solutions(nvar, [sol])
    py2c_initialize_dobldobl_solution(1)

def initialize_quaddobl_solution(nvar, sol):
    """
    Initializes a path tracker with a generator
    for a start solution sol given in quad double precision.
    The value of nvar must equal the number of variables in the
    solution sol and sol is a PHCpack solution string.
    """
    from phcpy2c import py2c_initialize_quaddobl_solution
    from solver import store_quaddobl_solutions
    store_quaddobl_solutions(nvar, [sol])
    py2c_initialize_quaddobl_solution(1)

def initialize_multprec_solution(nvar, sol):
    """
    Initializes a path tracker with a generator
    for a start solution sol given in arbitrary multiprecision.
    The value of nvar must equal the number of variables in the
    solution sol and sol is a PHCpack solution string.
    """
    from phcpy2c import py2c_initialize_multprec_solution
    from solver import store_multprec_solutions
    store_multprec_solutions(nvar, [sol])
    py2c_initialize_multprec_solution(1)

def next_standard_solution():
    """
    Returns the next solution on a path tracked with standard
    double precision arithmetic, provided the functions
    initialize_standard_tracker() and initialize_standard_solution()
    have been executed properly.
    """
    from phcpy2c import py2c_next_standard_solution
    from phcpy2c import py2c_solcon_length_solution_string
    from phcpy2c import py2c_solcon_write_solution_string
    py2c_next_standard_solution(1)
    lns = py2c_solcon_length_solution_string(1)
    sol = py2c_solcon_write_solution_string(1, lns)
    return sol

def next_dobldobl_solution():
    """
    Returns the next solution on a path tracked with double
    double precision arithmetic, provided the functions
    initialize_dobldobl_tracker() and initialize_dobldobl_solution()
    have been executed properly.
    """
    from phcpy2c import py2c_next_dobldobl_solution
    from phcpy2c import py2c_solcon_length_dobldobl_solution_string
    from phcpy2c import py2c_solcon_write_dobldobl_solution_string
    py2c_next_dobldobl_solution(1)
    lns = py2c_solcon_length_dobldobl_solution_string(1)
    sol = py2c_solcon_write_dobldobl_solution_string(1, lns)
    return sol

def next_quaddobl_solution():
    """
    Returns the next solution on a path tracked with quad
    double precision arithmetic, provided the functions
    initialize_quaddobl_tracker() and initialize_quaddobl_solution()
    have been executed properly.
    """
    from phcpy2c import py2c_next_quaddobl_solution
    from phcpy2c import py2c_solcon_length_quaddobl_solution_string
    from phcpy2c import py2c_solcon_write_quaddobl_solution_string
    py2c_next_quaddobl_solution(1)
    lns = py2c_solcon_length_quaddobl_solution_string(1)
    sol = py2c_solcon_write_quaddobl_solution_string(1, lns)
    return sol

def next_multprec_solution():
    """
    Returns the next solution on a path tracked with arbitrary
    multiprecision arithmetic, provided the functions
    initialize_multprec_tracker() and initialize_multprec_solution()
    have been executed properly.
    """
    from phcpy2c import py2c_next_multprec_solution
    from phcpy2c import py2c_solcon_length_multprec_solution_string
    from phcpy2c import py2c_solcon_write_multprec_solution_string
    py2c_next_multprec_solution(1)
    lns = py2c_solcon_length_multprec_solution_string(1)
    sol = py2c_solcon_write_multprec_solution_string(1, lns)
    return sol

def test_track(silent=True, precision='d', decimals=80):
    """
    Tests the path tracking on a small random system.
    Two random trinomials are generated and random constants
    are added to ensure there are no singular solutions
    so we can use this generated system as a start system.
    The target system has the same monomial structure as
    the start system, but with random real coefficients.
    Because all coefficients are random, the number of
    paths tracked equals the mixed volume of the system.
    """
    from solver import random_trinomials, real_random_trinomials
    from solver import solve, mixed_volume, newton_step
    pols = random_trinomials()
    real_pols = real_random_trinomials(pols)
    from random import uniform as u
    qone = pols[0][:-1] + ('%+.17f' % u(-1, +1)) + ';'
    qtwo = pols[1][:-1] + ('%+.17f' % u(-1, +1)) + ';'
    rone = real_pols[0][:-1] + ('%+.17f' % u(-1, +1)) + ';'
    rtwo = real_pols[1][:-1] + ('%+.17f' % u(-1, +1)) + ';'
    start = [qone, qtwo]
    target = [rone, rtwo]
    start_sols = solve(start, silent)
    sols = track(target, start, start_sols, precision, decimals)
    mixvol = mixed_volume(target)
    print 'mixed volume of the target is', mixvol
    print 'number of solutions found :', len(sols)
    newton_step(target, sols, precision, decimals)
    # for s in sols: print s

def test_next_track(precision='d', decimals=80):
    """
    Tests the step-by-step tracking of a solution path.
    Three levels of precision are supported:
    d  : standard double precision (1.1e-15 or 2^(-53)),
    dd : double double precision (4.9e-32 or 2^(-104)),
    qd : quad double precision (1.2e-63 or 2^(-209)).
    mp : arbitrary multiprecision with as many decimal places
    in the working precision as the value set by decimals.
    """
    from solver import total_degree_start_system
    quadrics = ['x**2 + 4*y**2 - 4;', '2*y**2 - x;']
    (startsys, startsols) = total_degree_start_system(quadrics)
    print 'the first start solution :\n', startsols[0]
    if(precision == 'd'):
        initialize_standard_tracker(quadrics, startsys)
        initialize_standard_solution(2, startsols[0])
        while True:
            sol = next_standard_solution()
            print 'the next solution :\n', sol
            answer = raw_input('continue ? (y/n) ')
            if(answer != 'y'):
                break
    elif(precision == 'dd'):
        initialize_dobldobl_tracker(quadrics, startsys)
        initialize_dobldobl_solution(2, startsols[0])
        while True:
            sol = next_dobldobl_solution()
            print 'the next solution :\n', sol
            answer = raw_input('continue ? (y/n) ')
            if(answer != 'y'):
                break
    elif(precision == 'qd'):
        initialize_quaddobl_tracker(quadrics, startsys)
        initialize_quaddobl_solution(2, startsols[0])
        while True:
            sol = next_quaddobl_solution()
            print 'the next solution :\n', sol
            answer = raw_input('continue ? (y/n) ')
            if(answer != 'y'):
                break
    elif(precision == 'mp'):
        initialize_multprec_tracker(quadrics, startsys, decimals)
        initialize_multprec_solution(2, startsols[0])
        while True:
            sol = next_multprec_solution()
            print 'the next solution :\n', sol
            answer = raw_input('continue ? (y/n) ')
            if(answer != 'y'):
                break
    else:
        print 'wrong argument for precision'

def test_monitored_track():
    """
    Often the number of paths to track can be huge
    and waiting on the outcome of track() without knowing
    how many paths that have been tracked so far can be annoying.
    This script illustrates how one can monitor the progress
    of the path tracking.  We must use the same gamma constant
    with each call of track.
    """
    from random import uniform
    from cmath import pi, exp
    angle = uniform(0, 2*pi)
    ourgamma = exp(complex(0, 1)*angle)
    from solver import total_degree_start_system, newton_step
    quadrics = ['x**2 + 4*y**2 - 4;', '2*y**2 - x;']
    (startsys, startsols) = total_degree_start_system(quadrics)
    targetsols = []
    for ind in range(0, len(startsols)):
        print 'tracking path', ind+1, '...',
        endsol = track(quadrics, startsys, [startsols[ind]], gamma=ourgamma)
        print 'found solution\n', endsol[0]
        targetsols.append(endsol[0])
    print 'tracked', len(targetsols), 'paths, running newton_step...'
    newton_step(quadrics, targetsols)

def test():
    """
    Runs test_track(), test_next_track(), and test_monitored_track().
    """
    print '\ntesting path tracker...\n'
    test_track() # precision='mp', decimals=48)
    print '\ntesting step-by-step tracking...\n'
    test_next_track() # (precision='mp', decimals=48)
    print '\ntesting monitored tracking...\n'
    test_monitored_track()

if __name__ == "__main__":
    test()
