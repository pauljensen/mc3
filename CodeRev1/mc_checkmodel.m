%PURPOSE:
%Takes in either a model from SBML format or from a spreadsheet and reports
%the warnings within the model

%INPUTS:
%fileType - Either 'SBML' or 'xls' corresponding to SBML format and
%spreadsheet respectively
%checkType - Says what check to run: FBA, Kernel, or both
%checkType may only be 0, 1, or 2
%   0 corresponds to only Kernel matrix tests
%   1 corresponds to only FBA related tests
%   2 corresponds to both Kernel and FBA tests
%fileName - The Excel book file name

%The following inputs are used for xls format
%1.stoichiometricTab - Sheet name within the Excel book for stoichiometric matrix includes reversible reaction array
%2.exchangeReactionsTab - Sheet name within the Excel book for exchange reactions
%3.externalMetabolitesTab (optional) - Sheet name within the Excel book for external metabolites
%4.boundsTab(optional) - Sheet name within the Excel book for Upper and Lower bounds

%For SBML format, the forth argument is:
%1.exchangeReactions - exchange reactions IDs
%2.externalM - external metabolites IDs
%3.OverrideUserBounds - functions use the user specified boundaries

%Using a COBRA Toolbox model
%If you have already loaded a model for use with the COBRA Toolbox,
%you can pass the model structure directly to this function:
%   mc_checkmodel('cobra',checkType,model)
%where MODEL is a struct.

%examples:
% mc_checkmodel('xls',1,'Model.xls','S','exchangeR',[], 'bounds')
% mc_checkmodel('xls',1,'Model.xls','S','exchangeR')
% mc_checkmodel('SBML', 2, 'SBML File', 'OverrideUserBounds')
% mc_checkmodel('SBML', 2, 'SBML File')

%OUTPUTS:
%SCM - List of indecies of D1 dead end non-exchange metabolites 
%DEM - List of indecies of D2 dead end non-exchange metabolites 
%ZFR - List of indecies of reactions that always have zero flux based on FVA
%UR  - List of reversible reactions that carry flux in one direction based on FBA
%CR  - List of coupled reactions
%RCR - List of coupled reactions that cannot carry a non-zero flux without violating irreversibility on kernel

%If called with only a single output, retuns a struct with the above
%fields.

function [SCM, DEM, ZFR, UR, CR, RCR] = mc_checkmodel(fileType, checkType, fileName, varargin)
    SCM = [] ; DEM = []; ZFR = []; UR = []; CR = []; RCR = []; 
    if nargin < 3
        error('Please enter file type, check type and filename');
    end
    if(strcmp(fileType, 'SBML'))
        if isempty(varargin)
            [S, Revs, ExcR, Lb, Ub] = util_readModelFromSBML(fileName, [], [], 0);
        elseif length(varargin)==1
            [S, Revs, ExcR, Lb, Ub] = util_readModelFromSBML(fileName, varargin{1}, [], 0);
        elseif length(varargin)==2
            [S, Revs, ExcR, Lb, Ub] = util_readModelFromSBML(fileName, varargin{1}, varargin{2}, 0);
        elseif length(varargin)==3
            if (strcmp(varargin{3}, 'OverrideUserBounds') == 1)
                [S, Revs, ExcR, Lb, Ub] = util_readModelFromSBML(fileName, varargin{1}, varargin{2}, 1);
            else
                [S, Revs, ExcR, Lb, Ub] = util_readModelFromSBML(fileName, varargin{1}, varargin{2}, 0);
            end
        end
    elseif(strcmp(fileType, 'xls'))
        if length(varargin)==2
            [S, Revs, ExcR, ExcM, Lb, Ub] = util_readModelFromSpreadsheet(fileName, varargin{1}, varargin{2}, [], []);
        elseif length(varargin)==3
            [S, Revs, ExcR, ExcM, Lb, Ub] = util_readModelFromSpreadsheet(fileName, varargin{1}, varargin{2}, varargin{3}, []);
        elseif length(varargin)==4
            [S, Revs, ExcR, ExcM, Lb, Ub] = util_readModelFromSpreadsheet(fileName, varargin{1}, varargin{2}, varargin{3}, varargin{4});
        end
    elseif strcmp(fileType,'cobra')
        % fileName is a Cobra model structure
        cobra = fileName;
        assert(isstruct(fileName), 'third argument must be a Cobra Toolbox model struct');
        ExcR = cobra.rxns(sum(abs(cobra.S),1) == 1);
        [S, Revs, Lb, Ub] = deal(cobra.S, cobra.rev, cobra.lb, cobra.ub);
    else
        error('Please enter either ''SBML'' or ''xls'' for fileType');
    end
    fprintf('Statistics:\n');
    fprintf('%d reactions\n', size(S, 2));
    fprintf('%d reversible reactions\n', length(find(Revs==1)));
    fprintf('%d exchange reactions\n', length(ExcR));
    fprintf('%d metabolites\n', size(S, 1));

    [Snew, Rev_pair] = util_splitReversibleReactions(S, Revs);
    [SCM, DE] = mc_calculateDeadEndMetabolites(Snew, Rev_pair);
    DEM = [SCM; DE];
    fprintf('\nConnectivity Checks:\n');
    fprintf('%d dead-end metabolites (SCM)\n', length(SCM));
    fprintf('%d dead-end metabolites (DEM)\n', length(DEM));
   
    if(checkType == 0 || checkType == 2)
        fprintf('\nBasis-based checks:\n');
        [K] = util_calculateKernelMatrix(Snew);
        [RCR, CR] = mc_findInconsistentCoupling(K, Revs);
        [ZFRkernel] = mc_findZeroFluxReactionsKernel(K, Rev_pair);
        fprintf('%d coupled Reactions (CR)\n', size(CR, 1));    
        fprintf('%d inconsistent coupling (RCR)\n', size(RCR, 1));    
    end
    if(checkType == 1 || checkType == 2)
        fprintf('\nFVA-based checks:\n');
        [min, min_status, max, max_status] = util_minMaxAnalysis(S, Lb, Ub);
        [ZFR] = mc_zeroFluxReactionFVA(min, min_status, max, max_status);
        fprintf('%d zero flux reactions (ZFR)\n', length(ZFR));    
        [UR] = mc_unsatisfiedReversibilityFVA(min, min_status, max, max_status, Revs);
        fprintf('%d unsatisfied reversible reactions (UR) \n', length(UR));    
    end
    if (checkType ~= 0 && checkType ~= 1 && checkType ~= 2)
        error('Please enter either 0, 1, or 2 for checkType');
    end
    
    if nargout <= 1
        SCM = struct('SCM',SCM,'DEM',DEM','ZFR',ZFR,'UR',UR,'CR',CR,'RCR',RCR);
    end
    
   