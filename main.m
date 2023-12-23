clear;

% Check if setDataStruct.mat exists
if exist('setDataStruct.mat', 'file') == 2   
    load setDataStruct
else
    setDataStruct()
    load setDataStruct
end

% Get User ID
userID = input('Insert User ID (1 to ??): ');

% Loop until the user chooses to exit
while true
    % Display menu options
    disp('1 - Restaurants evaluated by you');
    disp('2 - Set of restaurants evaluated by the most similar user');
    disp('3 - Search special dish');
    disp('4 - Find most similar restaurants');
    disp('5 - Estimate the number of evaluations by each tourist');
    disp('6 - Exit');
    choice = input('Select choice: ');

    switch choice
        case 1
            % List Restaurants Evaluated by User
            opcao1(userID, user_data, restaurants);
           
        case 2
            % Find Most Similar User
            opcao2(userID, user_data, hashFuncMinHash, usersID, signatures, restaurants);
            
        case 3
            % Search Special Dish
            opcao3(restaurants, shinglesSignatures, shingle_size, shingles_k);
            
        case 4
            % Find Most Similar Restaurants
            opcao4(userID, user_data, restaurants, op4shinglesSignatures, op4shingle_size, op4shingles_k, avgRating);
           
        case 5
            % Estimate Evaluations by a User
            opcao5(user_data, bloomFilter);
            
        case 6
            % Exit Application
            fprintf('Exiting application.\n\n');
            break;
   
        otherwise
            fprintf('Invalid choice. Please select a valid option.\n\n');
    end
end



