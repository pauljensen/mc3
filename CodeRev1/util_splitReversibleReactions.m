%PURPOSE:
%Splits the reversible reactions into a forward and reverse reaction and
%adds the reverse to the end of the Stoichiometric Matrix

%INPUTS:
%S - The original Stoichiometric Matrix
%Revs - Reversibility array

%OUTPUTS:
%Snew - The new Stoichiometric Matrix containing both forward and reverse
%reactions
%Rev_pair - Pairs of indecies corresponding to the forward and reverse
%reactions pairs

%PRECONDITIONS:
%-S is the original Stoichiometric Matrix
%-Revs is a single row with a column for each reaction
%-Revs contains 0s or 1s, 0s corresponding to non-reversible reaction and 
%1s corresponding to reversible reactions

%POSTCONDITIONS:
%-Snew will contain the new Stoichiometric matrix with both forward and
%reverse reactions included
%-Rev_pair will contain 2 columns with each row corresponding to a pair of
%indecies of the forward and reverse reactions
%-Rev_pair's first column is associated with the index of the forward 
%reaction and the second column contains the index of the reverse reaction

function [Snew, Rev_pair] = util_splitReversibleReactions(S, Revs)
    revindex = find(Revs == 1);
    oldsize = size(S, 2);
    newsize = size(S, 2) + length(revindex);
    Snew = S;
    Snew(:, oldsize+1:newsize) = -Snew(:, revindex);
    Rev_pair = [];
    for i = 1:length(revindex)
        Rev_pair = [Rev_pair ; revindex(i) oldsize+i];
    end
end