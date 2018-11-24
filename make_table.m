function table = make_table(songName,gs,deltaTL,deltaTU,deltaF,testOption)

% -------------- Step 1. Preprocessing ------------
Fs = 8000;
F1 = 44100;
if testOption == 2 %the recording
    resampledSong = songName(:,1);
else %not the recording
    load(songName,'-mat');
    resampledSong = y(:,1);
end
%--------------that filter tho-------------
h = fdesign.lowpass('n,f3db', 8, 1800, 44100);
Hd = design(h, 'butter','SOSScaleNorm', 'Linf');
set(Hd,'PersistentMemory',true);
resampledSong = filter(Hd,resampledSong);
%--------------------------------------
resampledSong = resample(resampledSong,8000,44100);

% -------------- Step 2. Spectogram ------------
window = 8000*.064; % integer length of chunks you want to take fft of
noverlap = 8000*.032; % number of samples to overlap
nfft = 8000*.064;  % length of the fft, resolution of frequencies, == window

[S,F,T] = spectrogram(resampledSong,window,noverlap,nfft,Fs);
% S - matrix of spectogram
% F - frequency vector
% T - time vector
log_S = log10(abs(S)+1);

% -------------- Step 3. Feature Extraction ------------

gsRange = (-gs+1)/2:(gs-1)/2;
CS = circshift(log_S,[0,-1]);
localPeak = ((log_S-CS)>0);
for i = gsRange
    for j = gsRange
        if (i == 0 && j == 0)
            localPeak = localPeak;
        else
            CS = circshift(log_S,[i,j]);
            localPeak = ((log_S-CS)>0)&localPeak;
        end
    end
end

% -------------- Step 4. Thresholding ------------
for i=1:length(T)
    en = sort(log_S(:,i));
    thresh=en(30);
    aboveThresh = (log_S >=thresh);
    localPeak = localPeak & aboveThresh;
end

% -------------- Step 5. Constructing the Table ------------
%the blank table
table = [];
songLen = length(resampledSong)/8000;
numThresh = ceil(songLen*30);

[indexF indexT] = find(localPeak);
for i = 1:numThresh
    condition = (indexT >= indexT(i)+deltaTL)&...
        (indexT <= indexT(i)+deltaTU)&...
        (indexF >= indexF(i)-deltaF)&...
        (indexF <= indexF(i)+deltaF);
    indexFit = find(condition,3);
    nfit = length(indexFit);
    
    if nfit ~= 0
        fitMatrix = [indexF(i)*ones(nfit,1) indexF(indexFit)...
            indexT(i)*ones(nfit,1) indexT(indexFit)-indexT(i)*ones(nfit,1)];
        table = [table;fitMatrix];
    end
end
end