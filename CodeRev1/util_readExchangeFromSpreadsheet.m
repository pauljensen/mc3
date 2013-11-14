function [ExcR, ExcM, Warnings] = util_readExchangeFromSpreadsheet(fileName, ExchangReactionsetab, ExternalMetabolitestab, Warnings)
    % reads exchange reactions
    ExcR = [];
    if ~isempty(ExchangReactionsetab)
        ExcR = xlsread(fileName, ExchangReactionsetab);
        ExcnanR = find(isnan(ExcR));
        if(size(ExcnanR) > 0)
            Warnings = strcat(Warnings, 'Only numbers are allowed in the Exchange Reactions list.');
            disp('Error: Only numbers are allowed in the Exchange Reactions list.');
        elseif(size(find(ExcR < 1)) > 0)
            Warnings = strcat(Warnings, 'Only reactions numbered 1 and greater can be contained in the Exchange Reactions list.');
            disp('Error: Only reactions numbered 1 and greater can be contained in the Exchange Reactions list.');
        end
    end
    % reads exchange metabolites
    ExcM = [];
    if ~isempty(ExternalMetabolitestab)
        ExcM = xlsread(fileName, ExternalMetabolitestab);
        ExcnanM = find(isnan(ExcM));
        if(size(ExcnanM) > 0)
            Warnings = strcat(Warnings, 'Only numbers are allowed in the Exchange Metabolites list.');
            disp('Error: Only numbers are allowed in the Exchange Metabolites list.');
        elseif(size(find(ExcM < 1)) > 0)
            Warnings = strcat(Warnings, 'Only reactions numbered 1 and greater can be contained in the Exchange Metabolites list.');
            disp('Error: Only reactions numbered 1 and greater can be contained in the Exchange Metabolites list.');
        end
    end
end