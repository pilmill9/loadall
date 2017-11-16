function autoloaddetections()

%Function autoloaddetections()

%This function will load all detection files in the current directory.
%The detections are drawn from the matlab hydrophone structure. The matlab 
%input files must be exactly form
%The included template file is template.xlsx and is needed to correctly format 
%the dates for the detections. The output of the function is 
%an excel file that has been created according to the sourcemap for the
%detections. This excel file is then submitted to import.py and the xml for
%the database input is created and then written into the dbxml detections
%container. 

%Image files may be attached to each detection. The image file
%address must be in the sourcemap and the excel. The image files should be
%located in a file named 'documentname'-image. The image files will be
%copied into a gz file that should be stored under the directory of the
%project database (by default in
%\metadata\sourcefiles\detections\'documentname'\Image


%move spec images to compressed folder:
%cd det2-attach
%pwd
%command='c:\test\7z a det2-attach.zip .\Image'
%system(command)


fnames = dir('det*-attach');
numfids=length(fnames);

for i=2:2%pm numfids
   
    command=sprintf('c:\\test\\7z a .\\det%i-attach\\det%i-attach.zip .\\det%i-attach\\Image', i,i,i);
    system(command);
    command=sprintf('./det%i-attach/Image/*', i);
    delete(command)
    %system(command); 
    command=sprintf('move .\\det%i-attach\\det%i-attach.zip .\\det%i-attach\\Image', i,i,i );
    system(command); 
 
end
    

%cd to attach folder % 
%c:\test\7z a det2-attach.zip ./Image %create archive file
%delete ./Image
%create ./Image
%move zip to ./Image

%final: all images are in zips



fnames = dir('c:/loadall/detections/*.mat'); %get the list of detection files
load('c:/loadall/ensembles/hydrophone_struct.mat');
numfids = length(fnames);
cd c:/loadall/detections; 
%for i = 1:numfids
for j=1:1 %pm test on first only numfids %for each detection file
    
    load( fnames(j).name );
    
    %pm test for i=1:1 %length(hyd) %pm just primary hydrophone, ie 1 for first ensemble. %pm test
    for i=1:length(hyd)

        Start=([hyd(i).detection.calls.julian_start_time]);
        End =([hyd(i).detection.calls.julian_end_time]);

        tstart=datestr(Start, 'YYYY-mm-dd HH:MM:SS.FFF') ;
        tend=datestr(End, 'YYYY-mm-dd HH:MM:SS.FFF');

       % tstart=datestr(Start, 'mm-dd-YYYY HH:MM:SS.FFF') ;
       % tend=datestr(End, 'mm-dd-YYYY HH:MM:SS.FFF')

        lengthend=length(tend);
        count=[1:lengthend];
        count=transpose(count);
        count=int2str(count); %pm git 18
        %pm git 18: tt=table( count, tstart, tend, 'VariableNames', {'Count', 'Start', 'Stop'} );
        
        
        %for (ii=1:length(hyd(1).detection.calls))
        %   CM{ii} = ([strcat('http://localhost/images/','fig', num2str(ii), '.png')]); %pm for apache 
        %end; 
            CMA={}; 
            for (ii=1:length(hyd(i).detection.calls))
            %pm test for (ii=1:1)
                %CMA{ii} = ([strcat('C:\loadall\detections\det11-image\','fig', num2str(ii), '.png')]); %pm test
                %CMA{ii} = ([strcat('C:\loadall\detections\det11-image\','fig', num2str(ii), '.png')]); %pm testend;
                CMA{ii} = ([strcat('fig', num2str(ii), '.png')]); %pm test
            end;
                
        CM=char(CMA); 
        
        %tt=table( count, tstart, tend, 'VariableNames', {'Event', 'Start', 'Stop'} ); %pm add cm url to each det
        tt=table( count, tstart, tend, CM, 'VariableNames', {'Event', 'Start', 'Stop', 'Image'} );
        %pm tt=table( count(1,:), tstart(1,:), tend(1,:), CM, 'VariableNames', {'Event', 'Start', 'Stop', 'Image'} );
        
        %filename=sprintf('det%d%d.xlsx',j,i);
        filename=sprintf('det%d.xlsx', i);

        %command=sprintf('copy template.xlsx det%d%d.xlsx', j,i); %'copy template.xlsx  testtest.xlsx';
        [status,msg] = copyfile('template.xlsx', filename); 
        %dos(command);
        %fclose all; 
        %system('taskkill /F /IM EXCEL.EXE'); %pm debug
        if status 
            writetable(tt, filename, 'Sheet', 'Detections');
        end 
        %system('taskkill /F /IM EXCEL.EXE'); %pm debug kill all excel not terminating

        a='PMiller';
        b='hyd';
        c='pmrf';
        d=int2str(i);
        %e='Hawaii';
        e=hydrophone_struct(i).name; %see github
        f=datestr(Start(1),'YYYY-mm-dd HH:MM:SS.FFF');%b1
        g=datestr(End(length(End )),'YYYY-mm-dd HH:MM:SS.FFF');%cend
        h='SIO.SWAL.Detections.AutomaticClicks.v1';
        ii='NOAA.NMFS.v1';
        jj='Generalized Power Law Detector';
        k='Triton';
        l='NA';
         u={a,b,c,d,e,f,g,h,ii,jj,k,l};
         uu=cell2table(u, 'VariableNames', {'User_ID', 'Abstract','Project','Deployment','Site','Effort_Start', 'Effort_End', 'Parser', 'SpeciesAbbreviation', 'Method', 'Software', 'Version'});;
         writetable(uu, filename, 'Sheet', 'MetaData');
         %pm TD: Create URL for cm
         %enter parameters
         param=...  
        table( ...
        hyd(1).detection.parm.sample_freq, ...
        hyd(1).detection.parm.nrec, ...
        hyd(1).detection.parm.xp1, ...
        hyd(1).detection.parm.xp2, ...
        hyd(1).detection.parm.freq_lo, ...
        hyd(1).detection.parm.freq_hi, ...
        hyd(1).detection.parm.sum_freq_lo,...
        hyd(1).detection.parm.sum_freq_hi,...
        hyd(1).detection.parm.whiten,...
        hyd(1).detection.parm.white_x,...
        hyd(1).detection.parm.min_call,...
        hyd(1).detection.parm.max_call,...
        hyd(1).detection.parm.loop,...
        hyd(1).detection.parm.merge,...
        hyd(1).detection.parm.overlap,...
        hyd(1).detection.parm.nbin,...
        hyd(1).detection.parm.fftl,...
        hyd(1).detection.parm.skip,...
        hyd(1).detection.parm.bin_lo,...
        hyd(1).detection.parm.bin_hi,...
        hyd(1).detection.parm.nfreq,...
        hyd(1).detection.parm.sum_bin_lo,...
        hyd(1).detection.parm.sum_bin_hi,...
        hyd(1).detection.parm.noise_ceiling,...
        hyd(1).detection.parm.thresh,...
        hyd(1).detection.parm.template,...
        hyd(1).detection.parm.cut,...
        hyd(1).detection.parm.waveform,...
        hyd(1).detection.parm.cm_on,...
        hyd(1).detection.parm.cm_max_on,...
        hyd(1).detection.parm.cm_max2_on,...
        hyd(1).detection.parm.measurements,...
        hyd(1).detection.parm.slope,...
        hyd(1).detection.parm.filter,'VariableNames', {'sample_freq', 'nrec', 'xp1','xp2', 'freq_lo', 'freq_hi', 'sum_freq_lo', 'sum_freq_hi', 'whiten',...
            'white_x', 'min_call', 'max_call', 'loop', 'merge', 'overlap', 'nbin', 'fftl', 'skip', 'bin_lo', 'bin_hi',...
            'nfreq', 'sum_bin_lo', 'sum_bin_hi', 'noise_ceiling', 'thresh', 'template', 'cut', 'waveform', 'cm_on',...
            'cm_max_on', 'cm_max2_on', 'measurements', 'slope', 'filter'} );
    
         writetable(param, filename, 'Sheet', 'Parms'); 

         a='Unidentified Odontocete';
         b='UO';
         c='Moans';

         u={a,b,c};
         %copy table to table1

         uu=cell2table(u, 'VariableNames',{'Common_Name', 'Species_Code', 'Call'});
         writetable(uu, filename, 'Sheet', 'Effort');
         %pm: TODO: write code to zip the spec files to det%name-attach.zip
         %in the current directory. 
         command=sprintf('import.py --file %s --sourcemap SIO.detdex29 --speciesabbreviations SIO.SWAL.v1 --overwrite TRUE Detections', filename); %throws metadata sheet not found tho dbsubmit correct. 
         %26: good
         %pm workaround sourcemap: command=sprintf('import.py --file %s --sourcemap SIO.detdex27 --overwrite TRUE Detections', filename); %throws metadata sheet not found tho dbsubmit correct. 
         %27: to add CM, cant find all images=error
         system(command);

    end %loop one file

end %load files

return;
