function output = generateRayleighFading(n_row, n_col)
  %% Generate Coefficient matrix of Rayleigh fading.
  % Input:
  %   n_row: the number of row
  %   n_col: the number of column
  % Output:
  %   output: matrix [n_row, n_col]
  output = (randn(n_row, n_col) + 1j * (randn(n_row, n_col)));
end
