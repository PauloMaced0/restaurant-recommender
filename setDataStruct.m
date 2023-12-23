function setDataStruct()
    tic
    h = waitbar(0, 'Initializing...');

    % Reading the restaurant data
    waitbar(0.05, h, 'Reading restaurant data...');
    restaurants = readcell('restaurantes.txt', 'Delimiter', '\t');
    
    % Reading user data
    waitbar(0.1, h, 'Reading user data...');
    user_data = load('utilizadores.data');
    user_data = user_data(:, [1, 2, 4]);
    
    % Get users ID
    waitbar(0.15, h, 'Processing user IDs...');
    usersID = unique(user_data(:,1));
    
    n = 16e3;
    hashFuncBloomFilter = 5;
    waitbar(0.2, h, 'Creating Bloom Filter...');
    bloomFilter=createBloomFilter(n, hashFuncBloomFilter);

    for i=1:length(user_data)
        bloomFilter = insertElement(bloomFilter,user_data(i, 1));
    end

    waitbar(0.3, h, 'Creating restaurant sets...');
    evalByUser = createRestaurantSets(user_data, usersID);

    hashFuncMinHash = 200;
    Nu = length(usersID);

    % Opcao3 Minhash Signatures
    waitbar(0.4, h, 'Calculating signatures (Evaluations)...');
    signatures = inf(Nu, hashFuncMinHash);
    for i = 1:Nu
        conjunto = evalByUser{i}; 
        for j = 1:length(conjunto)
            chave = char(conjunto(j));
            hash = zeros(1,hashFuncMinHash);
            for x = 1:hashFuncMinHash
                chave = [chave num2str(x)];
                hash(x) = DJB31MA(chave,127);
            end
            signatures(i,:) = min([signatures(i,:); hash]);
        end
        waitbar(0.4 + 0.15 * (i / Nu), h);
    end
    
    shingle_size=3;
    shingles_k = 150;
    shinglesSignatures = inf(length(restaurants), shingles_k);

    waitbar(0.55, h, 'Calculating shingle signatures (Dish) ...');
    for i = 1:length(restaurants)
        conjunto = lower(restaurants{i,6});
        shingles = {};
        for j = 1 : length(conjunto) - shingle_size + 1
            shingle = conjunto(j: j + shingle_size - 1);
            shingles{j} = shingle;
        end
        
        for j = 1:length(shingles)
            chave = char(shingles(j));
            hash = zeros(1, shingles_k);
            for x = 1:shingles_k
                chave = [chave num2str(x)];
                hash(x) = DJB31MA(chave,127);
            end
            shinglesSignatures(i, :) = min([shinglesSignatures(i, :); hash]);  % Valor minimo da hash para este shingle
        end
        waitbar(0.55 + 0.15 * (i / length(restaurants)), h);
    end
    
    op4shingle_size=3;
    op4shingles_k = 150;
    op4shinglesSignatures = inf(length(restaurants), shingles_k);

    waitbar(0.7, h, 'Calculating shingle signatures (Dish & Cuisine) ...');
    for i = 1:length(restaurants)
        tipoCozinha = restaurants{i,5};
        pratoTipico = restaurants{i,6};
        if(ismissing(tipoCozinha))
            tipoCozinha = '';
        end
        if(ismissing(pratoTipico))
            pratoTipico = '';
        end
        conjunto = lower([tipoCozinha pratoTipico]);
        shingles = {};
        for j = 1 : length(conjunto) - op4shingle_size + 1
            shingle = conjunto(j: j + op4shingle_size - 1);
            shingles{j} = shingle;
        end
        
        for j = 1:length(shingles)
            chave = char(shingles(j));
            hash = zeros(1, op4shingles_k);
            for x = 1:op4shingles_k
                chave = [chave num2str(x)];
                hash(x) = DJB31MA(chave,127);
            end
            op4shinglesSignatures(i, :) = min([op4shinglesSignatures(i, :); hash]);  % Valor minimo da hash para este shingle
        end
        waitbar(0.7 + 0.15 * (i / length(restaurants)), h);
    end

    avgRating = zeros(length(restaurants), 2);
    waitbar(0.85, h, 'Calculating restaurants average score ...');
    for id = 1:length(restaurants)
        evaluatedRows = find(user_data(:,2) == id);
        avg_rating = sum(user_data(evaluatedRows,3)) / length(evaluatedRows);
        avgRating(id,1) = id;
        avgRating(id,2) = avg_rating;
        waitbar(0.85 + 0.1 * (id / length(restaurants)), h);
    end

    % Saving data
    waitbar(0.95, h, 'Saving data...');
    save setDataStruct user_data restaurants bloomFilter evalByUser signatures usersID hashFuncMinHash shinglesSignatures op4shinglesSignatures shingle_size shingles_k op4shingles_k op4shingle_size avgRating

    % Close the waitbar
    completionMessage = sprintf('Complete! Took %d seconds', toc);
    waitbar(1, h, completionMessage);
    pause(2);
    close(h);
end



