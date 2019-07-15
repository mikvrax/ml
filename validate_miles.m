function [apple_error, banana_error] = test_miles(dat,ratio,K,sigma)
    % recreate the bags from the dataset
    [bags,true_labels] = dataset2bags(dat);
    % initialize necessary data structures and variables for training and testing
    N_bags = size(bags,2);
    indices = 1:N_bags;
    apple_error = zeros(K,1);
    banana_error = zeros(K,1);
    m = nan(N_bags,size(dat,1));
    train_size = round(ratio*N_bags);
    test_size = N_bags - train_size;
    
    % generate the embedded feature vectors
    for i=1:N_bags
        m(i,:) = bagembed(bags{i},sigma,dat);
    end
    
    % perform cross-validation
    for t=1:K
        % pick a random training set
        random_set = randperm(N_bags,train_size);
        train_set = m(random_set,:);
        train_labels = true_labels(random_set);
    
        % define the test set by excluding the training set
        rest_ind = find(~ismember(indices,random_set));
        test_set= m(rest_ind',:);
        test_labels = true_labels(rest_ind');
    
        % train the liknonc classifier
        w = liknonc(prdataset(train_set,train_labels));
        
        % test the classifier
        labels = test_set * w * labeld;
    
        % store the error of this iteration
        for i=1:test_size
            if test_labels(i) ~= labels(i)
                if labels(i) == 1
                    apple_error(t) = apple_error(t) + 1;
                else
                    banana_error(t) = banana_error(t) + 1;
                end
            end
        end
    end
    
    % plot of the errors in each class over all iterations
    apple_error = apple_error./test_size;
    banana_error = banana_error./test_size;
    plot(apple_error)
    title('Miles Classifier error for cross-validation')
    xlabel('Iteration')
    ylabel('Error rate')
    hold on
    plot(banana_error)
    legend('apple', 'banana')
    
    % output error statisticsx
    mean(apple_error)
    std(apple_error)
    mean(banana_error)
    std(banana_error)
end