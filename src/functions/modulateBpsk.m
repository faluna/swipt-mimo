%% Modulate binary using BPSK.
function output = modulateBpsk(binary)
% Input:
%   binary: binary data
% Output:
%   output: mokulated signal
  phase = data * pi;
  output = (exp(1j*phase));
end
