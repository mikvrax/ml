function [h] = citation_kNN(train_bags,labels,test_bags,R,C)
    % compute the distance between the test set and the training set
    test_size = size(test_bags,2);
    train_size = size(train_bags,2);
    dists = nan(test_size,train_size);
    h = nan(test_size,1);
    for i=1:test_size
        for j=1:train_size
            dists(i,j) = hausdorff_dist(test_bags{i},train_bags{j});
        end
    end
    for i=1:test_size
        % pick the R nearest neighbors as references
        [refs, refs_inds] = sort(dists(i,:));
        % pick also the C nearest reciprocal neighbors as citations
        citations = [];
        k=1;
        for j=1:train_size
            temp = dists(:,j);
            [reciprocal,reciprocal_inds] = sort(temp);
            if ismember(i,reciprocal_inds(1:C))
                citations(k) = j;
                k = k + 1;
            end
        end
        refs = refs(1:R);
        refs_inds =refs_inds(1:R);
        % compute positive and negative counts combining references and
        % citations
        p = 0;
        n = 0;
        for j=1:R
            if labels(refs_inds(j)) == 2
                p  = p + 1;
            else
                n = n + 1;
            end
        end
        for j=1:k-1
            if labels(citations(j)) == 2
                p = p + 1;
            else
                n = n + 1;
            end
        end
        % decide on the label based on the majority
        if p > n
            h(i) = 2;
        else
            h(i) = 1;
        end
    end
end
