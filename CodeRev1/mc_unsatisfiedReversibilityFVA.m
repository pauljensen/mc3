%PURPOSE:
%Uses FBA to find the reactions that are marked reversible but can only go
%in one direction

%INPUTS:
%min - List of all the minimized fluxes through each reaction
%min_status - List of the status codes from GLPK for each minimization
%problem
%max - List of all the maximized fluxes through each reaction
%max_status - List of the status codes from GLPK for each maximization
%problem
%Revs - Reversibility array

%OUTPUTS:
%irreversibleFBA - List of indecies of the forward reaction that should not
%be marked reversible
%directionFBA - Direction the reaction should be after being marked
%irreversible

%PRECONDITIONS:
%-min must be in the form of a single column with one row for each reaction
%-min_status must be in the form of a single column with one row for each
%reaction
%-max must be in the form of a single column with one row for each reaction
%-max_status must be in the form of a single column with one row for each
%reaction
%-min, max, min_status, and max_status must all have the same number of
%rows
%-Revs is a single row with a column for each reaction
%-Revs contains 0s or 1s, 0s corresponding to non-reversible reaction and
%1s corresponding to reversible reactions

%POSTCONDITIONS:
%-irreversibleFBA will contain a list of indecies of the forward that is
%incorrectly marked as reversible

function [irreversibleFBA] = mc_unsatisfiedReversibilityFVA(min, min_status, max, max_status, Revs)
revindex = find(Revs == 1);
irreversibleFBA = [];
directionFBA = [];
for i = 1:length(revindex)
    if(min_status(revindex(i)) == 5 && max_status(revindex(i)) == 5 && min(revindex(i)) * max(revindex(i)) >= 0)
        irreversibleFBA = [irreversibleFBA ; revindex(i)];
    end
end
end
