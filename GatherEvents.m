function [SliceBeforeEvents, SliceBeforeVector,SliceMinEvents,SliceAfterVector,SliceAfterEvents,SliceBeforeSim,SliceMinSim,SliceAfterSim,SliceBeforeROI,SliceMinROI,SliceAfterROI] = GatherEvents(SliceE,SliceCellBinned,SliceMaxRange,SliceMinRange,SliceAfterMax,SliceKeptROI)

SliceBeforeEvents = cell([10,1]);
SliceBeforeVector = cell([length(SliceE),1]);
SliceMinVector = cell([length(SliceE),1]);
SliceMinEvents = cell([10,1]);
SliceAfterVector = cell([length(SliceE),1]);
SliceAfterEvents = cell([10,1]);
SliceBeforeSim = cell([10,1]);
SliceMinSim = cell([10,1]);
SliceAfterSim = cell([10,1]);
% SliceBeforeTotal = cell([10,1]);
% SliceAfterTotal = cell([10,1]);
% SliceMinTotal = cell([10,1]);
for i = 1:length(SliceCellBinned)
    if isempty(SliceCellBinned{i,1})
        continue
    else
        for c = 2:length(SliceCellBinned{i,1})
            if isempty(SliceCellBinned{i,1}{c,1})
                continue
            else
                for d = 1:length(SliceCellBinned{i,1}{c,1})
                    if isnan(SliceCellBinned{i,1}{c,1}{d,1})
                        continue
                    else

                        SliceBeforeVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceMaxRange{i,1}{c,1}(1,1):SliceMaxRange{i,1}{c,1}(2,1),:),1);
                        SliceBeforeEvents{c,1}(i,d) = sum(SliceBeforeVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});

                        SliceMinVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceMinRange{i,1}{c,1}(1,1):SliceMinRange{i,1}{c,1}(2,1),:),1);                
                        SliceMinEvents{c,1}(i,d) = sum(SliceMinVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        
                        SliceAfterVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceAfterMax{i,1}{c,1}(1,1):SliceAfterMax{i,1}{c,1}(2,1),:),1);
                        SliceAfterEvents{c,1}(i,d) = sum(SliceAfterVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        
                    end
                end
                SliceEventTemp = sum(SliceBeforeVector{i,1}{c,1},1);
                SliceBeforeROI(c,i) = mean(SliceEventTemp);
                
                SliceEventTemp = sum(SliceMinVector{i,1}{c,1},1);
                SliceMinROI(c,i) = mean(SliceEventTemp);
                
                SliceEventTemp = sum(SliceAfterVector{i,1}{c,1},1);
                SliceAfterROI(c,i) = mean(SliceEventTemp);
                
                SliceBeforeSimTemp = pdist(SliceBeforeVector{i,1}{c,1},'hamming');
                SliceBeforeSim{c,1}(i,1) = nanmean(SliceBeforeSimTemp);
                
                SliceMinSimTemp = pdist(SliceMinVector{i,1}{c,1},'hamming');
                SliceMinSim{c,1}(i,1) = nanmean(SliceMinSimTemp);
                
                SliceAfterSimTemp = pdist(SliceAfterVector{i,1}{c,1},'hamming');
                SliceAfterSim{c,1}(i,1) = nanmean(SliceAfterSimTemp);;
            end
            
        end
    end
end