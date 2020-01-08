%% Initialization 初期化
clear
close all
clc

%% Define parameters. パラメーターの定義
defineParameters;;

%% Read csv file. BinaryMatrix, channelMatrixSR, channelMatrixRD
% binary matrix
binaryMatrix = csvread('datasets/binaryData.csv');
binaryMatrix = binaryMatrix.';  % [n_sensors, n_cycle]

% channel matrix between Sensors and Relay
channelMatrixSR = csvread('datasets/channelMatrixSR.csv'); % [n_relay_antenna x n_cycle, n_sensors]

% channel matrix between Relay and Destination
channelMatrixRD = csvread('datasets/channelMatrixRD.csv'); % n_destination_antenna_data x n_cycle, n_relay_antenna_data]

%% Define data csv Matrix to store.
mBinaryMatrix_R = NaN(NUM_CYCLE, NUM_SENSORS); % [NUM_CYCLE, NUM_SENSORS]
mPassedSignal_SR = NaN(NUM_CYCLE, NUM_RELAY_ANTENNA); % [NUM_CYCLE, NUM_RELAY_ANTENNA]
mNoiseMatrix_R = NaN(NUM_CYCLE, NUM_RELAY_ANTENNA); % [NUM_CYCLE, NUM_RELAY_ANTENNA]
mAntenna4dataMatrix = NaN(NUM_CYCLE, NUM_SENSORS); % [NUM_CYCLE, NUM_SENSORS]
mHarvestedEnergyVec = NaN(NUM_CYCLE, 1); % [NUM_CYCLE, 1]
mChannelMatrix_SR = NaN(NUM_CYCLE * NUM_RELAY_ANTENNA, NUM_SENSORS)
mChannelMatrix_RD = NaN(NUM_CYCLE * NUM_SENSORS, NUM_SENSORS)
mProcessedSignalMatrix_SR = NaN(NUM_CYCLE, NUM_SENSORS);
mProcessedNoiseMatrix_R = NaN(nUM_CYCLE, NUM_SENSORS);

%% cycle part
for n_cycle = 1:NUM_CYCLE
  %% process in Sensors
  % Generate binary.
  binaryArray = binaryMatrix(1:NUM_SENSORS, n_cycle);  % [NUM_SENSORS, 1]

  % Modulate binary data using BPSK.
  baseBandSignalVec_S = modulateBpsk(binaryArray);  % [NUM_SENSOR, 1]

  % Generate fading coefficient of Rayleigh.
  channelMatrix_SR = channelMatrixSR((n_cycle - 1) * NUM_RELAY_ANTENNA + 1:n_cycle * NUM_RELAY_ANTENNA, 1:NUM_SENSOR); % [NUM_RELAY_ANTENNA, NUM_SENSORS]

  % signal after passing into channel between Sensors and Relay
  passedSignalVec_SR = sqrt(dbm2pow(receptionPower_R_dBm)) * channelMatrix_SR * baseBandSignalVec_S; % [NUM_RELAY_ANTENNA, 1] = [NUM_RELAY_ANTENNA, NUM_SENSORS] x [NUM_SENSORS, 1]

  % Generate noise at Relay.
  noiseVec_R = generateNoise(NOISE_POWER_dBm, size(passedSignalVec_SR)); % [NUM_RELAY_ANTENNA, 1]

  % Assign antenna to for data or energy.
  % antenna4data : [NUM_SENSORS]
  % antenna4energy : [n_relay_antenna - NUM_SENSORS]
  [antenna4dataList, antenna4energyList] = assignAntenna(passedSignalVec_SR, NUM_SENSORS, ASSIGN_METHOD);

  % signal processing on receiver side
  processedSignalVec_SR = channelMatrix_SR(antenna4dataList, :) \ passedSignalVec_SR(antenna4dataList); % [NUM_SENSORS, 1]
  processedNoiseVec_R = channelMatrix_SR(antenna4dataList, :) \ noiseVec_R(antenna4dataList); % [NUM_SENSORS, 1]

  % demodulate at Relay
  binaryArray_R = demodulateBpsk(processedSignalVec_SR + processedNoiseVec_R); % [NUM_SENSORS, 1]

  % Relay harvest energy using atenna assign to for energy.
  harvestedEnergy = HARVESTING_EFFICIENCY * symbolDuration * harvestEnergy(passedSignals_SR(antenna4energyList) + noiseVec_R(antenna4energyList);

  % modulate at Relay
  baseBandSignalVec_R = modulateBpsk(binaryArray_R); % [NUM_SENSORS, 1]

  % transform harvested energy into transmission power dBm [dBm]
  transmissionPower_R_dBm = pow2dbm(harvestedEnergy / (symbolDuration * NUM_SENSORS)); % [1, 1]

  % Calculate reception power dBm [dBm]
  receptionPower_D_dBm = transmissionPower_R_dBm + ANTENNA_GAIN_dBi + ANTENNA_GAIN_dBi = pow2db(propLoss_RD); % reception power dBm from Relay to Destination. [dBm]

  % Generate fading coefficient of Rayleigh.
  channelMatrix_RD = channelMatrixRD((n_cycle - 1) * NUM_SENSORS + 1:n_cycle * NUM_SENSORS, 1:NUM_SENSOR); % [NUM_RELAY_ANTENNA, NUM_SENSORS]

  % signal after into channel between Relay and Destination
  passedSignalVec_RD = sqrt(dbm2pow(receptionPower_D_dBm)) * channelMatrix_RD * baseBandSignalVec_R; % [NUM_SENSORS, 1]

  % Generate noise at Destination.
  noiseVec_D = generateNoise(NOISE_POWER_dBm, size(baseBandSignalVec_R)); % [NUM_SENSORS, 1]

  % signal processing on receiver side
  processedSignalVec_RD = channelMatrix_RD \ passedSignalVec_RD; % [NUM_SENSORS, 1] = [NUM_SENSORS, NUM_SENSORS] x [NUM_SENSORS, 1]
  processedNoiseVec_D = channelMatrix_RD \ noiseVec_D; % [NUM_SENSORS, 1] = [NUM_SENSORS, NUM_SENSORS] x [NUM_SENSORS, 1]

  % Demodulate at Destination.
  binaryArray_D = demodulateBpsk(processedSignalVec_RD + processedNoiseVec_D); % [NUM_SENSORS, 1]

  %% Collect each data.
  mBinaryMatrix_R(n_cycle, :) = binaryArray_R.';
  mPassedSignal_SR(n_cycle, :) = passedSignalVec_SR.';
  mNoiseMatrix_R(n_cycle, :) = noiseVec_R.';
  mAntenna4dataMatrix(n_cycle, :) = antenna4dataList;
  mHarvestedEnergyVec(n_cycle) = harvestedEnergy;
  mChannelMatrix_SR((n_cycle - 1) * NUM_RELAY_ANTENNA + 1:n_cycle * NUM_RELAY_ANTENNA, :) = channelMatrix_SR;
  mChannelMatrix_RD((n_cycle - 1) * NUM_SENSORS + 1, :) = channelMatrix_RD;
  mProcessedSignalMatrix_SR(n_cycle, :) = processedSignalVec_SR.';
  mProcessedNoiseMatrix_R(n_cycle, :) = processedNoiseVec_R.';
end
