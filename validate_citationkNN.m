% get the bags based on the instances
instances2bags = getident(dat,'milbag');

N_bags = size(unique(instances2bags),1);
bag_labels = nan(N_bags,1);
for i=1:N_bags/2
    bag_labels(i) = 1;
end
for i=N_bags/2+1:120
    bag_labels(i) = 2;
end

true_bag_labels = nan(N_bags,1);
dat_labels = getlab(dat);
N_instances = size(dat,1);

% create the bags
bag_label = 1;
j = 1;
bag = [];
w = rand(1,size(dat,2));
ratio = 0.8;
indices = 1:N_bags;
K = 10;
apple_error = zeros(K,1);
banana_error = zeros(K,1);

bags = {};
for i=1:N_bags
    bags{i} = [];
end
for i=1:N_instances
    temp = size(bags{instances2bags(i)},1)+1;
    bags{instances2bags(i)}(temp,:) = +dat(i,:);
end
labels = nan(K,N_bags-round(ratio*N_bags));

R = 2;
C = 4;
for t=1:K
    % get a random training set
    random_set = randperm(N_bags,round(ratio*N_bags));
    train_set = {};
    for i=1:size(random_set,2)
        train_set{i} = [];
    end
    train_labels = nan(round(ratio*N_bags),1);
    for i=1:size(random_set,2)
        train_set{i} = bags{random_set(i)};
        train_labels(i) = bag_labels(random_set(i));
    end
    
    % get the test set
    rest_ind = find(~ismember(indices,random_set));
    test_set ={};
    for i=1:N_bags-size(random_set,2)
        test_set{i} = [];
    end
    for i=1:size(rest_ind,2)
        test_set{i} = bags{rest_ind(i)};
        test_labels(i) = bag_labels(rest_ind(i));
    end
    
    % run the classiifer
    h = citation_kNN(train_set,train_labels,test_set,R,C);
    
    % store the erros
    for i=1:size(test_set,2)
        if test_labels(i) ~= h(i)
            if h(i) == 1
                apple_error(t) = apple_error(t) + 1;
            else
                banana_error(t) = banana_error(t) + 1;
            end
        end
    end
end