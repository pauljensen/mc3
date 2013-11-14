function [S, Revs, Warnings] = util_readStoichiometricMatrixFromSpreadsheet(fileName, Stoichiometrictab)
    Warnings = '';
    S = xlsread(fileName, Stoichiometrictab);
    Revs = S(size(S, 1), :);
    revnan = find(isnan(Revs));
    if(size(revnan) > 0)
        Warnings = strcat(Warnings, 'There are Non-numbers within the reversibilities array.');
        disp('Error: There are Non-numbers within the reversibilities array.');
    elseif(size(find(Revs == 0)) + size(find(Revs == 1)) < size(Revs, 2))
        Warnings = strcat(Warnings, 'Only 0s and 1s can be contained in the reversibilities array.');
        disp('Error: Only 0s and 1s can be contained in the reversibilities array.');
    end
    S = S(1:size(S,1) - 1, :);
    nanindexes = find(isnan(S));
    if(size(nanindexes) > 0)
       Warnings = strcat(Warnings, 'There are Non-numbers within the stoichiometric spreadsheet.');
       disp('Error: There are Non-numbers within the stoichiometric spreadsheet.');
    end
end