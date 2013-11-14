%PURPOSE:
%Finds all the reactions that have zero flux based on the kernel matrix

%INPUTS:
%K - The kernel matrix after reversible reactions are split
%Rev_pair - Pairs of indecies corresponding to the forward and reverse
%reactions pairs

%OUTPUTS:
%ZeroFlux - List of indecies of reactions that always have zero flux

%PRECONDITIONS:
%-The kernel matrix is calculated after the reversible reactions are split
%-Rev_pair is the form of two columns, the first column corresponds to the
%forward reactions and the second column corresponds to the reverse
%reactions

%POSTCONDITIONS:
%-ZeroFlux will contain a list of the indecies of the zero flux reactions

function [ZeroFlux] = mc_findZeroFluxReactionsKernel(K, Rev_pair)
    ZeroFlux = [];
    for i = 1:size(Rev_pair,1)
        forward = Rev_pair(i,1);
        backward = Rev_pair(i,2);
        K(forward,:) = K(forward,:) - K(backward,:);
    end
    for i = 1:(size(K,1) - size(Rev_pair,1))
        if max(abs(K(i,:))) < 10^-10
              ZeroFlux = [ZeroFlux ; i];
        end
    end
end