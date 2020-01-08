function output = freeSpaceLoss(freq, distance)
  %% Calculate free space loss.
  % Input:
  %   freq: carrier frequency [Hz]
  %   distance: distance between nodes [m]
  % Output:
  %   output: free space loss

  %% Define parameter
  LIGHT_VELOCITY = 3.0e8;   % light velocity [m/s]

  %% main process
  output = ((4 * pi * distance * freq) / LIGHT_VELOCITY).^2;
end
