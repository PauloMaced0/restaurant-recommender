function opcao3(restaurants, minhashShingles, shingle_size, shingles_k)
    userInput = input('Write a string: ', 's');

    shinglesIn = {};
    for i = 1:length(userInput) - shingle_size+1
        shingle = userInput(i:i+shingle_size-1);
        shinglesIn{i} = shingle;
    end

    MinHashString = inf(1, shingles_k);
    for j = 1:length(shinglesIn)
        chave = char(shinglesIn{j});
        hash = zeros(1, shingles_k);
        for x = 1:shingles_k
            chave = [chave num2str(x)];
            hash(x) = DJB31MA(chave, 127);
        end
        MinHashString(1,:) = min([MinHashString(1, :); hash]);
    end

    jaccardDistances = ones(1, size(restaurants, 1));
   
    for i=1:size(restaurants, 1)
        jaccardDistances(i) = sum(minhashShingles(i, :) ~= MinHashString) / shingles_k;
    end

    % Filter and sort the results
    [sortedDistances, sortedIndices] = sort(jaccardDistances);
    sortedRestaurants = restaurants(sortedIndices, :);

    % Display top 5 results with Jaccard distance <= 0.99
    disp('Top matching restaurants:');
    numResults = 0;
    for i = 1:length(sortedDistances)
        if sortedDistances(i) <= 0.99 && numResults < 5
            disp(['Name: ' sortedRestaurants{i, 2} ', Location: ' sortedRestaurants{i, 3} ...
                  ', Dish: ' sortedRestaurants{i, 6} ', Jaccard Distance: ' num2str(sortedDistances(i))]);
            numResults = numResults + 1;
        end
    end

    if numResults == 0
        fprintf('No matching restaurants found.\n');
    end
    disp(' ');
end