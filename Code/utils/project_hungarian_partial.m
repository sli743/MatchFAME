function [ P ] = project_hungarian_partial(S)
    P = eye(size(S, 2));
    [asg, ~] = munkres(-S);
    P = P(asg, :);
end
