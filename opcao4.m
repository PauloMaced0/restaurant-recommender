function opcao4(userID, udata, rest, minhashShingles, shingle_size, shingles_k, avgRatings)
    visitedIds = cell(1,length(udata(userID,2)));
    ind = 1;
    for i = 1:length(udata)
        if(udata(i,1) == userID)
            restaurantID = udata(i,2);
            restName = rest{restaurantID, 2};
            concelho = rest{restaurantID, 3};
            visitedIds{ind} = restaurantID;
            ind = ind + 1;
            fprintf("ID: %-5d Nome: %-25s Concelho: %-20s\n", restaurantID, restName, concelho);
        end
    end
    
    chosenRestaurantID = input('Insert the ID of the desired restaurant: ');
    
    if(ismember(chosenRestaurantID, [visitedIds{:}]))
            tipoCozinha = rest{chosenRestaurantID, 5};
            pratoTipico = rest{chosenRestaurantID, 6};
            if(ismissing(tipoCozinha))
                tipoCozinha = '';
            end
            if(ismissing(pratoTipico))
                pratoTipico = '';
            end
            evaluatedString = lower([tipoCozinha pratoTipico]);

            shinglesIn = {};
        for i = 1:length(evaluatedString) - shingle_size+1
            shingle = evaluatedString(i:i+shingle_size-1);
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
    
        jaccardDistances = ones(1, size(rest, 1));
       
        for i = 1:size(rest, 1)
            if(i == chosenRestaurantID)
                continue
            end
            jaccardDistances(i) = sum(minhashShingles(i, :) ~= MinHashString) / shingles_k;
        end
        
        restaurants = mink(jaccardDistances, 3);
        highestDistance = max(restaurants);
        untieCount = sum(restaurants == highestDistance);
        restaurantsID = [];
        for i = 1:3
            restaurantsID = [restaurantsID find(jaccardDistances == restaurants(i))];
            if(length(restaurantsID) > 3)
                untieRestaurants = find(jaccardDistances == highestDistance);
                % Apply level 2
                toAdd = [];
                for j = 1:untieCount
                    bestRestaurantID = resolveTiesWithRating(untieRestaurants, avgRatings);
                    toAdd = [toAdd bestRestaurantID];
                    untieRestaurants(untieRestaurants == bestRestaurantID) = [];
                end
                if untieCount < 3
                    restaurantsID = [restaurantsID(1,1:3-untieCount) toAdd];
                else
                    restaurantsID = toAdd;
                end
                break
            elseif(length(restaurantsID) == 3)
                break
            end
        end
        disp('Suggested Restaurants: ')
        for i = 1:length(restaurantsID)
            restaurantID = restaurantsID(i);
            restName = rest{restaurantID, 2};
            concelho = rest{restaurantID, 3};
            tipoCozinha = rest{restaurantID, 5};
            pratoTipico = rest{restaurantID, 6};
            if(ismissing(pratoTipico))
                pratoTipico = 'Em falta';
            end
            fprintf("ID: %-5d Nome: %-30s Concelho: %-20s Tipo de Cozinha: %-25s Prato Tipico: %-10s\n", restaurantID, restName, concelho, tipoCozinha, pratoTipico);
        end

        
    else
        disp('The given ID does not belong to any of your visited restaurants');
    end
    disp(' ');
end

function bestRestaurantID = resolveTiesWithRating(restaurants, avgRatings)
    [~, sortedIndices] = sort(avgRatings(restaurants,2), 'descend');
    bestRestaurantID = avgRatings(restaurants(sortedIndices(1)),1);
end
