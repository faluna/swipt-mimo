function output = demodulateBpsk(signalVec)
  %% Demodulate signal.
  % Input:
  %   signalVec : [n_signalVec, 1]
  % Output:
  %   output : [n_signalVec, 1]
  phaseVec = abs(angle(signalVec));
  output = ((pi / 2) <= phaseVec);
end
