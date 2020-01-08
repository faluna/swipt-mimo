function output = harvestFrom(signalVec)
  %% Harvest energy from signalVec
  % Input:
  %   signalVec : [n_signalVec, 1]
  % Output :
  %   output : harvested energy [1, 1]
  output = sum(abs(signalVec).^2);
end
