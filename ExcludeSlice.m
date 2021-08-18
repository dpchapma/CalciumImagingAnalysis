function [ShamE,TBIE] = ExcludeSlice(ShamData,ShamKeptROI,TBIData,TBIKeptROI)

for i = 1:length(ShamData)
    for c = 1:length(ShamData{i,1})
        if length(ShamKeptROI{i,1}{c,1})<3
            ShamE{i,1}{c,1} = [];
        else
            ShamE{i,1}{c,1} = ShamData{i,1}{c,1};
        end
    end
end
 
for i = 1:length(TBIData)
    for c = 1:length(TBIData{i,1})
        if length(TBIKeptROI{i,1}{c,1})<3
            TBIE{i,1}{c,1} = [];
        else
            TBIE{i,1}{c,1} = TBIData{i,1}{c,1};
        end
    end
end