function output = pow2dbm(linearValue)
  %% transform linear value to dBm.
  % Input:
  %   linearValue : [W]
  % Output:
  %   output : [dBm]
  linearValue(~(linearValue >= 0)) = Inf;
  output = pow2db(linearValue * 1e3);
  output(output == Inf) = NaN;
end
