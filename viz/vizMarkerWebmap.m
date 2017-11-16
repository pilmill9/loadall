function vizMarkerWebmap(varargin)

%This function loads the load localization file and displays the webmap.
%The mapping outputs are kml or webmap.
%The options for marker coloring are according to the depth or the time.

%For a demo use vizMarkerWebmap without arguments
%The required input is the lat/long position as a double array 
%and optionally the depth or time of the position.

%Called from vizMapLocations. 

nVarargs = length(varargin);
 
if nVarargs>0
    pos=varargin{1}; %pm an array with lat and long
    time=varargin(2);
    cm=varargin(3); %get spectrogram for demo
    depth=varargin(4);%pm: depth=cell2mat(varargin(4))
    kml=varargin(5); %pm an array with logicals for cm (webmap) and kml (google earth) 
else
    pos='';
    time='';
    cm='';
    depth='';
    kml='';
end 

if cell2mat(depth)
    depth=cell2mat(varargin(4)); 
end ; 

if (~isempty(pos))
    %get the array of data.
    
   % depth=zeros(size(pos(:,1))); 
    
    if ( ~isempty(depth) )
        posit=[pos depth];
    else
        posit=horzcat(pos, num2cell(depth));
    end 
end

coordarray=posit;
if(isempty(depth))
        coordarray=pos; %pm test
end
    % coordarray(:,:,3)=1; 
    %coordarray=transp(coordinates);
    
if( size(pos,2)==3 )
        %tt=struct('Latitude', coordarray(:,1), 'Longitude',coordarray(:,2), 'Depth', coordarray(:,3) );
        tt=struct('Latitude', pos(:,1), 'Longitude',pos(:,2), 'Depth', pos(:,3) );
    elseif ( size(pos,2)==2 ) 
        tt=struct('Latitude', coordarray(:,1), 'Longitude',coordarray(:,2));
end

if( ~isempty(depth))
        tt=struct('Latitude', coordarray(:,1), 'Longitude',coordarray(:,2), 'Depth', coordarray(:,3) );
end   
    
if(~isempty(time{1}))
        timearray=cell2mat(time); 

        t1 = datenum(2013,11,1,8,0,0);
        t2 = datenum(2013,11,14,8,0,0);
        t=t1:t2;
        t=transpose(t); 

        aa=char(time);
        %aa=datenum(aa,  'yyyy-MM-ddTHH:mm:ss.000'); pm debug
        %aa=datenum(aa,  'yyyy-mm-ddTHH:HH:SS.000'); pm debug
        aa=datenum(aa,  'yyyy-mm-ddTHH:MM:SS');

        if( ~isempty(time) && ~isempty(time{1}) )
             tt=struct('Latitude', coordarray(:,1), 'Longitude',coordarray(:,2), 'Time', aa);
        end
end 

    % tmp=cell(size(tt)); 
    %[tt(:).Depth]=deal(tmp{:})
    %tt=setfield(tt,'Depth', 0)
   % for(i=1:size(tt.Longitude)) 
   %     tt(i).Depth=0;
    %end 
    %ss=struct2table(tt);
%elseif(isempty(cm) || isempty(cm{1}) )
   % load('PMRF_localizations_04Feb15_175526__all14_timed1_134.mat'); %pm TD: make an input generated from start time
    %coordarray=transp(localize_struct.hyd(3).coordinates); %pm lat long depth for the hydrophone
    %dexs=transp(localize_struct.hyd(3).dex); %pm the dex for the associated detections
    %coordarray=transp(coordinates);
    %coordarray=[coordarray dexs]; 
    %tt=struct('Latitude', coordarray(:,1), 'Longitude',coordarray(:,2), 'Depth',  coordarray(:,3));
    %ss=struct2table(tt);
