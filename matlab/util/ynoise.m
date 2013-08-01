function [ynoise] = ynoise(t, y, options)
%
% [ynoise] = ynoise(t, y, options, cfg)
%
persistent tnoise;
if isempty(tnoise), tnoise=0; end

tnoise=tnoise+1;

if ~mod(tnoise,2)
    ynoise = sqrt(options.Q).*randn(size(options.Q));
else
    ynoise = 0;
end


