%PURPOSE:
%Uses Flux Balance Analysis to find the reactions that have zero flux
%through them

%INPUTS:
%min - List of all the minimized fluxes through each reaction
%min_status - List of the status codes from GLPK for each minimization
%problem
%max - List of all the maximized fluxes through each reaction
%max_status - List of the status codes from GLPK for each maximization
%problem

%OUTPUTS:
%ZeroFluxFBA - List of the indecies of the reactions that have zero flux
%through them

%PRECONDITIONS:
%-min must be in the form of a single column with one row for each reaction
%-min_status must be in the form of a single column with one row for each
%reaction
%-max must be in the form of a single column with one row for each reaction
%-max_status must be in the form of a single column with one row for each 
%reaction
%-min, max, min_status, and max_status must all have the same number of
%rows

%POSTCONDITIONS:
%-ZeroFluxFBA will contain a list of the indecies of the reactions that
%have zero flux through them in the form of a single column with each row
%containing a single index

function [ZeroFluxFBA] = mc_zeroFluxReactionFVA(minFBA, min_status, maxFBA, max_status)
    ZeroFluxFBA = [];
    for i = 1:size(minFBA, 2)
        if(min_status(i) == 5 && max_status(i) == 5 && minFBA(i) == 0 && maxFBA(i) == 0)
           ZeroFluxFBA = [ZeroFluxFBA ; i];
        end
    end
end