%{
else %run demo of cmmax
    load('PMRF_localizations_04Feb15_175526__all14_timed1_134.mat'); 
    load('PMRF_detections_04Feb15_175526__all14_timed1_134');%pm TD: make an input generated from start time
    coordarray=transp(localize_struct.hyd(3).coordinates);
    dexs=transp(localize_struct.hyd(3).dex); %pm the dex for the associated detections
    %coordarray=transp(coordinates);
    coordarray=[coordarray dexs]; %pm lat/long 
    %allcmmax=[hyd(3).detection(1).calls.cm_max]; 
   % coordarray=[coordarray allcmmax.values]
   allcmmax=[hyd(3).detection(1).calls.cm_max]; 
        dd=size(allcmmax);
        
        ee=size(dexs);
        selectcmmax=[];
        count=0;
           for j= 1:ee(1)
               for i=1:dd(2)

                   if dexs(j)==i
                    %display(dexs(j));
                    %display(j);
                    %display(i);
                    count=count+1;
                    %display(allcmmax(j)); 
                    %allcmmax(j).dex=dexs(j); 
                    allcmmax(j).line=j;
                    selectcmmax=[selectcmmax allcmmax(j).line];
                   end
               end
           end
    tt=struct('Latitude', coordarray(:,1), 'Longitude',coordarray(:,2), 'CM',  dexs);
%all cmmax corresponding to detections  
end
%}

%figure
%worldmap world
%geoshow( ss.Latitude,  ss.Longitude, 'DisplayType', 'Line')
%plot3m(ss.Latitude, ss.Longitude, ss.Depth, 'r-');
%showplot(); 

%map using color map. 

if (pos)
   % maxd=max(coordarray(:,3));
    %for i=1:size(pos) %196 %pm map by depth light aqua to dark blue
     %   D(i,1)=0;
      %  D(i,2)=1-(coordarray(i,3)/maxd)^.2;
          %pm changed to 3 with db query for depth
       % D(i,3)=1-(coordarray(i,3)/maxd);
    %end
    
    maxd=max(coordarray(:,3));
    for i=1:size(pos)
        if ( coordarray(i,3) < maxd/3 )
            D(i,1)=240/255;
            D(i,2)=255/255;
            D(i,3)=20/255;
        end
        if ((coordarray(i,3) >=maxd/3)  && (coordarray(i,3) <maxd/3))
            D(i,1)=240/255; 
            D(i,2)=130/255;
            D(i,3)=20/255;
        end
        if ( coordarray(i,3) >=maxd/3 )  
            D(i,1)=180/255; 
            D(i,2)=0/255;
            D(i,3)=20/255;
        end
        
       end   
    
end
    
if( ~isempty(kml{1}) ) %change to t/f
    kmlfile=sprintf( ['<?xml version="1.0" encoding="UTF-8"?> ' ...
    '<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" ' ...
    'xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom"> <Document> '] );

    cmm=char(cellstr(cm));
    new='';

    for ii=1:length(pos)  %pm load all 25 ->2000 for feb 4. check dates.
        %time1=char( cellstr(time(ii) ));
        %color='50f0'; 
        %color1=rgb2hex(D(ii,:));
        
        %color1=lower(strrep(color1,'#',''));
        %color1=color1(3:end);
         
        %color=strcat(color,color1); 
        if ( coordarray(ii,3) < maxd/3 )
           %color='50F0F514';
           color='64F0FF14';
           color='5014F0FF';
        end
        if ( (coordarray(ii,3) >=maxd/3)  &&  (coordarray(ii,3) < 2*maxd/3 ) )
            %color='50F08D14';
            color='64F0C814';
            color='5078D23C';
        end
        if ( coordarray(ii,3) >=2*maxd/3 )  
            %color='50F00014';
            color='64F00014';
            color='50001E14';
        end        
        
      %  addin= sprintf( [ '<Placemark><name> %.2f meters color=%s </name>' ...     
      %     '<description><![CDATA[<img style="max-width:500px;" src="%s">]]></description>' ...
      %    '<Style ><IconStyle><color>%s</color></IconStyle></Style>' ...
      %     '<Point> ' ...
      %     '<coordinates>%f,%f,%f</coordinates> ' ... 
      %      '</Point> </Placemark>'], depth(ii), color, cmm(ii,:), color, pos(ii,2), pos(ii,1), depth(ii) ); 
        
         addin= sprintf( [ '<Placemark><name> %.2f meters </name>' ...     
           '<description><![CDATA[<img style="max-width:500px;" src="%s">]]></description>' ...
           '<Style ><IconStyle><color>%s</color></IconStyle></Style>' ...
           '<BalloonStyle><text>$[description]</text></BalloonStyle><Point> ' ...
           '<coordinates>%f,%f,%f</coordinates> ' ... 
            '</Point> </Placemark>'], depth(ii), cmm(ii,:), color, pos(ii,2), pos(ii,1), depth(ii) ); 
                
       new=strcat(new, addin);
        %pm add in points here: 
