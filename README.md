# root-finder
Matlab modified zero-in program for root finding, utilizing a combination of Bisection and Inverse Quadratic Interpolation. The `modifiedzeroinn` function is designed to be tested with the provided `zeroinntest.m` script.
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

