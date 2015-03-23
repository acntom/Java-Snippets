% =====================================================================
%> @brief Overload matlabs function use to add objects. Add discretization
%> grid objects (add objects value_list vectors).
%> Dimension of p and q must be the same.
%> @param p discretization grid object
%> @param q discretization grid object
%> @retval r discretization grid object
% =====================================================================
function r = plus( p,q )

    if size(p)==size(q)
        p = Discretization_grid_2D_square(p);
        q = Discretization_grid_2D_square(q);
        new_value_list=p.value_list+q.value_list;
        r = Discretization_grid_2D_square(p.matrix_size_mm,p.grid_size_mm);
        r.value_list=new_value_list;
    else
        error('Add two discretization grid objects: size is different');
    end
end
