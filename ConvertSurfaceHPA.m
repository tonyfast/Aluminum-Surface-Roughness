function data = ConvertSurfaceHPA( file, param )
% Convert Mark Stoudt's data to webpages

if nargin == 1
    param = struct('plotpre','');
end

data.surfaceheight = importdata( file );

%% Unbiased effective statistical measure
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
    set( get( hc,'ylabel'),'String', 'Surface Height','VerticalAlignment','Bottom', 'Fontsize',16);
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


% Step in HPA strain experiment
data.step = str2num(regexprep(regexprep(experimentmeta{end},'Strain',''),'F.txt',''));
data.name = regexprep(regexprep(experimentmeta{end},'Strain',''),'F.txt','')

%% Shift the height data to make an image
