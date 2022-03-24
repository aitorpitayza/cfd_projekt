%CONECTIVIDAD ENTRE CELDAS
%si alguien entiende esto que venga dios y lo vea
for i=1:length(cells)
   faces_i=faces(i);
   for j=1:length(faces_i)
      for k=1:length(cells)
         if (k != i)
             faces_k=faces(k);
             for l=1:length(faces_k)
                if (faces_i(j)==faces_k(l))
                    connectivity(i,j)=k;
                end
             end
         end
      end
   end
end