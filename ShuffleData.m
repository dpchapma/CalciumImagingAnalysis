%% Shuffle all data (2 hours to run)

%%%%% NEED TO OPTIMIZE %%%%%
function [SliceBeforeSim,SliceAfterSim,SliceMinSim,SliceBeforeEvents,SliceAfterEvents,SliceMinEvents] = ShuffleData(SliceFullAboveThresh, SliceMinRange,SliceMaxRange,SliceAfterMax,SliceE,SliceKeptROI)

% [ShamInnerShuffledF,ShamEnsShuffledF,TBIInnerShuffledF,TBIEnsShuffledF] = ShuffleData(ShamAboveThresh,TBIAboveThresh)
SliceBeforeEvents = cell([10,1]);
SliceBeforeVector = cell([length(SliceE),1]);
SliceMinVector = cell([length(SliceE),1]);
SliceMinEvents = cell([10,1]);
SliceAfterVector = cell([length(SliceE),1]);
SliceAfterEvents = cell([10,1]);
SliceBeforeSim = cell([10,1]);
SliceMinSim = cell([10,1]);
SliceAfterSim = cell([10,1]);
for e = 1:1000 % 1000 shufflings
    for i = 1:length(SliceFullAboveThresh) % iterate across slice
        for c = 1:length(SliceFullAboveThresh{i,1}) % iterate across ession
            if isempty(SliceFullAboveThresh{i,1}{c,1})
                SliceShuffledF{i,1}{c,1} = [];
                continue
            else
                
                for z = 1:length(SliceFullAboveThresh{i,1}{c,1}(1,:)) % iterate across cell
                    % Generate random integer
                    randNum = randi(length(SliceFullAboveThresh{i,1}{c,1}(:,z)));
                    % Circularly shift cells time series data by randi
                    SliceShuffledF{i,1}{c,1}(:,z) = circshift(SliceFullAboveThresh{i,1}{c,1}(:,z),randNum);
                end
                
                % iterate across stim to bin data
                
                %                 JUST HAVE TO ADD THE E FOR THE SHUFFLE AND LOG THE DATA APPROPRIATELY
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                
                for d = 1:length(SliceE{i,1}{c,1}.stim.Ca.evStartA)
                    if d == 1
                        SliceCellBinned{i,1}{c,1}{d,1} = SliceShuffledF{i,1}{c,1}(SliceE{i,1}{c,1}.stim.Ca.evStartA(d):SliceE{i,1}{c,1}.stim.Ca.evStartA(d)+20000,:);
                        
                        SliceBeforeVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceMaxRange{i,1}{c,1}(1,1):SliceMaxRange{i,1}{c,1}(2,1),:),1);
                        SliceBeforeEvents{i,c}(d,e) = sum(SliceBeforeVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        
                        SliceMinVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceMinRange{i,1}{c,1}(1,1):SliceMinRange{i,1}{c,1}(2,1),:),1);
                        SliceMinEvents{i,c}(d,e) = sum(SliceMinVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        
                        SliceAfterVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceAfterMax{i,1}{c,1}(1,1):SliceAfterMax{i,1}{c,1}(2,1),:),1);
                        SliceAfterEvents{i,c}(d,e) = sum(SliceAfterVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                    elseif d == 10
                        continue
                    else
                        try
                            SliceCellBinned{i,1}{c,1}{d,1} = SliceShuffledF{i,1}{c,1}(SliceE{i,1}{c,1}.stim.Ca.evStartA(d):SliceE{i,1}{c,1}.stim.Ca.evStartA(d)+20000,:);
                        catch 
                            SliceCellBinned{i,1}{c,1}{d,1} = nan;
                        end
                        if isnan(SliceCellBinned{i,1}{c,1}{d,1})
                            continue
                        else
                        SliceBeforeVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceMaxRange{i,1}{c,1}(1,1):SliceMaxRange{i,1}{c,1}(2,1),:),1);
                        SliceBeforeEvents{i,c}(d,e) = sum(SliceBeforeVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        
                        SliceMinVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceMinRange{i,1}{c,1}(1,1):SliceMinRange{i,1}{c,1}(2,1),:),1);
                        SliceMinEvents{i,c}(d,e) = sum(SliceMinVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        
                        SliceAfterVector{i,1}{c,1}(d,:) = any(SliceCellBinned{i,1}{c,1}{d,1}(SliceAfterMax{i,1}{c,1}(1,1):SliceAfterMax{i,1}{c,1}(2,1),:),1);
                        SliceAfterEvents{i,c}(d,e) = sum(SliceAfterVector{i,1}{c,1}(d,:))./length(SliceKeptROI{i,1}{c,1});
                        %                         catch
                        %                             SliceCellBinned{i,1}{c,1}{d,1} = nan;
                        %
                        %                             SliceBeforeVector{i,1}{c,1}(d,:) = [];
                        %                             SliceBeforeEvents{i,c}(d,e) = nan;
                        %
                        %                             SliceMinVector{i,1}{c,1}(d,:) = [];
                        %                             SliceMinEvents{i,c}(d,e) = nan;
                        %
                        %                             SliceAfterVector{i,1}{c,1}(d,:) = [];
                        %                             SliceAfterEvents{i,c}(d,e) = nan;
                        %                         end
                        end
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                    SliceBeforeSimTemp = pdist(SliceBeforeVector{i,1}{c,1},'hamming');
                    SliceBeforeSim{i,c}(d,e) = nanmean(SliceBeforeSimTemp);
                    
                    SliceMinSimTemp = pdist(SliceMinVector{i,1}{c,1},'hamming');
                    SliceMinSim{i,c}(d,e) = nanmean(SliceMinSimTemp);
                    
                    SliceAfterSimTemp = pdist(SliceAfterVector{i,1}{c,1},'hamming');
                    SliceAfterSim{i,c}(d,e) = nanmean(SliceAfterSimTemp);;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                end
            end
        end
        disp(e)
    end
end













%%
% clear('ShamEnsShuffledF','ShamInnerShuffledF','ShamCCShuffledF')
% ShamShuffledF = ShamAboveThresh;
% for e = 1:1000 % 1000 shufflings
%     parfor i = 1:length(ShamAboveThresh) % iterate across slice
%         for c = 1:length(ShamAboveThresh{i,1}) % iterate across ession
%             if isempty(ShamAboveThresh{i,1}{c,1})
%                 ShamShuffledF{i,1}{c,1} = [];
%                 ShamEnsShuffledF{i,1}{c,1} = [];
%                 continue
%             else
%
%                 for d = 1:length(ShamAboveThresh{i,1}{c,1}(1,:)) % iterate across cell
%                     % Generate random integer
%                     randNum = randi(length(ShamAboveThresh{i,1}{c,1}(:,d)));
%                     % Circularly shift cells time series data by randi
%                     ShamShuffledF{i,1}{c,1}(:,d) = circshift(ShamAboveThresh{i,1}{c,1}(:,d),randNum);
%                 end
%                 for g = 1:length(ShamAboveThresh{i,1}{c,1}(1,:)) % iterate across cell again to get cell-cell correlations
%                     for l = 1:length(ShamAboveThresh{i,1}{c,1}(1,:))
%                         % cosine similarity for each shuffle
%                         ShamCCShuffledF{i,1}{c,e}(l,g) = 1 - pdist2(ShamShuffledF{i,1}{c,1}(:,l)',ShamShuffledF{i,1}{c,1}(:,g)','cosine');
%                         % Normalized inner product for each shuffle
%                         Ca = ShamShuffledF{i,1}{c,1}(:,l);
%                         Cb = ShamShuffledF{i,1}{c,1}(:,g);
%                         ShamInnerShuffledF{i,1}{c,e}(l,g) = dot(Ca,Cb)/((dot(Ca,Ca) + dot(Cb,Cb))/2);
%                     end
%                 end
%                 ShamEnsShuffledF{i,1}{c,1}(e,:) = mean(ShamShuffledF{i,1}{c,1}'); % take mean across frame for ensemble activiyt
%             end
%         end
%     end
%     disp(e)
% end
%
% % Repeat for TBI
% clear('TBIEnsShuffledF','TBIInnerShuffledF','TBICCShuffledF')
% TBIShuffledF = TBIAboveThresh;
% for e = 1:1000 % 1000 shufflings
%     parfor i = 1:length(TBIAboveThresh) % iterate across slice
%         for c = 1:length(TBIAboveThresh{i,1}) % iterate across ession
%             if isempty(TBIAboveThresh{i,1}{c,1})
%                 TBIShuffledF{i,1}{c,1} = [];
%                 TBIEnsShuffledF{i,1}{c,1} = [];
%                 continue
%             else
%
%                 for d = 1:length(TBIAboveThresh{i,1}{c,1}(1,:)) % iterate across cell
%                     % Generate random integer
%                     randNum = randi(length(TBIAboveThresh{i,1}{c,1}(:,d)));
%                     % Circularly shift cells time series data by randi
%                     TBIShuffledF{i,1}{c,1}(:,d) = circshift(TBIAboveThresh{i,1}{c,1}(:,d),randNum);
%                 end
%                 for g = 1:length(TBIAboveThresh{i,1}{c,1}(1,:)) % iterate across cell again to get cell-cell correlations
%                     for l = 1:length(TBIAboveThresh{i,1}{c,1}(1,:))
%                         % cosine similarity for each shuffle
%                         TBICCShuffledF{i,1}{c,e}(l,g) = 1 - pdist2(TBIShuffledF{i,1}{c,1}(:,l)',TBIShuffledF{i,1}{c,1}(:,g)','cosine');
%                         % Normalized inner product for each shuffle
%                         Ca = TBIShuffledF{i,1}{c,1}(:,l);
%                         Cb = TBIShuffledF{i,1}{c,1}(:,g);
%                         TBIInnerShuffledF{i,1}{c,e}(l,g) = dot(Ca,Cb)/((dot(Ca,Ca) + dot(Cb,Cb))/2);
%                     end
%                 end
%                 TBIEnsShuffledF{i,1}{c,1}(e,:) = mean(TBIShuffledF{i,1}{c,1}'); % take mean across frame for ensemble activiyt
%             end
%         end
%     end
%     disp(e)
% end
% end

%
%     % ~450 seconds for both groups
%
%     %% Get rid of empty cells
%
%     for i = 1:length(ShamShuffledF)
%         for c = 1:length(ShamShuffledF{i,1})
%             if isempty(ShamShuffledF{i,1}{c,1})
%                 ShamShuffledF{i,1}{c,1} = double.empty(720,0);
%             end
%         end
%     end
%
%     for i = 1:length(TBIShuffledF)
%         for c = 1:length(TBIShuffledF{i,1})
%             if isempty(TBIShuffledF{i,1}{c,1})
%                 TBIShuffledF{i,1}{c,1} = double.empty(720,0);
%             end
%         end
%     end
%
%% Full above
% for e = 1:1000 % 1000 shufflings
%     for i = 1:length(ShamFullAbove) % iterate across slice
%         for c = 1:length(ShamFullAbove{i,1}) % iterate across ession
%             for d = 1:length(ShamFullAbove{i,1}{c,1}(1,:)) % iterate across cell
%                 % Generate random integer
%                 randNum = randi(length(ShamFullAbove{i,1}{c,1}(:,d)));
%                 % Circularly shift cells time series data by randi
%                 ShamFullShuffledF{i,1}{c,1}(:,d) = circshift(ShamFullAbove{i,1}{c,1}(:,d),randNum);
%             end
%         end
%     end
%     disp(e)
% end
%
% for i = 1:length(ShamFullShuffledF)
%     for c = 1:length(ShamFullShuffledF{i,1})
%         if isempty(ShamFullShuffledF{i,1}{c,1})
%             ShamFullShuffledF{i,1}{c,1} = double.empty(720,0);
%         end
%     end
% end



%% Next run the ensemble activity