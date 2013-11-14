function [Lb, Ub, Warnings] = util_readBoundsFromSpreadsheet(fileName, Boundstab, Warnings)
    Bounds = xlsread(fileName, Boundstab);
    Boundsnan = find(isnan(Bounds));
    if(size(Boundsnan) > 0)
        Warnings = strcat(Warnings, 'Only numbers are allowed in the Bounds array.');
        disp('Error: Only numbers are allowed in the Bounds array.');
    end
    Lb = Bounds(:, 1);
    Ub = Bounds(:, 2);
end