end
  
    new=strcat(new, '</Document></kml>') ;

kmlfile=strcat(kmlfile, new); 

fi=clock;
finame=sprintf('kmlout.%i.%i.%i.%i.kml',fi(1),fi(2),fi(3),fi(4));
fid = fopen(finame,'wt');
%fid = fopen('kmltestout3.kml','wt');
fprintf(fid, '%s', kmlfile);
fclose(fid);
%winopen('kmltestout3.kml');
winopen(finame); 
end
%return; %display kml and end


if( isempty( kml{1} ) )
    p=geopoint(tt);

%Create an attribute spec and modify it to define a table of values to display in the feature balloon, including year, cause, country, location, and maximum height. The attribute spec defines the format of the expected value for each field.

%attribspec = makeattribspec(p);

%desiredAttributes = ...
       %{'Max_Height', 'Cause', 'Year', 'Location', 'Country'};
%allAttributes = fieldnames(attribspec);
%attributes = setdiff(allAttributes, desiredAttributes);
%attribspec = rmfield(attribspec, attributes);
%attribspec.Max_Height.AttributeLabel = '<b>Maximum Height</b>';
%attribspec.Max_Height.Format = '%.1f Meters';
%attribspec.Cause.AttributeLabel = '<b>Cause</b>';
%attribspec.Year.AttributeLabel = '<b>Year</b>';
%attribspec.Year.Format = '%.0f';
%attribspec.Location.AttributeLabel = '<b>Location</b>';
%attribspec.Country.AttributeLabel = '<b>Country</b>';
%Create a web map, specifying the base layer. Then add the marker overlay. In the illustration, note the table containing the data you specified in the attribute spec.
%geoshow(p, 'DisplayType', 'surface')

webmap('ocean basemap');

color=[.9,.9,.9];
%colors(:196)=.9;
col(196,1)=.9;
col(196,2)=.9;
col(196,3)=.9;
col(:,:)=.9;
col(196,1)=.1;
%pm create series
for i=1:196 %pm map by sequence
    B(i,1)=1;
    B(i,2)=i/200;
    B(i,3)=0;
end

if (pos)
    maxd=max(coordarray(:,3));
else
    maxd=max(localize_struct.hyd(3).coordinates(:));
end 

if (pos)
    for i=1:size(p) %196 %pm map by depth light aqua to dark blue
        D(i,1)=0;
        D(i,2)=1-(coordarray(i,3)/maxd)^.2;
          %pm changed to 3 with db query for depth
        D(i,3)=1-(coordarray(i,3)/maxd);
    end    
else
    for i=1:size(p) %196 %pm map by depth light aqua to dark blue
        D(i,1)=0;
        D(i,2)=1-(localize_struct.hyd(3).coordinates(3,i)/maxd)^.2;
        D(i,3)=1-(localize_struct.hyd(3).coordinates(3,i)/maxd);
    end
end

