%PURPOSE:
%Calculates those metabolites that are only produced or consumed in the
%Stoichiometric Matrix

%INPUTS:
%S - Stoichiometric Matrix after reversible reactions are split
%Rev_pair - Pairs of indecies corresponding to the forward and reverse
%reactions pairs

%OUTPUTS:
%DeadEnd1 - List of indecies of dead end non-exchange metabolites with zero
%or 1 connection
%DeadEnd2 - List of indecies of dead end non-exchange metabolites with more
%than 1 connection

%PRECONDITIONS:
%-S is the stoichiometric matrix after splitting the reversible reactions
%-Rev_pair is the form of two columns, the first column corresponds to the
%forward reactions and the second column corresponds to the reverse
%reactions

%POSTCONDITIONS:
%-DeadEnd contains a list of the indecies of dead end metabolites in column
%form

function [DeadEnd1, DeadEnd2] = mc_calculateDeadEndMetabolites(S, Rev_pair)
    DeadEnd1 = [];
    DeadEnd2 = [];
    for i = 1:size(S,1)
        indexP = find(S(i,:)>0);
        indexN = find(S(i,:)<0);
        if (isempty(indexP))
            if (length(indexN)<=1)
                DeadEnd1 = [DeadEnd1; i];
            else
                DeadEnd2 = [DeadEnd2; i];
            end
        elseif (isempty(indexN))
            if (length(indexP)<=1)
                DeadEnd1 = [DeadEnd1; i];
            else
                DeadEnd2 = [DeadEnd2; i];
            end
        else
            if length(indexP)==1 && length(indexN)==1
                t1 = find(indexP == Rev_pair);
                t2 = find(indexN == Rev_pair);
                if t1 == t2+ size(Rev_pair, 1) | t2 == t1+ size(Rev_pair, 1)
                    DeadEnd1 = [DeadEnd1; i];
                end
            end
        end
    end
        