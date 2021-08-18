function [SliceAv,SliceBinned,SliceCellBinned,SliceMeanBin,SliceMin,SliceMinRange,SliceMaxRange,SliceAfterMax,SlicePower,SliceMinTime,SliceCorr,SliceCorrNoOnes,SliceAvMax,SliceAvMin,CrossCorr,Lags] = BinnedActivity(SliceE,SliceKeptROI,SliceFullAboveThresh,TW)

SliceAv = cell([length(SliceE),1]);
SliceBinned = cell([length(SliceE),1]);
SliceMeanBin = cell([length(SliceE),1]);
SliceMin = cell([length(SliceE),1]);
% SliceMinTime = cell([length(SliceE),1]);
SliceMinRange = cell([length(SliceE),1]);
SliceMaxRange = cell([length(SliceE),1]);
SliceCellBinned = cell([length(SliceE),1]);
SliceAfterMax = cell([length(SliceE),1]);


for i = 1:length(SliceE)
    if isempty(SliceE{i,1})
        i = i + 1;
    end
    for c = 2:length(SliceE{i,1})
        if isempty(SliceE{i,1}{c,1})
            % add logic to catch missing/excluded sessions
            SliceAv{i,1}{c,1} = [];
            SliceBinned{i,1}{c,1} = [];
            continue
        else
            for d = 1:length(SliceE{i,1}{c,1}.stim.Ca.evStartA)
                % take average of above thresh for each session
                SliceAv{i,1}{c,1} = mean(SliceFullAboveThresh{i,1}{c,1},2);
                %                 disp('i')
                %                 disp(i)
                %                 disp(c)
                %                 disp(d)
                % chop network average into bins of the size from the first
                % stim to the second one
                % added some logic to leave out the alst stim as this will
                % go over the time alottment and catch any stims that won't
                % fit
                if d == 1
                    SliceBinned{i,1}{c,1}(:,d) = SliceAv{i,1}{c,1}(SliceE{i,1}{c,1}.stim.Ca.evStartA(d):SliceE{i,1}{c,1}.stim.Ca.evStartA(d+1),1);
                    SliceCellBinned{i,1}{c,1}{d,1} = SliceFullAboveThresh{i,1}{c,1}(SliceE{i,1}{c,1}.stim.Ca.evStartA(d):SliceE{i,1}{c,1}.stim.Ca.evStartA(d+1),:);
                elseif d == 10
                    continue
                else
                    try
                        SliceBinned{i,1}{c,1}(:,d) = SliceAv{i,1}{c,1}(SliceE{i,1}{c,1}.stim.Ca.evStartA(d):SliceE{i,1}{c,1}.stim.Ca.evStartA(d)+length(SliceBinned{i,1}{c,1}(:,1))-1,1);
                        SliceCellBinned{i,1}{c,1}{d,1} = SliceFullAboveThresh{i,1}{c,1}(SliceE{i,1}{c,1}.stim.Ca.evStartA(d):SliceE{i,1}{c,1}.stim.Ca.evStartA(d)+length(SliceBinned{i,1}{c,1}(:,1))-1,:);
                    catch
                        SliceBinned{i,1}{c,1}(:,d) = nan;
                        SliceCellBinned{i,1}{c,1}{d,1} = nan;
                    end
                end
            end
            %Now take the mean and STD of the binned means as well as find the
            %local minima occurring between 0 and 5 seconds
            %sampling rate of 2 kHz
            SliceMeanBin{i,1}{c,1}(:,1) = nanmean(SliceBinned{i,1}{c,1},2);
            SliceMeanBin{i,1}{c,1}(:,2) = nanstd(SliceBinned{i,1}{c,1},0,2);
            
            
            
            SliceMin{i,1}{c,1} = islocalmin(SliceMeanBin{i,1}{c,1}(1:14000,1),'MaxNumExtrema',1);
            SliceMinIndex = find(SliceMin{i,1}{c,1});
            
            SliceMinRange{i,1}{c,1}(1,1) = SliceMinIndex - (TW/2); % lower bound
            if SliceMinRange{i,1}{c,1}(1,1)<0
                SliceMinRange{i,1}{c,1}(1,1) = 1;
            end
            SliceMinRange{i,1}{c,1}(2,1) = SliceMinIndex + (TW/2); % upper bound
            
            
            SliceAfterLocal{i,1}{c,1} = islocalmax(SliceMeanBin{i,1}{c,1}(SliceMinIndex:end,1),'MaxNumExtrema',1);
            SliceAfterIndex = find(SliceAfterLocal{i,1}{c,1});
            SliceAfterMax{i,1}{c,1}(1,1) = SliceAfterIndex - TW/2;
            SliceAfterMax{i,1}{c,1}(2,1) = SliceAfterIndex + TW/2;
