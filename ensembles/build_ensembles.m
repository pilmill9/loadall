function build_ensembles(arrayfile, project, ensemblebasename)
% build_ensembles(arrayfile, project, ensemblebasename)
% Given a SPAWAR arrayfile that contains the variable array_struct
% describing one or more ensembles, generate Excel files suitable
% for importing into an ensemble collection.  Project and deployment
% should correspond to the values associated with the hydrophone
% deployment information.
%
% Each Excel file begins with the string contained in ensemblebasename
% and is followed by _N indicating the position within the array file.
% If ensemblebasename is omitted, the arrayfile name is used.

narginchk(3,4);

ary = load(arrayfile);

% Determine base ensemblename if not provided
if nargin < 2
    % Base ensemble name on filename and position within the array file
    [~,ensemblebasename] = fileparts(arrayfile);
end

% Matlab will issue a warning everytime a new sheet is added.
% Turn it off for the duration of the function
stateAddSheet = warning('query','MATLAB:xlswrite:AddSheet');
warning('off','MATLAB:xlswrite:AddSheet');

for eidx = 1:length(ary.array_struct)
    name = sprintf('%s_%d', ensemblebasename, eidx);  % output file
    destfile = [name, '.xlsx'];
    1;
    
    xlswrite(destfile, {'Name'; name}, 'Name');  % ensemble name
    
    % Build and write unit records
    
    % Units consist of primary and secondary hydrophones
    units = zeros(1 + length(ary.array_struct(eidx).slave), 1);
    for sidx = 1:length(ary.array_struct(eidx).slave)
        units(sidx) = ary.array_struct(eidx).slave(sidx);
    end
    units(end) = ary.array_struct(eidx).master;
    
    
    % As hydrophone numbers are unique, we'll use them as the ID
    projects = cell(length(units), 1);
    projects(:) = cellstr(project);
    sites = strsplit(sprintf('%d\n', units));
    %pm sites(end) = [];  % Empty cell for last \n

    % Assume all ones for now
    deployments = ones(length(units), 1);  
    
    unitdata = cell(length(units)+1, 4);
    unitdata(1,:) = {'ID', 'Project', 'Site', 'Deployment'};
    unitdata(2:end, 1) = num2cell(units);
    unitdata(2:end, 2) = projects;
    unitdata(2:end, 3) = sites;
    unitdata(2:end, 4) = num2cell(deployments);
    
    % Write to sheet Units
    
    command=sprintf('copy template.xlsx %s', destfile); %pm
    dos(command); %pm
    
    xlswrite(destfile, unitdata, 'Units');

   command=sprintf('import.py --file %s --sourcemap SIO.ensemble1 --speciesabbreviations SIO.SWAL.v1 --overwrite TRUE Ensembles', destfile);
   system(command); 
end
% Restore previous warning state
warning(stateAddSheet.state,'MATLAB:xlswrite:AddSheet');


