function [ parameters, costHistory ] = gradient( x, y, parameters, learningRate, repetition )
    %   Main algorithm that tries to minimize our cost functions
    
    % Getting the length of our dataset
    m = length(y);
    
    % Creating a vector of zeros for storing our cost function history
    costHistory = zeros(repetition, 1);
    
    % Running gradient descent
    for i = 1:repetition
        
        % Calculating the transpose of our hypothesis
        h = (x * parameters - y)';
        
        % Updating the parameters simultaneously
        parameters(1) = parameters(1) - learningRate * (1/m) * h * x(:, 1);
        parameters(2) = parameters(2) - learningRate * (1/m) * h * x(:, 2);
        
        % Keeping track of the cost function
        costHistory(i) = cost(x, y, parameters);
        
    end
    
end