%             SliceAfterMax{i,1}{c,1}(1,1) = SliceMinIndex + 6000;
%             SliceAfterMax{i,1}{c,1}(2,1) = SliceAfterMax{i,1}{c,1}(1,1) + TW;
            
            SliceMax{i,1}{c,1} = islocalmax(SliceMeanBin{i,1}{c,1}(1:SliceMinIndex,1),'MaxNumExtrema',1);
            SliceMaxIndex = find(SliceMax{i,1}{c,1});
            SliceMaxRange{i,1}{c,1}(1,1) = SliceMaxIndex-TW/2;
            if SliceMaxRange{i,1}{c,1}(1,1) < 0
                SliceMaxRange{i,1}{c,1}(1,1) = 1;
            end
            SliceMaxRange{i,1}{c,1}(2,1) = SliceMaxIndex+TW/2;
            
            % find the peaks from the max to get height
            SliceAvMax{c,1}{i,1} = SliceBinned{i,1}{c,1}(SliceMaxIndex);
            SliceAvMin{c,1}{i,1} = SliceBinned{i,1}{c,1}(SliceMinIndex);
            
            SliceMinTime(c,i) = SliceMinIndex;
            
            [SlicePower{c,1}(i,:), SlicePower{c,2}(i,:)] = pspectrum(SliceMeanBin{i,1}{c,1}(SliceAfterMax{i,1}{c,1}(2,1):end,2),2000);
            
        end
    end
end

for d = 1:length(SliceMeanBin)
    if isempty(SliceMeanBin{d,1})
        continue
    else
        for i = 2:length(SliceMeanBin{d,1})
            if isempty(SliceMeanBin{d,1}{i,1})
                continue
            else
            
                for c = 1:length(SliceBinned{d,1}{i,1}(1,:))
                    
                    
                    for e = 1:length(SliceBinned{d,1}{i,1}(1,:))
%                         try
%                         disp(d)
%                         disp(i)
%                         disp(c)
%                         disp(e)
%                         disp(SliceMinRange{d,1}{i,1}(1,1))
%                         disp(SliceMaxRange{d,1}{i,1}(1,1))
%                         disp(SliceAfterMax{d,1}{i,1}(1,1))
                        SliceCorr{d,1}{i,1}(e,c) = corr(SliceBinned{d,1}{i,1}(SliceMaxRange{d,1}{i,1}(1,1):SliceMaxRange{d,1}{i,1}(1,1)+4000,e),SliceBinned{d,1}{i,1}(SliceMaxRange{d,1}{i,1}(1,1):SliceMaxRange{d,1}{i,1}(1,1)+4000,c));
%                             SliceCorr{d,1}{i,1}(e,c) = corr(SliceBinned{d,1}{i,1}(1:8000,e),SliceBinned{d,1}{i,1}(1:8000,c));
%                         catch
%                             continue
%                         end
                        [FirCrossCorr{d,1}{i,1}{e,c},Lags{d,1}{i,1}{e,c}] = xcorr(SliceBinned{d,1}{i,1}(SliceMaxRange{d,1}{i,1}(1,1):SliceMaxRange{d,1}{i,1}(1,1)+4000,e),SliceBinned{d,1}{i,1}(SliceMaxRange{d,1}{i,1}(1,1):SliceMaxRange{d,1}{i,1}(1,1)+4000,c),'normalized');
                    end
                end

            end
            SliceCorrTemp = reshape(SliceCorr{d,1}{i,1},[],1);
            SliceCorrOnesIndex = find(SliceCorrTemp<0.9999);
            SliceCorrNoOnes{i,1}(d,1) = mean(SliceCorrTemp(SliceCorrOnesIndex));
            SliceCorrNoOnes{i,1}(d,2) = std(SliceCorrTemp(SliceCorrOnesIndex));
            
            I = eye(length(FirCrossCorr{d,1}{i,1}));
            IFind = find(~I);
            xCorrTemp = (FirCrossCorr{d,1}{i,1}(IFind));
            xCorrTemp = reshape(xCorrTemp,length(FirCrossCorr{d,1}{i,1})-1,[]);
            for b = 1:length(xCorrTemp);
                 xCorrMean{b} = mean(reshape(cell2mat(xCorrTemp(:,b)),length(FirCrossCorr{d,1}{i,1}{1,1}(:,1)),[]),2);
            end
            MeanXCorrMat = cell2mat(xCorrMean);
            CrossCorr{i,1}(:,d) = mean(MeanXCorrMat,2);
            
        end
    end
end


%%
% for i = 1:length(SliceCellBinned)
%     if isempty(SliceCellBinned{i,1})
%         continue
%     else
%         
%         for c = 1:length(SliceCellBinned{i,1})
%             if isempty(SliceCellBinned{i,1}{c,1})
%                 continue
%             else
%                 
%                 for d = 1:length(SliceCellBinned{i,1}{c,1})
%                     for e = 1:length(SliceCellBinned{i,1}{c,1}{d,1}(1,:))
%                         for b = 1:length(SliceCellBinned{i,1}{c,1}{d,1}(1,:))
%                             [CellCorr{c,1}{i,1}{e,b}, CellLags{c,1}{i,1}{e,b}] = xcorr(SliceCellBinned{i,1}{c,1}{d,1}(1:8000,e),SliceCellBinned{i,1}{c,1}{d,1}(1:8000,b),'normalized');
%                         end
%                     end
%                 end
%             end
%         end
%         
%     end
% end






