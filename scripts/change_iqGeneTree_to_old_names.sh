tree=$1
#perl -ne 's/\)\d*:\d*\.\d*/\)/g; s/:\d*\.\d*//g; s/,/\n,/g;  print $_;' $tree | sed 's/_/|/' | perl -ne 'chomp; s/\)\d+/\)/g; print $_;' > ${tree/.**}.original_names.tre  

#same as:perl -ne 's/\)\d*:\d*\.\d*/\)/g; s/:\d*\.\d*//g; s/,/\n,/g; s/\)\d+/\)/g;  print $_;' $tree | sed 's/_/|/' | perl -ne 'chomp; print $_;' > 


sed 's/,/\n/g' $tree | sed 's/_/\|/'| perl -ne 's/\)\d*:\d*\.\d*/\)/g; s/:\d*\.\d*//g; s/\n/,/;print $_;' |perl -pe 's/,$//;' > ${tree/.**}.original_names.tre 
