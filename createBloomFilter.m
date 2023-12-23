function bloomFilter = createBloomFilter(n, k)
    bloomFilter = struct();
    bloomFilter.bits = zeros(1, n);
    hashFunctions = cell(1, k);
    
    str = '!#';
    for i = 1:k
        str = [str num2str(i)];    
        hashFunctions{i} = @(x) string2hash([x str]); 
    end
    
    bloomFilter.hashFunctions = hashFunctions;
end
    