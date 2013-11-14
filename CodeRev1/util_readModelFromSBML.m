%PURPOSE:
%Read an SBML file

% Inputs:
% fileName - File name for file to read in (optional)
% exchangeR - list of exchange reactions
% externalM - list of exchange metabolites
% bBound - 1 using default boundaries
%          0 using user defined boundaries

% Outputs:
% S - stoichiometry matrix
% Revs - an array of 0s and 1s
%   0s for irreversible reactions
%   1s for reversible reactions
% Exc - list of exchange reactions
% Lb - lower bounds
% Ub - Upper bounds

function [S, Revs, Exc, Lb, Ub] = util_readModelFromSBML(fileName, exchangeR, externalM, bBounds)
[pathstr, name, ext] = fileparts(fileName);
if isempty(ext)
    fileName = [fileName '.xml'];
end
model = TranslateSBML(fileName);
nMetsAll = length(model.species);
nRxns = length(model.reaction);

nMets = 0;
metNames = [];
if isempty(externalM)
    % species with b at the end of their IDs are external metabolies
    for i = 1:nMetsAll
        if (strcmp(model.species(i).id(end), 'b') == 0)
            nMets= nMets + 1;
            metNames{nMets} = model.species(i).id;
        end
    end
else
    % uses user specified external metabolites
    for i = 1:nMetsAll
        if sum(strcmp(model.species(i).id, externalM)) == 0
            nMets= nMets + 1;
            metNames{nMets} = model.species(i).id;
        end
    end
end
S = zeros(nMets,nRxns);
Revs = zeros(nRxns,1);
Lb = zeros(nRxns,1);
Ub = 1000*ones(nRxns,1);
Exc = [];
for i = 1:nRxns
    reactants = model.reaction(i).reactant;
    for j = 1:length(reactants)
        index = find(strcmp(reactants(j).species,metNames));
        if (~isempty(index))
            S(index,i) = -reactants(j).stoichiometry;
        end
    end
    products = model.reaction(i).product;
    for j = 1:length(products)
        index = find(strcmp(products(j).species,metNames));
        if (~isempty(index))
            S(index,i) = products(j).stoichiometry;
        end
    end
    if (bBounds == 0 && ~isempty(model.reaction(i).kineticLaw))
        temp = model.reaction(i).kineticLaw.parameter(1).value;
        if (~isempty(temp))
            Lb(i, 1) = temp;
        end
        temp = model.reaction(i).kineticLaw.parameter(2).value;
        if (~isempty(temp))
            Ub(i, 1) = temp;
        end
    elseif (bBounds == 0 && isempty(model.reaction(i).kineticLaw))
        bBounds = 1;
    end
    if (model.reaction(i).reversible == 1)
        Revs(i) = 1;
        if (bBounds == 1)
            Lb(i) = -1000;
        end
    end
    if isempty(exchangeR)
        index1 = findstr(model.reaction(i).id, 'R_EX_');
        index2 = findstr(model.reaction(i).id, 'EF');
        if (~isempty(index1) || ~isempty(index2))
            Exc = [Exc; i];
        end
    else
        if sum(strcmp(model.reaction(i).id, exchangeR)) ~= 0
            Exc = [Exc; i];
        end
    end

end
