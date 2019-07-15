% create the labels of the embedded feature vectors
m_labels = [zeros(N_bananas,1);ones(N_apples,1)];

% initialize the embedde feature vectors
m = nan(N_bags,1)';

% generate the feature vectors using bags
for i=1:N_bags
	m(i) = bagembed(bags(i),sigma);
end
dat = prdataset(m,m_labels)

w = liknonc(dat);

dat*w*testc;

