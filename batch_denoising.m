name_list = {...
'cross', ...
'heart', ...
'horse', ...
'lisa', ...
'pacman', ...
'sapin', ...
'spade', ...
'star5', ...
'trefle', ...
'triskel', ...
'square', ...
'apple', ...
'bart', ...
};

for it=1:length(name_list)
    name = name_list{it};
    fprintf(['########## ' name ' ##########\n']);
    test_denoising;
end