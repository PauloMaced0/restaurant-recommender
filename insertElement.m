function bloomFilter = insertElement(bloomFilter, str)
    hashFunctions = bloomFilter.hashFunctions;

    for i = 1:length(hashFunctions)
        hash = hashFunctions{i}(str);
        index = mod(hash, length(bloomFilter.bits)) + 1;
        bloomFilter.bits(index) = bloomFilter.bits(index) + 1;
    end
end
