%% Convert all surface data to webpages
% Here's some markup
%
% * list1
% * list2

materials = {'AA5754_data','HPAl_strain_data'};

for mm = 1 : 2
    % cycle over materials
    fldrs = strsplit(genpath( materials{mm} ),':');
    for dd = 1 : numel( fldrs );
        files = dir( fldrs{dd} );
        bf = find(~[files.isdir] & ~ismember({files(:).name},'.DS_Store') );
        
        for ff = 1 : numel(bf)
            if ff == 1
                clear data;
            end
            fn = fullfile( fldrs{dd}, files(bf(ff)).name );
            
            
            param.plotpre = regexprep(files(bf(ff)).name,'.txt','');
            switch materials{mm}
                case 'AA5754_data'
                    % This is a cell array because of dissimilar structures
                    % for differnet files
                    data{ff} = ConvertSurfaceAA5754(fn,param );
                case 'HPAl_strain_data'
                    data(ff) = ConvertSurfaceHPA( fn,param);
            end            
            
        end
        if ff > 1 
            matinpublish( data, 'title', sprintf('%s-folder-data',regexprep(fldrs{dd},filesep,'-')));
            return
        end
        %
        %         strsplit( genpath( fullfile( '.',materials{mm})) )
    end
    
end