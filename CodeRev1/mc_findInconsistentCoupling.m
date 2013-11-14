%PURPOSE:
%Finds the inconsistent coupling

%INPUTS:
%K - The Kernel matrix after the reversible reactions are split into
%forward and reverse reactions
%Revs - The reversibility array
%ZeroFlux - List of indecies of reactions that always have zero flux

%OUTPUTS:
%inconsistent - The pairs of inconsistent coupling pairs
% coupledReactions- List of coupled reactions

%PRECONDITIONS:
%-K is the Kernel matrix calculated after the reversible reactions are
%split into forward and reverse reactions
%-Revs is a single row with a column for each reaction
%-Revs contains 0s or 1s, 0s corresponding to non-reversible reaction and 
%1s corresponding to reversible reactions
%-ZeroFlux contains a list of the indecies of the zero flux reactions

%POSTCONDITIONS:
%-inconsistent will conatin the pairs of inconstistent irreversible
%reactions in the form of two columns each row representing a pair

function [inconsistent, coupledReactions] = mc_findInconsistentCoupling(K, Revs)
Revsindex = find(Revs == 0);
inconsistent = []; coupledReactions = [];
numKcols = size(K, 2);
for i = 1:length(Revsindex)
    for j = i+1:length(Revsindex)
        bFlag = true;
        a = [];
        for col = 1:numKcols
            if (K(Revsindex(i), col)~=0 && K(Revsindex(j), col)~=0)
                a(col) = K(Revsindex(i), col)/K(Revsindex(j), col);
            elseif (K(Revsindex(i), col)==0 && K(Revsindex(j), col)==0)
                a(col) = 0;
            else
                bFlag = false;
                break
            end
        end
        if (~isempty(a))
            a(a==0) = [];
        end
        if (~isempty(a) && all(a==a(1)) && bFlag == true)
                coupledReactions = [coupledReactions; Revsindex(i) Revsindex(j)];
            if a(1)<0
                inconsistent = [inconsistent; Revsindex(i) Revsindex(j)];
            end
        end
    end
end
end