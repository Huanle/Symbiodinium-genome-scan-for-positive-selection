from ete3 import Tree
import sys
import re
inf = str(sys.argv[1])
fh = open (inf,"r")
tre=fh.read()
sym=re.findall(r'S[ABCF]\.[0-9]|SC1\.[0-9]',tre)
t=Tree(tre)
check=t.check_monophyly(values=sym, target_attr="name")
if (check[0] is True):
	print inf,  check
else:
        print inf, check
#print inf, t.check_monophyly(values=sym, target_attr="name")


