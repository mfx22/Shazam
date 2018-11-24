function songName = main(testOption,clip)

gs = 9;
deltaTL = 3;
deltaTU = 6;
deltaF = 9;

%loading database of song names
songNameTable=load('songNameTable.mat');
%accessing the created hashTable
hashTable=load('hashTable2.mat');

if testOption == 2
    recorder = audiorecorder(44100,16,1);
    recordblocking(recorder,6);
    clip = getaudiodata(recorder);
    disp(size(clip));
end
songName = matching(testOption,clip,hashTable.hashed,songNameTable,gs,deltaTL,deltaTU,deltaF);
disp(songName)
end