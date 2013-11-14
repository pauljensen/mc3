%PURPOSE:
%Checks to see if any of the reactions marked as reversible have either the
%forward or reverse reaction as a zero flux reaction

%INPUTS:
%K - The kernel matrix after reversible reactions are split
%Rev_pair - Pairs of indecies corresponding to the forward and reverse
%reactions pairs

%OUTPUTS:
%irreversible - List of indecies of the forward reaction that should not
%be marked reversible
%direction - Direction the reaction should be after being marked
%irreversible

%PRECONDITIONS:
%-The kernel matrix is calculated after the reversible reactions are split
%-Rev_pair is the form of two columns, the first column corresponds to the
%forward reactions and the second column corresponds to the reverse
%reactions

%POSTCONDITIONS:
%-irreversible will contain a list of indecies of the forward that is
%incorrectly marked as reversible
%-direction will contain a list of the directions, either forward or
%reverse for each reaction in irreversible
%-The indecies of the irreversible list corresponds to the same index of
%the direction list, Example: irreversible(1) has the direction stored in
%direction(1)

function [irreversible, direction] = mc_unsatisfiedReversibilityKernel(K, Rev_pair)
irreversible = [];
direction = [];
for i = 1:size(Rev_pair, 1)
    if (all(K(Rev_pair(i, 1), :) == 0) && any(K(Rev_pair(i, 2), :)))
        irreversible = [irreversible ; Rev_pair(i, 1)];
        direction = [direction ; 'Reverse'];
    elseif (all(K(Rev_pair(i, 2), :) == 0) && any(K(Rev_pair(i, 1), :)))
        irreversible = [irreversible ; Rev_pair(i, 1)];
        direction = [direction ; 'Forward'];
    end
end

