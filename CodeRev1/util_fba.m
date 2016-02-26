%PURPOSE:
%Runs the Flux Balance Analysis function using GLPK

%INPUTS:
%S - The original Stoichiometric Matrix
%mx - Either 'min' or 'max' depending on whether its a minimization or
%maximization problem
%c - The objective function array
%minimized or maximized
%vlb - Flux lower bound array
%vub - Flux upper bound array

%OUTPUTS:
%f - The minimized or maximized flux of the objective reaction
%status - the status code from GLPK

%PRECONDITIONS:
%-S contains the original Stoichiometric Matrix
%-mx may only contain 'min' or 'max'
%-c is a matrix with one row and a column for each reaction in S
%-c may only contain 0s and 1s
%-vlb must be in the form of a single column with one row for each reaction
%in S
%-vub must be in the form of a single column with one row for each reaction
%in S
%-For every index in vlb and vub, vlb must be less then or equal to vub,
%Ex: vlb(1) <= Vub(i) must be true

%POSTCONDITIONS:
%-f will contain either the maximum or minimum flux through the objective
%reaction if GLPK was able to find an answer, otherwise f will contain 0
%-status will contain an integer from 1-6
%   1 solution is undefined
%   2 solution is feasible
%   3 solution is infeasible
%   4 no feasible solution exists
%   5 solution is optimal
%   6 solution is unbounded

function [f, status] = util_fba(S, mx, c, vlb, vub)
    global MC3_SOLVER
    if isempty(MC3_SOLVER) || strcmpi(MC3_SOLVER,'glpk')
        a = S;
        b = zeros(size(S, 1), 1);
        ctype(1:size(a,1)) = 'S';
        vartype(1:size(a,2)) = 'C';
        if(strcmp(mx, 'max'))
            mx = -1;
        else
            mx = 1;
        end
        [xopt, f, status, extra] = glpk (c, a, b, vlb, vub, ctype, vartype, mx);
    elseif strcmpi(MC3_SOLVER,'gurobi')
        model.A = S;
        model.obj = c;
        model.sense = repmat('=',size(S,1),1);
        model.rhs = zeros(size(S,1),1);
        model.lb = vlb;
        model.ub = vub;
        model.modelsense = mx;
        params.OutputFlag = 0;
        sol = gurobi(model,params);
        gurobi_status = containers.Map( ...
            {'INF_OR_UNBD','SUBOPTIMAL','INFEASIBLE','OPTIMAL','UNBOUNDED'}, ...
            [1 2 3 5 6]);
        if isfield(sol,'objval')
            f = sol.objval;
        else
            f = 0;
        end
        status = gurobi_status(sol.status);
    end
end