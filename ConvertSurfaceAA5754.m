function data = ConvertSurfaceAA5754( file, param )
% Convert Mark Stoudt's data to webpages

if nargin == 1
    param = struct('plotpre','');
end

data.surfaceheight = importdata( file );

%% Unbiased statistical measures
data.averageheight = mean(data.surfaceheight(:));
data.stdheight = std(data.surfaceheight(:));

% Add higher statistics moments because distributions look skew
data.kurtheight = kurtosis(data.surfaceheight(:));
data.skewnessheight = skewness(data.surfaceheight(:));

data.maxheight = max(data.surfaceheight(:));
data.minheight = min(data.surfaceheight(:));


%% Visualize data

if numel(param.plotpre)>0
    pcolor( data.surfaceheight );
    axis equal; shading flat;
    
    % I think b&w is easier on the eyes
    colormap gray
    
    hc = colorbar;
    set( get( hc,'ylabel'),'String', 'Surface Height \mum','VerticalAlignment','Bottom',...
        'Fontsize',16,'Rotation',270);
    xlabel( 'microns','Fontsize',16); ylabel( 'microns','Fontsize',16);
    
    saveas( gcf,sprintf('./assets/%s-1.png', param.plotpre));
    data.image{1} = sprintf('%s-1.png', param.plotpre);
    
    [ yy xx ] = hist( data.surfaceheight(:), 101 );
    plot( xx, yy./sum(yy),'o--k','LineWidth',3)
    xlabel( 'height in microns','Fontsize',16);
    ylabel( 'probability','Fontsize',16);
    saveas( gcf,sprintf('./assets/%s-2.png', param.plotpre));
    data.image{2} = sprintf('%s-2.png', param.plotpre);
end
%% Parse experiment metadata
experimentmeta = strsplit( file,filesep);

% The local in the speciment height information came from
[~, data.experrve] = strtok(strtok(experimentmeta{end},'.'),'_');
% The time(strain) step in teh experiment
if regexp( experimentmeta{end-1},'_' )
    [ ~, data.experinc] = strtok(experimentmeta{end-1},'_');
    % The loading conditions of the experiment
    data.experdirec = experimentmeta{end-2};
    % Smaple name
    data.sampnm = strtok(experimentmeta{end-3},'_data');
    data.experinc = data.experinc(2:end);
    data.experinc = str2num(data.experinc(2:end));
else
    [data.experinc] = strtok(experimentmeta{end-1},'_');
    data.sampnm = strtok(experimentmeta{end-2},'_data');
    data.experdirec = 'none';
    data.experinc = 0;
end

data.name = data.experrve(2:end);
%% Throw an exception at the last file in the Aluminum directory cause I don't know what it is.
% I feel like it is experimental metadata

if strfind( file,'Out.txt')
    for ii = 1 : numel( data.image)
        delete( sprintf('./assets/%s',data.image{ii}));
    end
    clear data
    data.name = file;
    data.description = 'What metadata is in this file?';
end
