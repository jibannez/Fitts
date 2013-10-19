function res = d4D(tr)
    res=sqrt((tr.ts.Lxnorm-tr.ts.Rxnorm).^2 + (tr.ts.Lvnorm-tr.ts.Rvnorm).^2);
end