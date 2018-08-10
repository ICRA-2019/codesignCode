function [modules,maxNrFeatures] = padTablesWithZeros(modules)

maxNrFeatures = 0;
moduleNames = fieldnames(modules);

%% find max number of features
for i = 1:length(moduleNames)
    module_i = moduleNames{i};
    table = getfield(modules,module_i);
    maxNrFeatures = max([maxNrFeatures size(table,1)]); 
end

%% pad with zeros
for i = 1:length(moduleNames) % for each module
    module_i = moduleNames{i};
    table = getfield(modules,module_i);
    if size(table,1) < maxNrFeatures % has less features than max
        table = [table; zeros(maxNrFeatures - size(table,1), size(table,2))];
        modules = setfield(modules,module_i,table);
    end
end
