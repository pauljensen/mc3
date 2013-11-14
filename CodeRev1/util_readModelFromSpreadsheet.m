%PURPOSE: 
%Reads in Stoichiometric matrix, exchange reactions, and lower bounds for an xls model

%INPUTS:
%fileName - The Excel book file name
%Stoichiometrictab - Sheet name within the Excel book for stoichiometric
%matrix includes reversible reaction array
%ExchangeReactionstab - Sheet name within the Excel book for exchange reactions
%ExternalMetabolitestab - Sheet name within the Excel book for exchange metabolites
%Boundstab - Sheet name within the Excel book for Upper and Lower bounds

%OUTPUTS:
%S - Stoichiometric matrix
%Revs - Reversible Reactions array
%Exc - Exchang Reaction list
%Lb - Lower Bound array
%Ub - Upper Bound array

%PRECONDITIONS: 
%-Excel book must be in a .xls format
%-Stoichiometric matrix must be in the format rows are metabolites and
%columns are reactions
%-The stoichiometric matrix may only contain a 1, 0, or -1
%-The last row of the Stoichiometric matrix should be the reversible
%reactions array
%-The reversibility row should contain a 0 for non-reversible and a 1 for
%reversible reactions
%-Exchange reactions are entered in a column, each entry is the reaction
%number corresponding to its column in the stoichiometric matrix starting
%at 1
%-Bounds are entered in with Lower Bound in column 1 and Upper Bound in
%column 2 with each row number corresponding to the column number for the
%reactions in the stoichiometric matrix, Unbounded reactions are left blank

%POSTCONDITIONS:
%-S contains the Stoichiometric matrix
%-Revs contains the reversibilities array
%-ExcR contains the exchange reactions
%-ExcM contains the exchange metabolites
%-Lb contains the lower bounds of the reactions
%-Ub contains the upper bounds of the reactions

function [S, Revs, ExcR, ExcM, Lb, Ub] = util_readModelFromSpreadsheet(fileName, Stoichiometrictab, ExchangeReactionstab, ExternalMetabolitestab, Boundstab)
    [S, Revs, Warnings] = util_readStoichiometricMatrixFromSpreadsheet(fileName, Stoichiometrictab);
    [ExcR, ExcM, Warnings] = util_readExchangeFromSpreadsheet(fileName, ExchangeReactionstab, ExternalMetabolitestab, Warnings);
    % removes all external metabolites from S matrix
    for i = length(ExcM):-1:1
        S(ExcM(i), :) = [];
    end
    if isempty(Boundstab)
        Lb = zeros(size(S, 2), 1);
        Lb(Revs==1) = -1000;
        Ub = 1000*ones(size(S, 2), 1);
    else
        [Lb, Ub, Warnings] = util_readBoundsFromSpreadsheet(fileName, Boundstab, Warnings);
    end
    if(size(Lb, 1) ~= size(S, 2) || size(Ub, 1) ~= size(S, 2))
        Warnings = 'Bounds do not meet right specification';
        disp('There must be a single bound row for each reaction within the stoichiometric matrix');
    end
    if(~strcmp(Warnings, ''))
        error('Please fix the above errors');
    end
end