function [] = writeScalarOPL(fileName, var, varName, scalarType)

switch scalarType
  case 'float'
    fprintf(fileName, '%s = %g; \n', varName, var);
  case 'int'
    fprintf(fileName, '%s = %d; \n', varName, var);
  otherwise
    error('Invalid scalar type')
end