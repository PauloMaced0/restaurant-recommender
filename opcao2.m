function opcao2(currentUser, userData, numHashFuncs, unique_users, signatures, rest)
    % Find the index of the current user in the unique_users array
    currentUserIndex = find(unique_users == currentUser, 1);
    
    % Validate if the currentUser is found
    if isempty(currentUserIndex)
        fprintf('Current user ID not found.\n');
        return;
    end

    currentUserSignature = signatures(currentUserIndex, :);
    maxSimilarity = 0;
    mostSimilarUser = NaN;

    for userIndex = 1:length(unique_users)
        if unique_users(userIndex) == currentUser
            continue;
        end
        
        userSignature = signatures(userIndex, :);
        similarity = sum(currentUserSignature == userSignature) / numHashFuncs;
        
        if similarity > maxSimilarity
            maxSimilarity = similarity;
            mostSimilarUser = unique_users(userIndex);
        end
    end
    % Step 3: Find the most similar user
    if isnan(mostSimilarUser)
        fprintf('No similar user found.\n\n');
    else
        fprintf('Most similar user to %d is %d.\n', currentUser, mostSimilarUser);
        similarUserRestaurants = userData(userData(:, 1) == mostSimilarUser, 2);
        disp('Restaurants evaluated by the most similar user:');

        for i = 1:length(similarUserRestaurants)
            restaurantID = similarUserRestaurants(i);
        
            rowIndex = find([rest{:, 1}] == restaurantID, 1);
        
            if ~isempty(rowIndex)
                disp(rest{rowIndex, 2});
            else
                disp(['Restaurant ID ' num2str(restaurantID) ' not found.']);
            end
        end
    end
    disp(' ');
end
