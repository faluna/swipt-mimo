%% Generate datasets.

%% Add paths.
addPath;

%% Generate binary.
% binaryMatrix : size = [the number of cycle, the number of Sensors]
binaryMatrix = generateBinary(2e4, 10);

% Write binary matrix. 
csvwrite('datasets/binaryData.csv', binaryMatrix);

%% Genrate channel matrix of rayleigh fading between Sensors and Relay.
% channelMatrixSR : size = [the number of Relay's antenna x the number of cycle, the number of Sensors]
channelMatrixSR = generateRayleighFading(15 * 2e4, 10);

% Write channel matrix
csvwrite('datasets/channelMatrixSR.csv', channelMatrixSR);

%% Genrate channel matrix of rayleigh fading between Relay and Destination.
% channelMatrixRD : size = [the number of Destination's antenna used for data transmission x the number of cycle, the number of Relay's antenna used for data transmission]
channelMatrixRD = generateRayleighFading(10 * 2e4, 10);

% Write channel matrix
csvwrite('datasets/channelMatrixRD.csv', channelMatrixRD);
