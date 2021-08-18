%% Cell-cell correlation analysis using cosine similarity of above thresh data
% Shams let's actaully calsulate the cosine sim for each cell pair
function [ShamSliceMaster,TBISliceMaster] = CCAnalysis(ShamAboveThresh,TBIAboveThresh,ShamInnerShuffledF,TBIInnerShuffledF,ShamKeptROI,TBIKeptROI)


%% From Hamm et al. Normalized inner product (basically normalized cosine sim)
% S-indexCa,Cb = Ca · Cb/((|Ca|2 + |Cb|2)/2)

for d = 1:length(ShamAboveThresh) % iterate across slice
    for i = 1:length(ShamAboveThresh{d,1}) % iterate across session
        if isempty(ShamAboveThresh{d,1}{i,1})
            continue
        else
            for c = 1:length(ShamAboveThresh{d,1}{i,1}(1,:)) % iterate across cell
                for e = 1:length(ShamAboveThresh{d,1}{i,1}(1,:)) % iterate across cell again
                    % Calculate normalized inner product
                    Ca = ShamAboveThresh{d,1}{i,1}(:,c);
                    Cb = ShamAboveThresh{d,1}{i,1}(:,e);
                    ShamInnerCC{d,1}{i,1}(e,c) = dot(Ca,Cb)/((dot(Ca,Ca) + dot(Cb,Cb))/2);
                end
            end
        end
    end
end

% Now let's take out the ones and take only half the array for distribution
% mapping
for i = 1:length(ShamInnerCC) % Iterate across slice
    for c = 1:length(ShamInnerCC{i,1}) % iterate across session
        if isempty(ShamAboveThresh{i,1}{c,1})
            continue
        else
            for d = 1:length(ShamInnerCC{i,1}{c,1}) % iterate across cell
                if d == 1 % add logic so that first round when the vector is empty runs
                    ShamInnerNoOnes{i,1}{c,1} = ShamInnerCC{i,1}{c,1}(d,d:end);
                else % otherwise concatenate all the rows of just half the corr matrix
                    ShamInnerNoOnes{i,1}{c,1} = [ShamInnerNoOnes{i,1}{c,1} ShamInnerCC{i,1}{c,1}(d,d:end)];
                    ShamOnesIndex = find(ShamInnerNoOnes{i,1}{c,1} < 0.99); % index self corrs
                    ShamInnerNoOnes{i,1}{c,1} = ShamInnerNoOnes{i,1}{c,1}(ShamOnesIndex); % remove self corrs
                end
            end
        end
    end
end

% Repeat for TBI
for d = 1:length(TBIAboveThresh) % iterate across slice
    for i = 1:length(TBIAboveThresh{d,1}) % iterate across session
        if isempty(TBIAboveThresh{d,1}{i,1})
            continue
        else
            for c = 1:length(TBIAboveThresh{d,1}{i,1}(1,:)) % iterate across cell
                for e = 1:length(TBIAboveThresh{d,1}{i,1}(1,:)) % iterate across cell again
                    % Calculate normalized inner product
                    Ca = TBIAboveThresh{d,1}{i,1}(:,c);
                    Cb = TBIAboveThresh{d,1}{i,1}(:,e);
                    TBIInnerCC{d,1}{i,1}(e,c) = dot(Ca,Cb)/((dot(Ca,Ca) + dot(Cb,Cb))/2);
                end
            end
        end
    end
end

% Now let's take out the ones and take only half the array for distribution
% mapping
for i = 1:length(TBIInnerCC) % Iterate across slice
    for c = 1:length(TBIInnerCC{i,1}) % iterate across session
        if isempty(TBIAboveThresh{i,1}{c,1})
            continue
        else
            for d = 1:length(TBIInnerCC{i,1}{c,1}) % iterate across cell
                if d == 1 % add logic so that first round when the vector is empty runs
                    TBIInnerNoOnes{i,1}{c,1} = TBIInnerCC{i,1}{c,1}(d,d:end);
                else % otherwise concatenate all the rows of just half the corr matrix
                    TBIInnerNoOnes{i,1}{c,1} = [TBIInnerNoOnes{i,1}{c,1} TBIInnerCC{i,1}{c,1}(d,d:end)];
                    TBIOnesIndex = find(TBIInnerNoOnes{i,1}{c,1} < 0.99); % index self corrs
                    TBIInnerNoOnes{i,1}{c,1} = TBIInnerNoOnes{i,1}{c,1}(TBIOnesIndex); % remove self corrs
                end
            end
        end
    end
end

%% New Shuffled

