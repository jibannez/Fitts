function merge_pp_matrix(ds)
    ds.dataU=merge_pp_unimatrix(ds.dataU,ds.C);
    ds.dataL=merge_pp_unimatrix(ds.dataL,ds.C);
    ds.dataR=merge_pp_unimatrix(ds.dataR,ds.C);
    ds.dataB=merge_pp_bimatrix(ds.dataB,ds.C);
    ds.dataRel=merge_pp_bimatrix(ds.dataRel,ds.C);
    ds.dataD=merge_pp_unimatrix(ds.dataD,ds.C);
end
    