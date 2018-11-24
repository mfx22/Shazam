function songName = matching(testOption,clip,hashTable,songNameTable,gs,deltaTL,deltaTU,deltaF)

clipTable = make_table(clip,gs,deltaTL,deltaTU,deltaF,testOption);
cliphash = hash(clipTable);

matchMatrix = [];
for i = 1:length(cliphash)
        index = find(hashTable(:,1)==cliphash(i,1));
        to = hashTable(index,2)-cliphash(i,2);
        songid = hashTable(index,3);
        matchMatrix = [matchMatrix ; to songid];
end


modetable = mode(matchMatrix);
t0mode = modetable(1);

accumulator = [];
for i = 1:length(matchMatrix)
    if (matchMatrix(i,1)==t0mode)
        accumulator = [accumulator;matchMatrix(i,2)];
    end
end
songName = mode(accumulator);

% converting back to a string identity
songName = int2str(songName);
suffix = '.mat';
if(length(songName) == 1)
    prefix = '0';
else
    prefix = '';
end
songName = strcat(prefix,songName,suffix);
end