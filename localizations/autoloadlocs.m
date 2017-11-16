%Loadall  P.Miller July 2017:

%Assumes the input.mat files are organized into two folders: ./localizations and ./detections.
%The root ./ contains the files template.xlsx and program loadall.m . 
%The SourceMap files must be loaded into the database beforehand. 
%The result is that the Tethys dbxml database containers Localizations, Detections, Deployments and Ensembles 
%are populated according to the schema. 

function autoloadlocs()
fdetnames=dir('c:/loadall/detections/*.mat');

fnames = dir('c:/loadall/localizations/*.mat');
numfids = length(fdetnames);
load('c:/loadall/ensembles/array_struct.mat');
load ('c:/loadall/ensembles/hydrophone_struct.mat');   
%load all mat file for localization to be located in ../localizations:
%for k=1:1

%for k=numfids-2:numfids-2
 %for k=1:numfids
for k=1:numfids
   load(fnames(k).name );
   
for i=3:3:length(localize_struct.hyd)

    %load metadata into sheet MetaData
    Objectives='Localization for whale';
    Abstract='Tyler test';
    for j=1:length(array_struct)
        if array_struct(j).master==i %get ensemble name from array_struct
            EnsembleName=j; 
        end
    end
    
    Method='Array';
    Project='Tyler';
    Deployment='PMRF';
    Site='Hawaii';
    [pathstr, name, ext] = fileparts(fnames(1).name);
    Userid=name; 
    Localization_id=i;
    Unit='from ensemble';
    Document=fdetnames(k).name;%associated detection file

    if length(localize_struct.hyd(i).coord_time()) > 0
        date=localize_struct.hyd(i).coord_time(1,1);
        date=datestr(date/86400 +datenum('4/27/2001'),'YYYY-mm-ddTHH:MM:SS.FFF'); %place holder until decoded pm
    else
        date='';
    end 

    u={Objectives, Abstract, EnsembleName, Method, Project, Deployment, Site, Userid, ...
        Localization_id, Unit, date};
    uu=cell2table(u, 'VariableNames', {'Objectives', 'Abstract', 'EnsembleName', 'Method', 'Project', ...
        'Deployment', 'Site', 'Userid', 'Localization_id', 'Unit', 'date'});
    
    
    datetime=datestr(now, 'mmmmdd'); 
    filename=sprintf('loc%s.%d.%d.xlsx',datetime,k,i);
    writetable(uu, filename, 'Sheet', 'MetaData', 'WriteVariableNames', true);

    %load Localize Sheet with Localizations:

    coord=transpose(localize_struct.hyd(i).coordinates); 

    dex=transpose(localize_struct.hyd(i).dex);

    time=localize_struct.hyd(i).coord_time;
    
    %time_1=datestr(time(:,1),'YYYY-mm-ddTHH:MM:SS.FFF');
    %time_2=datestr(time(:,2),'YYYY-mm-ddTHH:MM:SS.FFF');
    %if (date>0)
    if length(localize_struct.hyd(i).coord_time()) > 0
        time_1=datestr(time(:,1)/86400 +datenum('4/27/2001'),'YYYY-mm-ddTHH:MM:SS.FFF'); %pm temp offset
        time_2=datestr(time(:,2)/86400 +datenum('4/27/2001'),'YYYY-mm-ddTHH:MM:SS.FFF');
    else
        time_1=zeros(length(coord),1);
        time_2=zeros(length(coord), 1); 
    end
    
    if ~isempty(time_1)
        time_1=cellstr(time_1);
        time_2=cellstr(time_2);
    end 
    
    trt=table( coord, dex, time_1,time_2 );

    writetable(trt, filename, 'Sheet', 'Localize');

    col_header={'lat', 'long','depth','dex', 'time_1', 'time_2'};
    xlswrite(filename,col_header,'Localize','A1'); 
    
    %Load hydrophone_struct sheet:
    
    out=struct2table(hydrophone_struct);
    writetable(out, filename, 'Sheet', 'hydrophone_struct'); 
    col_header={'name', 'lat', 'long','depth','channel'};
    xlswrite(filename,col_header,'hydrophone_struct','A1'); 
        
    %Load parameters into sheet Parms:

    s=rmfield(localize_struct.parm, 'ssp');
    
    ss=struct2table(s); 
    ss.Document=Document;
   
    writetable(ss,filename, 'Sheet', 'Parms');
   
    %import excel into database using map  --test map 558a, overwrite, leave xlsx files: 
if ~isempty(coord)    
    command=sprintf('import.py --file %s --sourcemap SIO.Loc.v571 --overwrite TRUE Localizations', filename);
    system(command);
end
 
end
end
