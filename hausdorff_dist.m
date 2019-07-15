function [H] = hausdorff_dist(A,B)
    % get the 2-norm between each instance of B and A
    dists = zeros(size(B,1),size(A,1));
    for i=1:size(B,1)
        for j=1:size(A,1)
            %dists(i) = dists(i) + sum(abs(B(i,:) - A(j,:)));
            dists(i,j) = norm(B(i,:) - A(j,:));
        end
    end
    % pick the instance of B with the minimum distance
    minB = min(dists);
    % pick the instance of A with the minimum distance
    minA = min(minB);
    h_AB = minA;
    % repeat the process using A first
    dists3 = zeros(size(A,1),size(B,1));
    for i=1:size(A,1)
        for j=1:size(B,1)
            dists3(i,j) = norm(A(i,:) - B(j,:));
        end
    end
    minA2 = min(dists3);
    minB2 = min(minA2);
    h_BA = minB2;
    % keep the maximum(should be the same)
    H = max(h_AB,h_BA);
end