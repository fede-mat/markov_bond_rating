function prob = default(type, P, years)
    %DEFAULT Calculates the default probability given a credit rating class
    % Input:
    %   type  - starting rating class (1 for AAA, 22 for D)
    %   P     - transition probability matrix
    %   years - number of years
    % Output:
    %   prob  - probability of default after the specified number of years

    % Ensure the input type is within the valid range
    if type < 1 || type > 22
        error('The input "type" must be between 1 and 22.');
    end

    % Initialize the starting state vector
    dim = size(P, 1); % Assuming P is square, use the first dimension
    v0 = zeros(1, dim);
    v0(type) = 1;

    % Calculate the state distribution after "# years" years
    v = v0 * P^years;

    % Extract the default probability (assumed to be the last state)
    prob = v(22);
end