%{
if(~isempty(time) && ~isempty(time{1}) )
    maxd=max(aa);
    mind=min(aa);
   
    for i=1:size(p) %196 %pm map by depth light aqua to dark blue map for time
        D(i,1)=tt.Time(i)/(maxd+1);
        if i==1
            D(i,2)=1-( aa(i) ) /(maxd+1) ;
        else
            D(i,2)=(1- abs( aa(i)-aa(i-1) ) ^1.7  /aa(i) ) ;
            if D(i,2)>1
                D(i,2)=1;
            end
        end
        D(i,3)=abs(1-(( aa(i) )^1.1/(maxd+1)));
        if D(i,3)>1
            D(i,3)=1;
        end        
    end
end
%}

%{
aa=depth; 
mind=min(depth);
maxd=max(depth); 

if(max(depth)>0)
    for i=1:size(p) 

        D(i,1)=(1-((aa(i)-mind)*100)/(maxd+1));
        D(i,2)=(((aa(i)-mind)*40)/(maxd+1))^.01;
        D(i,3)=1-(((aa(i)-mind)*5))^1.1/(maxd+1); 
    end

    for i=1:10
        C(i,1)=i/10;
        C(i,2)=1;
        C(i,3)=1;
    end
end
%}

attribspec = makeattribspec(p);

if(~isempty(depth))
    desiredAttributes = {'Depth'};
    p.Depth=depth;
end

if(~isempty(time) && ~isempty(time{1}) )
    desiredAttributes = {'Time'};
    gg=char(time);
    
    mm=cellstr(gg);
    p.Time=cellstr(mm);
end 

if(~isempty(cm) && ~isempty(cm{1}) )
    desiredAttributes = {'CM'};
    gg=char(cm); 
    mm=cellstr(gg);
   
    for i=1:length(mm)
        mm(i)={strcat('<a href=" ', mm(i,:),'"',{' '}, 'target="_blank">',mm(i,:),'</a>')};
        cel(i)=cellstr(mm{i,:});
    end
   p.CM=cel;
end 

%pm insert spectrogram pointer here, as option

%if spect
% get the dex
%get the detection
%extract the cm
%make a plot and display it at mouse over

allAttributes = fieldnames(attribspec);
attributes = setdiff(allAttributes, desiredAttributes);
attribspec = rmfield(attribspec, attributes);

if( ~isempty(pos) && isempty(time) ) %pm no depth yet in the database, TD: update schema, add depth. 
attribspec.Depth.AttributeLabel = '<b>Depth</b>';
attribspec.Depth.Format = '%.2f Meters';
end

if( ~isempty(pos) && ~isempty(depth) ) %pm no depth yet in the database, TD: update schema, add depth. 
attribspec.Depth.AttributeLabel = '<b>Depth</b>';
attribspec.Depth.Format = '%.2f Meters';
end

if(~isempty(time) && ~isempty(time{1})) %pm no depth yet in the database, TD: update schema, add depth. 
attribspec.Time.AttributeLabel = '<b>Time</b>';
attribspec.Time.Format = '%s';
end

if(~isempty(cm) && ~isempty(cm{1})) %pm no depth yet in the database, TD: update schema, add depth. 
attribspec.CM.AttributeLabel = '<b>CM</b>';
attribspec.CM.Format = '%s ';
end

%pm new attribute spec: calculate from hyd cm_max and unzip spectro,
%init->just scatter
%if( (maxd>0) && isempty(time) )
%wmmarker(p, 'color', D, 'Description', attribspec, 'OverlayName', 'PMRF:Localizations');
%elseif(time{1})
%wmmarker(p, 'color', D, 'Description', attribspec, 'OverlayName', 'PMRF:Localizations'); 
%else
%wmmarker(p, 'color', D);
%end
if(~isempty(cm) & ~isempty(depth{1}) ) %pm depth<1
    wmmarker(p, 'Description', attribspec, 'OverlayName', 'PMRF:Localizations');

else
    wmmarker(p, 'color', D, 'Description', attribspec, 'OverlayName', 'PMRF:Localizations');
end
%mapview();
%wmmarker(p, 'color', jets );
wmzoom(12); %max zoom for ocean basemap 
%wmprint();
end