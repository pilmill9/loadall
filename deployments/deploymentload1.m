function autoloaddeployment() %load deployments
%load('detections.mat'); 
%assume loaded and have the struct

%tmp=mat2cell(hydrophone_struct(i).location)
    
for i=1:length(hydrophone_struct)
        
        deployment_id=i;
        dd=mat2str(i);
        a=hydrophone_struct(i).location;
        %c=mat2cell(a,1,[1 1]);
        %cc=cell2table(c); 
        depth=mat2cell(hydrophone_struct(i).depth);
        start=hyd(1).detection.calls.julian_start_time;
        endof=hyd(1).detection.calls.julian_end_time;
        
        Start=([hyd(1).detection.calls.julian_start_time]);
        End =([hyd(1).detection.calls.julian_end_time]);
        
        fstart={datestr(Start(1),'YYYY-mm-ddTHH:MM:SS.FFF')};%b1
        
        fend={datestr(End(1),'YYYY-mm-ddTHH:MM:SS.FFF')};%cend
        
xDoc = xmlread(fullfile( 'template.xml'));

tt=table( deployment_id, a(1), a(2), depth, fstart, fend, 'VariableNames', {'DeploymentID', 'Latitude',...
    'Longitude', 'DepthInstrument_m', 'Start', 'End'} );

        filename=sprintf('d%d.xlsx',i);

        command=sprintf('copy template.xlsx d%d.xlsx', i); %'copy template.xlsx  testtest.xlsx';
        dos(command);

        writetable(tt, filename, 'Sheet', 'Deployment');

%'VariableNames', {'Event', 'Start', 'Stop'} );


%filename=sprintf('deployment%d.xml',i);
%xmlwrite(filename,xDoc);

command=sprintf('import.py --file %s --sourcemap deployments --speciesabbreviations SIO.SWAL.v1 --overwrite TRUE Deployments', filename);% 

dos(command);
end
return; 