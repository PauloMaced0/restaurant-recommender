function isMember = checkMembership(bloomFilter, element)
    isMember = [];
    hashFunctions = bloomFilter.hashFunctions;
    for i = 1:length(hashFunctions)
        hash = hashFunctions{i}(element);
        index = mod(hash, length(bloomFilter.bits)) + 1;
        if bloomFilter.bits(index) > 0
            isMember = [isMember bloomFilter.bits(index)];
        end
    end
end
