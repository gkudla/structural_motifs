#!/usr/bin/awk -f

BEGIN{
	MOTIF_SIZE=5
}

/^[0-9]/{
	split($1,a,"-")
	name=a[1]
}

/^[.(]/{
	bpl_cnt=0
	bpr_cnt=0
	len=split($1,structure,"")
	for(i=1;i<=len;i++){
		if(structure[i]=="("){ bpl[++bpl_cnt]=i }
	}
	for(i=len;i>=1;i--){
		if(structure[i]==")"){ bpr[++bpr_cnt]=i }
	}
	for(MOTIF_SIZE=5;MOTIF_SIZE<=10;MOTIF_SIZE++){
		for(j=1;j<=bpl_cnt-MOTIF_SIZE+1;j++){
			for(i=bpl[j];i<=bpl[j+MOTIF_SIZE-1];i++){ printf structure[i] }; printf "&"
			for(i=bpr[j+MOTIF_SIZE-1];i<=bpr[j];i++){ printf structure[i] }; printf "\t" name "\n"
		}
	}
}

