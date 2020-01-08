function output = dbm2pow(input_dBm)
  %% transform dBm into linear value.
  % Input:
  %   input_dBm : [dBm]
  % Output:
  %   output : [linear value]
  input_dBm(~(abs(input_dBm) >= 0)) = Inf;
  output = db2pow(input_dBm - 30);
  output(output == Inf) = NaN;
end
