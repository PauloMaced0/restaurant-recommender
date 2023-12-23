function opcao1(userID, udata, rest)
    for i = 1:length(udata)
        if(udata(i,1) == userID)
            restaurantID = udata(i,2);
            restName = rest{restaurantID, 2};
            concelho = rest{restaurantID, 3};
            fprintf("ID: %-5d Nome: %-25s Concelho: %-20s\n", restaurantID, restName, concelho);
        end
    end
    disp(' ');
end