clear('ShamInnerFinal','ShamInnerNoOnesShuffledF')
for i = 1:length(ShamInnerShuffledF) % Iterate across slice
    if isempty(ShamInnerShuffledF{i,1})
        i = i+1;
    end
    disp(i)
    for c = 1:length(ShamInnerShuffledF{i,1}(:,1)) % iterate across session
        if isempty(ShamAboveThresh{i,1}{c,1})
            continue
        else
            for e = 1:length(ShamInnerShuffledF{i,1})
                
                for d = 1:length(ShamInnerShuffledF{i,1}{c,1}) % iterate across cell
                    if d == 1 % add logic so that first round when the vector is empty runs
                        ShamInnerNoOnesShuffledF{i,1}{c,e} = ShamInnerShuffledF{i,1}{c,e}(d,d:end);
                        
                    else % otherwise concatenate all the rows of just half the corr matrix
                        ShamInnerNoOnesShuffledF{i,1}{c,e} = [ShamInnerNoOnesShuffledF{i,1}{c,e} ShamInnerShuffledF{i,1}{c,e}(d,d:end)];
                        ShamOnesIndex = find(ShamInnerNoOnesShuffledF{i,1}{c,e} < 0.99); % index self corrs
                        ShamInnerNoOnesShuffledF{i,1}{c,e} = ShamInnerNoOnesShuffledF{i,1}{c,e}(ShamOnesIndex); % remove self corrs
                        % now we need to put all the 1000 cell pairs into
                        % one distribution
                        ShamInnerFinal{i,1}{c,1}(1:length(ShamInnerNoOnesShuffledF{i,1}{c,e}),e) = ShamInnerNoOnesShuffledF{i,1}{c,e}';
                    end
                end
            end
            disp(i)
        end
    end
end

clear('TBIInnerFinal','TBIInnerNoOnesShuffledF')
for i = 1:length(TBIInnerShuffledF) % Iterate across slice
    for c = 1:length(TBIInnerShuffledF{i,1}(:,1)) % iterate across session
        if isempty(TBIAboveThresh{i,1}{c,1})
            continue
        else
            for e = 1:length(TBIInnerShuffledF{i,1})
                
                for d = 1:length(TBIInnerShuffledF{i,1}{c,1}) % iterate across cell
                    if d == 1 % add logic so that first round when the vector is empty runs
                        TBIInnerNoOnesShuffledF{i,1}{c,e} = TBIInnerShuffledF{i,1}{c,e}(d,d:end);
                        
                    else % otherwise concatenate all the rows of just half the corr matrix
                        TBIInnerNoOnesShuffledF{i,1}{c,e} = [TBIInnerNoOnesShuffledF{i,1}{c,e} TBIInnerShuffledF{i,1}{c,e}(d,d:end)];
                        TBIOnesIndex = find(TBIInnerNoOnesShuffledF{i,1}{c,e} < 0.99); % index self corrs
                        TBIInnerNoOnesShuffledF{i,1}{c,e} = TBIInnerNoOnesShuffledF{i,1}{c,e}(TBIOnesIndex); % remove self corrs
                        % now we need to put all the 1000 cell pairs into
                        % one distribution
                        TBIInnerFinal{i,1}{c,1}(1:length(TBIInnerNoOnesShuffledF{i,1}{c,e}),e) = TBIInnerNoOnesShuffledF{i,1}{c,e}';
                    end
                end
            end
            disp(i)
        end
    end
end


%% Proportions for new shuffled
clear('ShamInnerCutoff','TBIInnerCutoff')
for i = 1:length(ShamInnerFinal) % iterate across slice
    for c = 1:length(ShamInnerFinal{i,1}) % iterate across session
        if isempty(ShamAboveThresh{i,1}{c,1})
            continue
        else
            ShamInnerFinal{i,1}{c,1} = sort(ShamInnerFinal{i,1}{c,1},2); % sort shuffled Inners
            % Add logic to get rid of empty sessions
            if isempty(ShamInnerFinal{i,1}{c,1})
                continue
            end
            % Find the top 1% threshold
            for e = 1:length(ShamInnerFinal{i,1}{c,1}(:,1))
                ShamInnerCutoff{i,1}{c,1}(e,1) = ShamInnerFinal{i,1}{c,1}(e,990);
                ShamSliceMaster{c,1}(i,1) = ShamInnerFinal{i,1}{c,1}(e,990);
            end
        end
    end
end

