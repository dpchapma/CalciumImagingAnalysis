TW = 20;

for i = 1:length(ShamE)
    if isempty(ShamE{i,1})
        i = i + 1;
    end
    for c = 2:length(ShamE{i,1})
        if isempty(ShamE{i,1}{c,1})
            % add logic to catch missing/excluded sessions
            ShamAv{i,1}{c,1} = [];
            ShamBinned{i,1}{c,1} = [];
            continue
        else
            for d = 1:length(ShamE{i,1}{c,1}.stim.Ca.evStartA)
                % take average of above thresh for each session
                ShamAv{i,1}{c,1} = mean(ShamFullAboveThresh{i,1}{c,1},2);
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
                    ShamBinned{i,1}{c,1}(:,d) = ShamAv{i,1}{c,1}(ShamE{i,1}{c,1}.stim.Ca.evStartA(d):ShamE{i,1}{c,1}.stim.Ca.evStartA(d+1),1);
                    ShamCellBinned{i,1}{c,1}{d,1} = ShamFullAboveThresh{i,1}{c,1}(ShamE{i,1}{c,1}.stim.Ca.evStartA(d):ShamE{i,1}{c,1}.stim.Ca.evStartA(d+1),:);
                elseif d == 10
                    continue
                else
                    try
                        ShamBinned{i,1}{c,1}(:,d) = ShamAv{i,1}{c,1}(ShamE{i,1}{c,1}.stim.Ca.evStartA(d):ShamE{i,1}{c,1}.stim.Ca.evStartA(d)+length(ShamBinned{i,1}{c,1}(:,1))-1,1);
                        ShamCellBinned{i,1}{c,1}{d,1} = ShamFullAboveThresh{i,1}{c,1}(ShamE{i,1}{c,1}.stim.Ca.evStartA(d):ShamE{i,1}{c,1}.stim.Ca.evStartA(d)+length(ShamBinned{i,1}{c,1}(:,1))-1,:);
                    catch
                        ShamBinned{i,1}{c,1}(:,d) = nan;
                        ShamCellBinned{i,1}{c,1}{d,1} = nan;
                    end
                end
            end
            %Now take the mean and STD of the binned means as well as find the
            %local minima occurring between 0 and 5 seconds
            %sampling rate of 2 kHz
            ShamMeanBin{i,1}{c,1}(:,1) = nanmean(ShamBinned{i,1}{c,1},2);
            ShamMeanBin{i,1}{c,1}(:,2) = nanstd(ShamBinned{i,1}{c,1},0,2);
            
            
            ShamMin{i,1}{c,1} = islocalmin(ShamMeanBin{i,1}{c,1}(1:14000,1),'MaxNumExtrema',1);
            ShamMinIndex = find(ShamMin{i,1}{c,1});
            
            ShamMinRange{i,1}{c,1}(1,1) = ShamMinIndex - (TW/2); % lower bound
            if ShamMinRange{i,1}{c,1}(1,1)<0
                ShamMinRange{i,1}{c,1}(1,1) = 1;
            end
            ShamMinRange{i,1}{c,1}(2,1) = ShamMinIndex + (TW/2); % upper bound
            
            
            ShamAfterLocal{i,1}{c,1} = islocalmax(ShamMeanBin{i,1}{c,1}(ShamMinIndex:end,1),'MaxNumExtrema',1);
            ShamAfterIndex = find(ShamAfterLocal{i,1}{c,1});
            ShamAfterMax{i,1}{c,1}(1,1) = ShamAfterIndex - TW/2;
            ShamAfterMax{i,1}{c,1}(2,1) = ShamAfterIndex + TW/2;
%             ShamAfterMax{i,1}{c,1}(1,1) = ShamMinIndex + 6000;
%             ShamAfterMax{i,1}{c,1}(2,1) = ShamAfterMax{i,1}{c,1}(1,1) + TW;
            
            ShamMax{i,1}{c,1} = islocalmax(ShamMeanBin{i,1}{c,1}(1:ShamMinIndex,1),'MaxNumExtrema',1);
            ShamMaxIndex = find(ShamMax{i,1}{c,1});
            ShamMaxRange{i,1}{c,1}(1,1) = ShamMaxIndex-TW/2;
            if ShamMaxRange{i,1}{c,1}(1,1) < 0
                ShamMaxRange{i,1}{c,1}(1,1) = 1;
            end
            ShamMaxRange{i,1}{c,1}(2,1) = ShamMaxIndex+TW/2;
            
            % find the peaks from the max to get height
            ShamAvMax{c,1}{i,1} = ShamBinned{i,1}{c,1}(ShamMaxIndex);
            ShamAvMin{c,1}{i,1} = ShamBinned{i,1}{c,1}(ShamMinIndex);
            
            ShamMinTime(c,i) = ShamMinIndex;
            
            [ShamPower{c,1}(i,:), ShamPower{c,2}(i,:)] = pspectrum(ShamMeanBin{i,1}{c,1}(ShamAfterMax{i,1}{c,1}(2,1):end,2),2000);
            
        end
    end
end

%%
figure
plot(ShamMeanBin{14,1}{4,1}(:,1))


