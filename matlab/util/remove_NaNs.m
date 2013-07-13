function data = remove_NaNs(data)
    for i=1:size(data,2)
        d=data(:,i);
        dn=isnan(d);
        if ~isempty(dn)
            d(dn)=nanmean(d);
            data(:,i)=d(:);
        end
    end
end