function [] = writeVectorOPL(fileName, vect, vectName)

fprintf(fileName, '%s = [', vectName);
for i=1:length(vect)
  if i<length(vect)
    fprintf(fileName, '%g, ', vect(i));
  else
    fprintf(fileName, '%g];\n', vect(i));
  end
end