%%
for i = 1:length(TBIE)
    if isempty(TBIE{i,1})
        i = i + 1;
    end
    for c = 2:length(TBIE{i,1})
        if isempty(TBIE{i,1}{c,1})
            % add logic to catch missing/excluded sessions
            TBIAv{i,1}{c,1} = [];
            TBIBinned{i,1}{c,1} = [];
            continue
        else
            for d = 1:length(TBIE{i,1}{c,1}.stim.Ca.evStartA)
                % take average of above thresh for each session
                TBIAv{i,1}{c,1} = mean(TBIFullAboveThresh{i,1}{c,1},2);
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
                    TBIBinned{i,1}{c,1}(:,d) = TBIAv{i,1}{c,1}(TBIE{i,1}{c,1}.stim.Ca.evStartA(d):TBIE{i,1}{c,1}.stim.Ca.evStartA(d+1),1);
                    TBICellBinned{i,1}{c,1}{d,1} = TBIFullAboveThresh{i,1}{c,1}(TBIE{i,1}{c,1}.stim.Ca.evStartA(d):TBIE{i,1}{c,1}.stim.Ca.evStartA(d+1),:);
                elseif d == 10
                    continue
                else
                    try
                        TBIBinned{i,1}{c,1}(:,d) = TBIAv{i,1}{c,1}(TBIE{i,1}{c,1}.stim.Ca.evStartA(d):TBIE{i,1}{c,1}.stim.Ca.evStartA(d)+length(TBIBinned{i,1}{c,1}(:,1))-1,1);
                        TBICellBinned{i,1}{c,1}{d,1} = TBIFullAboveThresh{i,1}{c,1}(TBIE{i,1}{c,1}.stim.Ca.evStartA(d):TBIE{i,1}{c,1}.stim.Ca.evStartA(d)+length(TBIBinned{i,1}{c,1}(:,1))-1,:);
                    catch
                        TBIBinned{i,1}{c,1}(:,d) = nan;
                        TBICellBinned{i,1}{c,1}{d,1} = nan;
                    end
                end
            end
            %Now take the mean and STD of the binned means as well as find the
            %local minima occurring between 0 and 5 seconds
            %sampling rate of 2 kHz
            TBIMeanBin{i,1}{c,1}(:,1) = nanmean(TBIBinned{i,1}{c,1},2);
            TBIMeanBin{i,1}{c,1}(:,2) = nanstd(TBIBinned{i,1}{c,1},0,2);
            
            
            TBIMin{i,1}{c,1} = islocalmin(TBIMeanBin{i,1}{c,1}(1:14000,1),'MaxNumExtrema',1);
            TBIMinIndex = find(TBIMin{i,1}{c,1});
            
            TBIMinRange{i,1}{c,1}(1,1) = TBIMinIndex - (TW/2); % lower bound
            if TBIMinRange{i,1}{c,1}(1,1)<0
                TBIMinRange{i,1}{c,1}(1,1) = 1;
            end
            TBIMinRange{i,1}{c,1}(2,1) = TBIMinIndex + (TW/2); % upper bound
            
            
            TBIAfterLocal{i,1}{c,1} = islocalmax(TBIMeanBin{i,1}{c,1}(TBIMinIndex:end,1),'MaxNumExtrema',1);
            TBIAfterIndex = find(TBIAfterLocal{i,1}{c,1});
            TBIAfterMax{i,1}{c,1}(1,1) = TBIAfterIndex - TW/2;
            TBIAfterMax{i,1}{c,1}(2,1) = TBIAfterIndex + TW/2;
%             TBIAfterMax{i,1}{c,1}(1,1) = TBIMinIndex + 6000;
%             TBIAfterMax{i,1}{c,1}(2,1) = TBIAfterMax{i,1}{c,1}(1,1) + TW;
            
            TBIMax{i,1}{c,1} = islocalmax(TBIMeanBin{i,1}{c,1}(1:TBIMinIndex,1),'MaxNumExtrema',1);
            TBIMaxIndex = find(TBIMax{i,1}{c,1});
            TBIMaxRange{i,1}{c,1}(1,1) = TBIMaxIndex-TW/2;
            if TBIMaxRange{i,1}{c,1}(1,1) < 0
                TBIMaxRange{i,1}{c,1}(1,1) = 1;
            end
            TBIMaxRange{i,1}{c,1}(2,1) = TBIMaxIndex+TW/2;
            
            % find the peaks from the max to get height
            TBIAvMax{c,1}{i,1} = TBIBinned{i,1}{c,1}(TBIMaxIndex);
            TBIAvMin{c,1}{i,1} = TBIBinned{i,1}{c,1}(TBIMinIndex);
            
            TBIMinTime(c,i) = TBIMinIndex;
            
            [TBIPower{c,1}(i,:), TBIPower{c,2}(i,:)] = pspectrum(TBIMeanBin{i,1}{c,1}(TBIAfterMax{i,1}{c,1}(2,1):end,2),2000);
            
        end
    end
end

%%
figure 

plot(TBIMeanBin{9,1}{4,1})


%% 
% writematrix(ShamBinned{9,1}{4,1},'ShamAfterEx.xlsx');
writematrix(ShamBinned{14,1}{4,1},'ShamMinEx.xlsx');
% writematrix(TBIBinned{9,1}{6,1},'TBIAfterEx.xlsx');
% writematrix(TBIBinned{12,1}{6,1},'TBIMinEx.xlsx');
