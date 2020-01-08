function output = generateNoise(noisePower_dBm, arraySize)
  %% Generate noise vector.
  % Input:
  %   noisePower_dBm : noise power dBm [dBm]
  %   arraySize : array size [n_row n_col]
  % Output:
  %   output : noise vector [W] [n_row, n_col]
  output = (randn(arraySize) + 1j * (randn(arraySize))) * sqrt(dbm2pow(noisePower_dBm) / 2); % [arraySize]
end
