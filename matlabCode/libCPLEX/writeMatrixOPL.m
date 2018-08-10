function [] = writeMatrixOPL(fileName, M, MName)

fprintf(fileName, '%s = [', MName);
for i=1:size(M,1) % we write the file by rows
  if i==1
    fprintf(fileName, ' [');
  else
    fprintf(fileName, ', [');
  end
  for j=1:size(M,2)
    if j<size(M,2)
      fprintf(fileName, '%g, ',   M(i,j));
    else
      fprintf(fileName, '%g]',  M(i,j));
    end
  end
end

fprintf(fileName, ' ];\n');

