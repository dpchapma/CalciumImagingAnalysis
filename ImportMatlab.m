%% Script to load and begin analysis for full calcium+LFP data 
%% FYI takes about 30 GB of storage to run on somatic data (n = 29 slices) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Function to import analyzed matlab scripts from swrAnalysis %%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ShamData, TBIData] = ImportMatlab(Shamfolders,TBIfolders)
% setup names to catch folders that don't have all the dFoF's
SessionNames = {'se.mat','O1.mat','O4.mat','O5.mat','O6.mat','O7.mat','O8.mat','FS.mat','S5.mat','10.mat'};
% Import the data 
for i = 4:length(Shamfolders)
    % Get the directory to the files
    Shamfiles{i,1} = dir(strcat(Shamfolders(i).folder,'/',Shamfolders(i).name));
    % Get rid of two negeligible indexes at front 
    ShamFiles{i,1} = Shamfiles{i,1}(4:end);
    % Concatenate file names and folder path and load the files in each
    % folder
    
    for d = 1:length(ShamFiles{i,1})

        BlahData = load(strcat(ShamFiles{i,1}(d).folder,'/',ShamFiles{i,1}(d).name));
        BlahSeshName = BlahData.saveName(end-5:end);
        for c = 1:length(SessionNames)
            BlahInd(c) = strcmp(BlahSeshName,SessionNames(c));
        end
        ShamData{i,1}{BlahInd',1} = load(strcat(ShamFiles{i,1}(d).folder,'/',ShamFiles{i,1}(d).name));
    end
    
    % We need to reorder the data so that the IO curve comes first 
    % and plasticity comes second
    try
        ShamData{i,1}([1 2 3 4 5 6 7 8 9 10],:) = ShamData{i,1}([2 3 5 7 4 6 1 8 9 10],:);
    catch
        ShamData{i,1}{10,1} = [];
        ShamData{i,1}([1 2 3 4 5 6 7 8 9 10],:) = ShamData{i,1}([2 3 5 7 4 6 1 8 9 10],:);
    end
end
ShamData = ShamData(4:end); % get rid of random empty cells 

%%
for i = 4:length(TBIfolders)
    % Get the directory to the files
    TBIfiles{i,1} = dir(strcat(TBIfolders(i).folder,'/',TBIfolders(i).name));
    % Get rid of two negeligible indexes at front 
    TBIFiles{i,1} = TBIfiles{i,1}(4:end);
    % Concatenate file names and folder path and load the files in each
    % folder
    
    for d = 1:length(TBIFiles{i,1})

        BlahData = load(strcat(TBIFiles{i,1}(d).folder,'/',TBIFiles{i,1}(d).name));
        BlahSeshName = BlahData.saveName(end-5:end);
        for c = 1:length(SessionNames)
            BlahInd(c) = strcmp(BlahSeshName,SessionNames(c));
        end
        TBIData{i,1}{BlahInd',1} = load(strcat(TBIFiles{i,1}(d).folder,'/',TBIFiles{i,1}(d).name));
    end
    
    % We need to reorder the data so that the IO curve comes first 
    % and plasticity comes second
    try
        TBIData{i,1}([1 2 3 4 5 6 7 8 9 10],:) = TBIData{i,1}([2 3 5 7 4 6 1 8 9 10],:);
    catch
        TBIData{i,1}{10,1} = [];
        TBIData{i,1}([1 2 3 4 5 6 7 8 9 10],:) = TBIData{i,1}([2 3 5 7 4 6 1 8 9 10],:);
    end
end
TBIData = TBIData(4:end); % get rid of random empty cells 

% Section takes about 3.5 minutes to run on my computer :D 

%% NEXT RUN Exclusion Criteria