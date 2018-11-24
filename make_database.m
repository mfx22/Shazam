function [database songNameTable] = make_database(gs,deltaTL,deltaTU,deltaF)
    files = what('./songDatabase');
    matFiles = files.mat;
    database = [];
    songNameTable = [];

    songNameTable = [];
for i = 1:length(matFiles)
    fileName = matFiles{i};
    fileNumber = str2num(fileName(1:2));
    toRead = ['songDatabase/',fileName];
    testOption=1;
    table=make_table(toRead,gs,deltaTL,deltaTU,deltaF,testOption)

    for j = 1:length(table)
        songNameTable = [songNameTable; table(j,:) fileNumber];
    end
end
 
%     for i = 1:length(matFiles)
%         fileName = matFiles{i};
%         toRead = ['songDatabase/',fileName];
%         table = make_table(toRead,gs,deltaTL,deltaTU,deltaF);
%         table = [table i*ones(size(table,1),1)];
%         database = [database; table];
%         songNameTable = [songNameTable; fileName];
%     end
    
end