tic

% Obligation rating transition matrix study. 
% The goal is to analyse the stochastic evolution of US bonds' ratings.

% Importing the matrix:
file_path = 'C:\Users\Fede\OneDrive - Politecnico di Milano\FINANZA MATEMATICA I\extra\markov_bond\tr.xlsx';
sheet_name = 'Foglio2';

transition_table = readtable(file_path, 'Sheet', sheet_name);

transition_matrix = transition_table{:,:};

% Building the Markov Chain:

% Markov Chain's graph:
mc = dtmc(transition_matrix);
figure(1)
graphplot(mc,'ColorEdges',true);
legend('Chain evolution graph')

% Analysing its asymptotic evolution:
v = asymptotics(mc);
figure(2)
plot(1:length(v), v, '*')
grid on
legend('Asymptotic evolution')

% Mean return time
r = 1./v;
figure(3)
plot(1:length(v), r, '*')
legend('Mean return time')

% Default Probability Matrix in n years
n=100;
A=zeros(22,n);
for alfa=1:22
    for i=1:n
            A(alfa,i)=default(alfa,transition_matrix,i); 
    end
end
for alfa=1:22
    plot(A(alfa,:));
    hold on
end
legend("AAA", "AA+", "AA", "AA-", "A+", "A", "A-", "BBB+", "BBB", "BBB-", "BB+", "BB", "BB-", "B+", "B", "B-", "CCC+", "CCC", "CCC-", "CC", "C", "D")

figure(4)
x0 = 100*ones(1,mc.NumStates);
Sim=simulate(mc,100,"X0",x0);
surf(Sim)



toc

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
