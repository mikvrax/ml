function [apple_error, banana_error] = test_fisher(dat,ratio,K)
    % recreate the bags from the dataset
    [bags,true_labels] = dataset2bags(dat);
    % initialize necessary data structures and variables for training and testing
    N_bags = size(bags,2);
    indices = 1:N_bags;
    apple_error = zeros(K,1);
    banana_error = zeros(K,1);
    N_classes = size(unique(true_labels),1);
    train_size = round(ratio*N_bags);
    test_size = N_bags - train_size;
    
    % perform cross-validation
    for t=1:K
        % pick the training set at random
        random_set = randperm(N_bags,train_size);
        train_set = {};
        for i=1:train_size
            train_set{i} = [];
        end
        train_labels = nan(train_size,1);
        for i=1:train_size
            train_set{i} = bags{random_set(i)};
            train_labels(i) = true_labels(random_set(i));
        end

        % exclude the training set to define the test set
        rest_ind = find(~ismember(indices,random_set));
        test_set ={};
        for i=1:test_size
            test_set{i} = [];
        end
        for i=1:test_size
            test_set{i} = bags{rest_ind(i)};
            test_labels(i) = true_labels(rest_ind(i));
        end
    
        % create the dataset and train the classifier
        dat2 = bags2dataset(train_set,train_labels);
        w = fisherc(dat2);
    
        % test the classifier, combine the labels and store the error of this iteration
        for i=1:test_size
            labels = test_set{i} * w * labeld;
            label = combineinstlabels(labels,N_classes);
            if test_labels(i) ~= label
                if label == 1
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
    title('Naive Classifier error for cross-validation')
    xlabel('Iteration')
    ylabel('Error rate')
    hold on
    plot(banana_error)
    legend('apple', 'banana')
    
    % output error statistics
    mean(apple_error)
    std(apple_error)
    mean(banana_error)
    std(banana_error)
end