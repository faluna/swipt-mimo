function [dataAntennaList, energyAntennaList] = assignAntenna(signalVec, nDataAntenna, methodList)
  %% assign relay's antenna to for data or energy.
  % Input:
  %   signalVec : evaluated signal vector [n_signalVec, 1]
  %   nDataAntenna : the number of antenna at using data transfer
  %   methodList : method list ["POWER" or "FIXITY", "GSC_I", "GSC_E"]
  % Output:
  %   dataAntennaList : [1, n_data_antenna]
  %   energyAntennaList : [1, n_signal - n_data_antenna]
  nSignalVec = length(signalVec);
  switch methodList(1)
    % FIXITY
    case "FIXITY"
      dataAntennaList = 1:1:nDataAntenna;
      energyAntennaList = nDataAntenna + 1:1:nSignalVec;

    % POWER
    case "POWER"
      signalPowerVec = abs(signalVec).^2;
      [sortedPowerVec, sortedPowerIndex] = sort(signalPowerVec, 'descend');

      switch methodList(2)
        case "GSC_I"
          dataAntennaList = sortedPowerIndex(1:nDataAntenna);
          energyAntennaList = sortedPowerIndex(nDataAntenna+1:nSignalVec);
        case "GSC_E"
          energyAntennaList = sortedPowerIndex(1:nSignalVec - nDataAntenna);
          dataAntennaList = sortedPowerIndex(nSignalVec - nDataAntenna + 1:length)
      end
  end
end
