function estimatedEvaluations = opcao5(user_data, bloomFilter)
    % Get the ID of the user whose evaluations are to be estimated
    userID = input('Enter the ID of the user: ');

    % Check if the entered ID is valid
    if ~any(user_data(:, 1) == userID)
        fprintf('Invalid user ID.\n\n');
        estimatedEvaluations = 0;
        return;
    end

    estimatedEvaluations = min(checkMembership(bloomFilter, userID));

    % Display the estimated number of evaluations
    fprintf('Estimated number of evaluations by user %d: %d\n\n', userID, estimatedEvaluations);
end
