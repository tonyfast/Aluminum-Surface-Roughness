%% Convert all surface data to webpages
% Here's some markup
%
% * list1
% * list2

materials = {'AA5754_data','HPAl_strain_data'};

for mm = 2
    % cycle over materials
    fldrs = strsplit(genpath( materials{mm} ),':');
    for dd = 1 : numel( fldrs );
        files = dir( fldrs{dd} );
        
        % Add a statement to only look at text files, the directory
        % structures are different for AA5754
        bf = find(~[files.isdir] & ~ismember({files(:).name},'.DS_Store') & ...
            cellfun(@(x)numel(strfind(x,'.txt'))>0, {files(:).name}) );
        
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
                    % Add tags to data for web
                case 'HPAl_strain_data'
                    data(ff) = ConvertSurfaceHPA( fn,param);
                    
            end            
            
            
        end
        if ff > 1 
            
            %% Adding tags to datasets
            % Happens at the function level call, it is not part of the
            % data structure.
            
            %asdflasdjflkjahsdlfkjas;ldkjf;laskjdfl;
            % This is a middle index and its a huge hack
            ff = 3; % This is a middle index and its a huge hack
            %asdflasdjflkjahsdlfkjas;ldkjf;laskjdfl;
            if iscell(data)
                tags = { data{ff}.experdirec data{ff}.sampnm};
            else
                tags = { materials{mm} };
            end
            matinpublish( data, 'title', sprintf('%s-folder-data',regexprep(fldrs{dd},filesep,'-')),...
                'tags',tags);
%             return% Debugging statement
        end
        %
        %         strsplit( genpath( fullfile( '.',materials{mm})) )
    end
    
end