% repeat for TBI
clear('TBIInnerCutoff','TBIInnerCutoff')
for i = 1:length(TBIInnerFinal) % iterate across slice
    for c = 1:length(TBIInnerFinal{i,1}) % iterate across session
        if isempty(TBIAboveThresh{i,1}{c,1})
            continue
        else
            TBIInnerFinal{i,1}{c,1} = sort(TBIInnerFinal{i,1}{c,1},2); % sort shuffled Inners
            % Add logic to get rid of empty sessions
            if isempty(TBIInnerFinal{i,1}{c,1})
                continue
            end
            % Find the top 1% threshold
            for e = 1:length(TBIInnerFinal{i,1}{c,1}(:,1))
                TBIInnerCutoff{i,1}{c,1}(e,1) = TBIInnerFinal{i,1}{c,1}(e,990);
                TBISliceMaster{c,1}(i,1) = TBIInnerFinal{i,1}{c,1}(e,990);
            end
        end
    end
end

%% Find proportions of real data above threshold

for i = 1:length(ShamInnerNoOnes) % iterate across slice
    for c = 1:length(ShamInnerNoOnes{i,1}) % iterate across sessions
        if isempty(ShamInnerNoOnes{i,1}{c,1})||length(ShamKeptROI{i,1}{c,1})<2
            continue
        else
            disp(i)
            disp(c)
            % Find number of similarities that are above threshold
            NumberofSims = length(find(ShamInnerNoOnes{i,1}{c,1}' > ShamInnerCutoff{i,1}{c,1}));
            % Calcualte proportion of sims above threshold and pass into new
            % variable as well as sham slice master
            ShamInnerProps{i,1}(c,1) = NumberofSims/length(ShamInnerNoOnes{i,1}{c,1});
            ShamSliceMaster{c,1}(i,2) = NumberofSims/length(ShamInnerNoOnes{i,1}{c,1});
        end
    end
end

% Repeat for TBI
for i = 1:length(TBIInnerNoOnes) % iterate across slice
    for c = 1:length(TBIInnerNoOnes{i,1}) % iterate across sessions
        if isempty(TBIInnerNoOnes{i,1}{c,1})||length(TBIKeptROI{i,1}{c,1})<2
            continue
        else
            % Find number of similarities that are above threshold
            NumberofSims = length(find(TBIInnerNoOnes{i,1}{c,1}' > TBIInnerCutoff{i,1}{c,1}));
            % Calcualte proportion of sims above threshold and pass into new
            % variable as well as sham slice master
            TBIInnerProps{i,1}(c,1) = NumberofSims/length(TBIInnerNoOnes{i,1}{c,1});
            TBISliceMaster{c,1}(i,2) = NumberofSims/length(TBIInnerNoOnes{i,1}{c,1});
        end
    end
end








%%
%%%%%%%%%%%%%
% Same code but just using standard cosine sim
%%%%%%%%%%%%
%%
% for d = 1:length(ShamAboveThresh) % iterate across slice
%     for i = 1:length(ShamAboveThresh{d,1}) % iterate across session
%         if isempty(ShamAboveThresh{d,1}{i,1})
%             continue
%         else
%             for c = 1:length(ShamAboveThresh{d,1}{i,1}(1,:)) % iterate across cell
%                 for e = 1:length(ShamAboveThresh{d,1}{i,1}(1,:)) % iterate across cell again
%                     ShamCC{d,1}{i,1}(e,c) = 1 - pdist2(ShamAboveThresh{d,1}{i,1}(:,c)',ShamAboveThresh{d,1}{i,1}(:,e)','cosine');
%                 end
%             end
%         end
%     end
% end
% 
% % Now let's take out the ones and take only half the array for distribution
% % mapping
% for i = 1:length(ShamCC) % Iterate across slice
%     for c = 1:length(ShamCC{i,1}) % iterate across session
%         if isempty(ShamAboveThresh{i,1}{c,1})
%             continue
%         else
%             
%             for d = 1:length(ShamCC{i,1}{c,1}) % iterate across cell
%                 if d == 1 % add logic so that first round when the vector is empty runs
%                     ShamCCNoOnes{i,1}{c,1} = ShamCC{i,1}{c,1}(d,d:end);
%                 else % otherwise concatenate all the rows of just half the corr matrix
%                     ShamCCNoOnes{i,1}{c,1} = [ShamCCNoOnes{i,1}{c,1} ShamCC{i,1}{c,1}(d,d:end)];
%                     ShamOnesIndex = find(ShamCCNoOnes{i,1}{c,1} < 0.99); % index self corrs
%                     ShamCCNoOnes{i,1}{c,1} = ShamCCNoOnes{i,1}{c,1}(ShamOnesIndex); % remove self corrs
%                 end
%             end
%         end
%     end
% end
% 
% 
% 
% % Repeat for TBI
% for d = 1:length(TBIAboveThresh) % iterate across slice
%     for i = 1:length(TBIAboveThresh{d,1}) % iterate across session
%         if isempty(TBIAboveThresh{d,1}{i,1})
%             continue
%         else
%             for c = 1:length(TBIAboveThresh{d,1}{i,1}(1,:)) % iterate across cell
%                 for e = 1:length(TBIAboveThresh{d,1}{i,1}(1,:)) % iterate across cell again
%                     TBICC{d,1}{i,1}(e,c) = 1 - pdist2(TBIAboveThresh{d,1}{i,1}(:,c)',TBIAboveThresh{d,1}{i,1}(:,e)','cosine');
%                 end
%             end
%         end
%     end
% end
% 
% % Now let's take out the ones and take only half the array for distribution
% % mapping
% for i = 1:length(TBICC) % Iterate across slice
%     for c = 1:length(TBICC{i,1}) % iterate across session
%         if isempty(TBIAboveThresh{i,1}{c,1})
%             continue
%         else
%             for d = 1:length(TBICC{i,1}{c,1}) % iterate across cell
%                 if d == 1 % add logic so that first round when the vector is empty runs
%                     TBICCNoOnes{i,1}{c,1} = TBICC{i,1}{c,1}(d,d:end);
%                 else % otherwise concatenate all the rows of just half the corr matrix
%                     TBICCNoOnes{i,1}{c,1} = [TBICCNoOnes{i,1}{c,1} TBICC{i,1}{c,1}(d,d:end)];
%                     TBIOnesIndex = find(TBICCNoOnes{i,1}{c,1} < 0.99); % index self corrs
%                     TBICCNoOnes{i,1}{c,1} = TBICCNoOnes{i,1}{c,1}(TBIOnesIndex); % remove self corrs
%                 end
%             end
%         end
%     end
% end
% 
% %% New shuffled
% 
% clear('ShamCCFinal','ShamCCNoOnesShuffledF')
% for i = 1:length(ShamCCShuffledF) % Iterate across slice
%     for c = 1:length(ShamCCShuffledF{i,1}(:,1)) % iterate across session
%         if isempty(ShamAboveThresh{i,1}{c,1})
%             continue
%         else
%             for e = 1:length(ShamCCShuffledF{i,1})
%                 
%                 for d = 1:length(ShamCCShuffledF{i,1}{c,1}) % iterate across cell
%                     if d == 1 % add logic so that first round when the vector is empty runs
%                         ShamCCNoOnesShuffledF{i,1}{c,e} = ShamCCShuffledF{i,1}{c,e}(d,d:end);
%                         
%                     else % otherwise concatenate all the rows of just half the corr matrix
%                         ShamCCNoOnesShuffledF{i,1}{c,e} = [ShamCCNoOnesShuffledF{i,1}{c,e} ShamCCShuffledF{i,1}{c,e}(d,d:end)];
%                         ShamOnesIndex = find(ShamCCNoOnesShuffledF{i,1}{c,e} < 0.99); % index self corrs
%                         ShamCCNoOnesShuffledF{i,1}{c,e} = ShamCCNoOnesShuffledF{i,1}{c,e}(ShamOnesIndex); % remove self corrs
%                         % now we need to put all the 1000 cell pairs into
%                         % one distribution
%                         ShamCCFinal{i,1}{c,1}(1:length(ShamCCNoOnesShuffledF{i,1}{c,e}),e) = ShamCCNoOnesShuffledF{i,1}{c,e}';
%                     end
%                 end
%             end
%             disp(i)
%         end
%     end
% end
% 
% clear('TBICCFinal','TBICCNoOnesShuffledF')
% for i = 1:length(TBICCShuffledF) % Iterate across slice
%     for c = 1:length(TBICCShuffledF{i,1}(:,1)) % iterate across session
%         if isempty(TBIAboveThresh{i,1}{c,1})
%             continue
%         else
%             for e = 1:length(TBICCShuffledF{i,1})
%                 
%                 for d = 1:length(TBICC{i,1}{c,1}) % iterate across cell
%                     if d == 1 % add logic so that first round when the vector is empty runs
%                         TBICCNoOnesShuffledF{i,1}{c,e} = TBICCShuffledF{i,1}{c,e}(d,d:end);
%                         
%                     else % otherwise concatenate all the rows of just half the corr matrix
%                         TBICCNoOnesShuffledF{i,1}{c,e} = [TBICCNoOnesShuffledF{i,1}{c,e} TBICCShuffledF{i,1}{c,e}(d,d:end)];
%                         TBIOnesIndex = find(TBICCNoOnesShuffledF{i,1}{c,e} < 0.99); % index self corrs
%                         TBICCNoOnesShuffledF{i,1}{c,e} = TBICCNoOnesShuffledF{i,1}{c,e}(TBIOnesIndex); % remove self corrs
%                         % now we need to put all the 1000 cell pairs into
%                         % one distribution
%                         TBICCFinal{i,1}{c,1}(1:length(TBICCNoOnesShuffledF{i,1}{c,e}),e) = TBICCNoOnesShuffledF{i,1}{c,e}';
%                     end
%                 end
%             end
%             disp(i)
%         end
%     end
% end
% 
% %% Proportions for new shuffled
% clear('ShamCCCutoff','TBICCCutoff')
% for i = 1:length(ShamCCFinal) % iterate across slice
%     for c = 1:length(ShamCCFinal{i,1}) % iterate across session
%         if isempty(ShamAboveThresh{i,1}{c,1})
%             continue
%         else
%             ShamCCFinal{i,1}{c,1} = sort(ShamCCFinal{i,1}{c,1},2); % sort shuffled CCs
%             % Add logic to get rid of empty sessions
%             if isempty(ShamCCFinal{i,1}{c,1})
%                 continue
%             end
%             % Find the top 1% threshold
%             for e = 1:length(ShamCCFinal{i,1}{c,1}(:,1))
%                 ShamCCCutoff{i,1}{c,1}(e,1) = ShamCCFinal{i,1}{c,1}(e,990);
%                 ShamSliceMaster{i,1}(c,20) = ShamCCFinal{i,1}{c,1}(e,990);
%             end
%         end
%     end
% end
% 
% % repeat for TBI
% clear('TBICCCutoff','TBICCCutoff')
% for i = 1:length(TBICCFinal) % iterate across slice
%     for c = 1:length(TBICCFinal{i,1}) % iterate across session
%         if isempty(TBIAboveThresh{i,1}{c,1})
%             continue
%         else
%             TBICCFinal{i,1}{c,1} = sort(TBICCFinal{i,1}{c,1},2); % sort shuffled CCs
%             % Add logic to get rid of empty sessions
%             if isempty(TBICCFinal{i,1}{c,1})
%                 continue
%             end
%             % Find the top 1% threshold
%             for e = 1:length(TBICCFinal{i,1}{c,1}(:,1))
%                 TBICCCutoff{i,1}{c,1}(e,1) = TBICCFinal{i,1}{c,1}(e,990);
%                 TBISliceMaster{i,1}(c,20) = TBICCFinal{i,1}{c,1}(e,990);
%             end
%         end
%     end
% end
% 
% % Update slice master
% SliceMasterColumns = [SliceMasterColumns 'CC 1% cutoff'];
% %% Find proportions of real data above threshold
% 
% for i = 1:length(ShamCCNoOnes) % iterate across slice
%     for c = 1:length(ShamCCNoOnes{i,1}) % iterate across sessions
%         if isempty(ShamAboveThresh{i,1}{c,1})
%             continue
%         else
%             % Find number of similarities that are above threshold
%             NumberofSims = length(find(ShamCCNoOnes{i,1}{c,1}' > ShamCCCutoff{i,1}{c,1}));
%             % Calcualte proportion of sims above threshold and pass into new
%             % variable as well as sham slice master
%             ShamCCProps{i,1}(c,1) = NumberofSims/length(ShamCCNoOnes{i,1}{c,1});
%             ShamSliceMaster{i,1}(c,21) = NumberofSims/length(ShamCCNoOnes{i,1}{c,1});
%         end
%     end
% end
% 
% % Repeat for TBI
% for i = 1:length(TBICCNoOnes) % iterate across slice
%     for c = 1:length(TBICCNoOnes{i,1}) % iterate across sessions
%         if isempty(TBIAboveThresh{i,1}{c,1})
%             continue
%         else
%             % Find number of similarities that are above threshold
%             NumberofSims = length(find(TBICCNoOnes{i,1}{c,1}' > TBICCCutoff{i,1}{c,1}));
%             % Calcualte proportion of sims above threshold and pass into new
%             % variable as well as sham slice master
%             TBICCProps{i,1}(c,1) = NumberofSims/length(TBICCNoOnes{i,1}{c,1});
%             TBISliceMaster{i,1}(c,21) = NumberofSims/length(TBICCNoOnes{i,1}{c,1});
%         end
%     end
% end
%% Next run ensemble overlap analysis