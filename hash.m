function hashTable = hash(table)

hashTable = table(:,4)*2^16+(table(:,1)-1)*2^8+(table(:,2)-1);
if size(table,2) > 4
    hashTable = [hashTable table(:,3) table(:,5)];
else
    hashTable = [hashTable table(:,3)];
end
end