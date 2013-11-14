%PURPOSE: 
%Calculates the null space kernel matrix

%INPUTS:
%S - The Stoichiometric Matrix after the reactions are split

%OUTPUTS:
%K - Null space kernel matrix

%PRECONDITIONS:
%-Stoichiometric matrix must be in the format rows are metabolites and
%columns are reactions
%-The stoichiometric matrix may only contain a 1, 0, or -1
%-The reversibilites array is not part of the Stoichiometric Matrix

%POSTCONDITIONS:
%-K contains the null space kernel matrix
%-Kernel matrix is a reactions x(by) n matrix
%-The rows in the kernel matrix represent reactions and columns represent a
%flux vector

function [K] = util_calculateKernelMatrix(S)
    K = null(S, 'r');
end