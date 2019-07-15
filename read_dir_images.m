function [images] = read_dir_images(directory_name) 
    % store the contents of the directory
    directory_contents = dir(directory_name);
    % read the files contained in the directory(should be images) excluding
    % the entries for . and ..
    N = size(directory_contents,1);
    for i=3:N
        images{i-2} = imread(strjoin({directory_name,directory_contents(i).name},'/'));
    end
end