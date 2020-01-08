%% Define parameters. パラメーターの定義
NUM_SENSORS = 2; % the number of sensor nodes. Sensors have a antenna. So NUM_SENSORS is the total number of antenna.
NUM_RELAY_ANTENNA = 3; % the number of relay's antennas. This variable is scalar or list.
NUM_CYCLE = 1e4;  %the number ofof cycle.
ASSIGN_METHOD = ["POWER", "GSC_E"];   % antenna assignment method. The first element is "FIXITY" or "POWER" and second element is "GSC_I" or "GSC_E".

CARRIER_FREQUENCY = 920e6; % carrier frequency [Hz]
TRANSMISSION_POWER_dBm = 10; % transmission power expressed by dBm. [dBm]
ANTENNA_GAIN_dBi = 2;   % antenna fain [dBi]
DISTANCE_SENSOR_RELAY = 10; % distance between each Sensor and Relay. [m]
DISTANCE_RELAY_DESTINATION = 10;  % distance between Relay and Destination. [m]
SYMBOLRATE = 1 / CARRIER_FREQUENCY;   % symbol rate [sps]
NOISE_POWER_dBm = -174 + pow2db(SYMBOLRATE);  % noise power at 300[K].
% UNIT_SLOT_TIME = 1e-6;  % unit slot time [s]
HARVESTING_EFFICIENCY = 0.8;   % harvesting efficiency
LIGHT_VELOCITY = 3e8;   % light velocity [m/s]
THRESHOLD_SNR_dB = 10;  % threshold of SNR [dB]

%% calculate
propLoss_SR = freeSpaceLoss(CARRIER_FREQUENCY, DISTANCE_SENSOR_RELAY);   % free space loss between each sensor and relay.
propLoss_RD = freeSpaceLoss(CARRIER_FREQUENCY, DISTANCE_RELAY_DESTINATION);  % free space loss between relay and destination.
receptionPower_R_dBm = TRANSMISSION_POWER_dBm + ANTENNA_GAIN_dBi + ANTENNA_GAIN_dBi -pow2db(propLoss_SR);   % reception power [dBm]
symbolDuration = 1 / SYMBOLRATE; % time per a symbol [s]

