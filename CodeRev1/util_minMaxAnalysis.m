%PURPOSE:
%Runs the Flux Balance Analysis, both minimize and maximize, on each
%reaction contained within the Stoichiometric Matrix

%INPUTS:
%S - The original Stoichiometric Matrix
%vlb - Lower bound array
%vub - Upper bound array

%OUTPUTS:
%min - List of all the minimized fluxes through each reaction
%min_status - List of the status codes from GLPK for each minimization
%problem
%max - List of all the maximized fluxes through each reaction
%max_status - List of the status codes from GLPK for each maximization
%problem

%PRECONDITIONS:
%-S contains the original Stoichiometric Matrix
%-vlb must be in the form of a single column with one row for each reaction
%in S
%-vub must be in the form of a single column with one row for each reaction
%in S
%-For every index in vlb and vub, vlb must be less then or equal to vub,
%Ex: vlb(1) <= Vub(i) must be true

%POSTCONDITIONS:
%-min will contain a list of the minimized fluxes through each reaction in
%the form of a single column and each row's index corresponding to the
%reaction that was minimized
%-min_status will contain a list of the status codes returned by GLPK in the
%form of a single column and each row's index corresponding to the reaction
%that was minimized
%-max will contain a list of the maximized fluxes through each reaction in
%the form of a single column and each row's index corresponding to the
%reaction that was maximized
%-max_status will contain a list of the status codes returned by GLPK in the
%form of a single column and each row's index corresponding to the reaction
%that was maximized

function [minFBA, min_status, maxFBA, max_status] = util_minMaxAnalysis(S, vlb, vub)
    c = zeros(1, size(S, 2));
    for i = 1:size(S, 2)
        c(:) = 0;
        c(i) = 1;
        [f, status] = util_fba(S, 'min', c, vlb, vub);
        minFBA(i) = f;
        min_status(i) = status;
        [f, status] = util_fba(S, 'max', c, vlb, vub);
        maxFBA(i) = f;
        max_status(i) = status;
    end
end