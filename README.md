# root-finder
Matlab modified zero-in program for root finding, utilizing a combination of Bisection and Inverse Quadratic Interpolation.
# Modified Zeroin Root-Finding Algorithm

## Overview
This MATLAB implementation combines the Bisection method (for reliability) and Inverse Quadratic Interpolation (IQI, for faster convergence) to find roots of nonlinear equations. The algorithm is optimized to minimize function evaluations while maintaining high rate of convergence.

## Key Features
- **Hybrid Approach**: Switches between IQI and bisection based on convergence behavior
- **Efficient**: Typically finds roots in ≤25 function evaluations
- **Robust**: Handles edge cases with safety checks and fallback to bisection
- **Precise**: Converges to within 1e-7 tolerance (adjustable via parameters)

## Algorithm Details
The method follows this general workflow:
1. Initialize with interval [a,b] where f(a)*f(b)<0
2. Attempt IQI using three points (a, b, midpoint)
3. If IQI fails (point outside interval or slow convergence), perform bisection
4. Repeat until either:
   - |f(x)| < func_tol (function value tolerance)
   - |b-a| < root_tol (interval width tolerance)

## Usage
```matlab
function [root, info] = modifiedzeroinn(func, Int, params)
% INPUTS:
%   func   - Function handle (e.g., @(x) x^2-2)
%   Int    - Struct with fields a and b defining interval [a,b]
%   params - Struct with tolerance fields:
%            .root_tol - Interval width tolerance
%            .func_tol - Function value tolerance
%
% OUTPUTS:
%   root   - Found root approximation
%   info   - Struct with diagnostic information:
%            .flag       - 0 (success) or 1 (failure)
%            .func_evals - Number of function evaluations
