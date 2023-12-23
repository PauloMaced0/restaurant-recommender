function Set = createRestaurantSets(u, users)
    Nu = length(users);
    Set = cell(Nu, 1);
    for n = 1:Nu
        ind = u(:, 1) == users(n);
        Set{n} = u(ind, 2);
    end
end