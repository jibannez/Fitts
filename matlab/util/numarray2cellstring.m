function c = numarray2cellstring(a)
%function c=numarray2cellstring(a)
%INPUT
% a - vector of number ,e.g. [1 2 3 4.5];
%
%OUTPUT
% c - cell with string representation of the number is input array.
%EXAMPLE
% a=[1 2 4 6 -12];
% c=numarray2cellstring(a);
% c = 
%
%   '1'    '2'    '4'    '6'    '-12'
%
c=cell(size(a));
for i=1:length(a) 
    c{i}=num2str(a(i));
end
end