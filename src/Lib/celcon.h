/* This file "celcon.h" contains the prototypes of the operations
 * on the cells container in PHCpack. */

int celcon_read_mixed_cell_configuration ( void );
/*
 * DESCRIPTION :
 *   Prompts the user for a file name, reads a mixed-cell configuration,
 *   which is then stored in the container. */

int celcon_write_mixed_cell_configuration ( void );
/*
 * DESCRIPTION :
 *   Writes the mixed-cell configuration in the container to screen. */

int celcon_number_of_cells ( int *length );
/*
 * DESCRIPTION :
 *   Returns in length the number of cells in the container. */

int celcon_dimension_of_points ( int *dimension );
/*
 * DESCRIPTION :
 *   Returns the dimension of the lifted points in the cells container. */

int celcon_type_of_mixture ( int *r, int *mix );
/*
 * DESCRIPTION :
 *   Returns in r the number of different supports and in mix[i] the number
 *   of occurrences of the (i+1)-th support.  By default, call this routine
 *   with mix[] the size of the dimension of the points minus one, as the
 *   size of mix[] on entry must be as large as the number of supports. */

int celcon_length_of_supports ( int *r, int *length );
/*
 * DESCRIPTION :
 *   Returns in r the number of different supports and in mix[i] the number
 *   of occurrences of the (i+1)-th support.  By default, call this routine
 *   with length[] the size of the dimension of the points minus one, as the
 *   size of length[] on entry must be as large as the number of supports. */

int celcon_get_lifted_point ( int n, int i, int j, double *point );
/*
 * DESCRIPTION :
 *   Returns the j-th point of the i-th support.
 *
 * ON ENTRY :
 *   n         length of the lifted vectors in the supports;
 *   i         index to a lifted support;
 *   j         index to a point in the i-th lifted support.
 *
 * ON RETURN :
 *   point     coordinates of the j-th point in the i-th lifted support,
 *             of dimension n. */

int celcon_get_inner_normal ( int n, int i, double *normal );
/*
 * DESCRIPTION :
 *   Returns the inner normal to the i-th mixed cell in the container.
 *
 * ON ENTRY :
 *   n         length of the lifted vectors in the supports;
 *   i         index to a cell in the container.
 *
 * ON RETURN :
 *   normal    coordinates of the inner normal to the i-th cell,
 *             of dimension n. */

int celcon_number_of_points_in_cell ( int i, int r, int *length );
/*
 * DESCRIPTION :
 *   Returns the number of points in each support of the i-th cell.
 *
 * ON ENTRY :
 *   i         index to a cell in the container;
 *   r         number of different supports.
 *
 * ON RETURN :
 *   length    length[j] is the number of points in the (j+1)-th list
 *             of the supports of cell i, of dimension r. */

int celcon_get_point_in_cell ( int n, int i, int j, int k, double *point );
/*
 * DESCRIPTION :
 *   Returns the k-th point from the j-th list of the i-th cell.
 *
 * ON ENTRY :
 *   n         length of the lifted vectors in the supports;
 *   i         index to a cell in the container;
 *   j         index to a support of the i-th cell;
 *   k         index to a point in the j-th support of the i-th cell.
 *
 * ON RETURN :
 *   point     coordinates of the k-th point of the j-th support of cell i,
 *             of dimension n. */

int celcon_mixed_volume ( int i, int *mv );
/*
 * DESCRIPTION :
 *   Returns in mv the mixed volume of the i-th cell. */

int celcon_set_type_of_mixture ( int r, int *mix );
/*
 * DESCRIPTION :
 *   Sets the number of different supports to r and the number of
 *   occurrences of the (i+1)-th support to mix[i], mix has dimension r. */

int celcon_append_lifted_point ( int n, int i, double *point );
/*
 * DESCRIPTION :
 *   Appends the point (of dimension n) to the i-th support. */

int celcon_append_mixed_cell
             ( int n, int r, int k, int *labels, double *normal );
/* 
 * DESCRIPTION :
 *   Appends a mixed cell to the cells container.
 *
 * ON ENTRY :
 *   n         length of the lifted vectors in the supports;
 *   r         number of different supports;
 *   k         length of the vector of labels;
 *   labels    the total number of points in the supports in labels[0],
 *             the number of points in the j-th support is in labels[j],
 *             labels[1+r+j] contains the labels of the points,
 *             the dimension of the labels is k;
 *   normal    coordinates of the inner normal to the cell,
 *             of dimension n. */

int celcon_retrieve_mixed_cell
             ( int n, int r, int i, int *labels, double *normal );
/*
 * DESCRIPTION :
 *   Retrieves the i-th mixed cell from the container.
 *
 * ON ENTRY :
 *   n         length of the lifted vectors in the supports;
 *   r         number of different supports;
 *   i         index to a mixed cells in the cells container.
 * 
 * ON RETURN :
 *   labels    the total number of points in the supports in labels[0],
 *             the number of points in the j-th support is in labels[j],
 *             labels[1+r+j] contains the labels of the points;
 *   normal    coordinates of the inner normal to the cell,
 *             of dimension n. */

int celcon_create_random_coefficient_system ( void );
/*
 * DESCRIPTION :
 *   Creates a random coefficient system using the type of mixture
 *   and the supports in the cells container. */

int celcon_read_random_coefficient_system ( void );
/*
 * DESCRIPTION :
 *   Prompts the user for a random coefficient system 
 *   and stores it into the cells container. */

int celcon_write_random_coefficient_system ( void );
/*
 * DESCRIPTION :
 *   Writes the random coefficient system to standard output. */

int celcon_copy_into_systems_container ( void );
/*
 * DESCRIPTION :
 *   Copies the random coefficient system from the cells container
 *   into the systems container. */

int celcon_copy_from_systems_container ( void );
/*
 * DESCRIPTION :
 *    Copies the system from the systems container as a random coefficient
 *    system into the cells container. */

int celcon_create_polyhedral_homotopy ( void );
/*
 * DESCRIPTION :
 *   Based on the lifting and the random coefficient system, the polyhedral
 *   homotopy to solve the random coefficient system is created. 
 *   This function also initializes the internal data structures to store
 *   the solutions of start and target systems.
 *
 * REQUIRED :
 *   The lifted supports and the random coefficient system are defined. */

int celcon_solve_start_system ( int k, int *mv );
/*
 * DESCRIPTION :
 *   Solves the start system corresponding to the k-th mixed cell,
 *   returns in mv the number of solution found, which must equal
 *   the mixed volume of the k-th mixed cell.
 *
 * REQUIRED :
 *   The creation of the polyhedral homotopy terminated successfully. */

int celcon_track_solution_path ( int k, int i, int otp );
/*
 * DESCRIPTION :
 *   Tracks a solution path starting at the i-th solution of the k-th cell,
 *   with output level for the path trackers defined by the value of otp.
 *   A target solution corresponding to the k-th cell is added on return.
 *
 * REQUIRED :
 *   The start system corresponding to the k-th mixed cell is solved. */

int celcon_copy_target_solution_to_container ( int k, int i );
/*
 * DECRIPTION :
 *   Copies the i-th target solution corresponding to the k-th mixed cell
 *   to the solutions container. */

int celcon_permute_system ( void );
/*
 * DESCRIPTION :
 *   Permutes the system in the container corresponding to the permutation
 *   used to compute the mixed-cell configuration. */

int celcon_clear_mixed_cell_configuration ( void );
/*
 * DESCRIPTION :
 *   Clears the cells container. */