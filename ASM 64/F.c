// Mariusz Masztalerczuk
#include<stdio.h>
#include<sys/mman.h>
#include<stdlib.h>
#include<string.h>
typedef unsigned long int ulong;
typedef ulong (*functionpointer)(ulong,ulong,ulong);
ulong A(ulong x, ulong y, ulong z);
ulong B(ulong x, ulong y, ulong z);
ulong C(ulong x, ulong y, ulong z);
ulong Z(ulong x, ulong y, ulong z);
ulong S(ulong x, ulong y, ulong z);
char *registermemory();
void injectCode(char *code, int position, functionpointer *inject);
static char *pmemory;
static int offset=0;
static int tmp;


const char codeA[] = "\x41\x52\x41\x53\x57\x56\x52\xff\x14\x25\x00\x00\x00\x00\x4d\x31\xd2\x49\x89\xc2\x5a\x5e\x5f\x57\x56\x52\xff\x14\x25\x01\x00\x00\x00\x49\x89\xc3\x5a\x5e\x5f\xff\x14\x25\x02\x00\x00\x00\x4c\x89\xde\x4c\x89\xd7\x48\x89\xc2\xff\x14\x25\x03\x00\x00\x00\x41\x5b\x41\x5a\xc3";
const char codeB[] = "\x41\x52\x41\x53\x48\x81\xff\x00\x00\x00\x00\x74\x26\x48\xff\xcf\x4d\x31\xdb\x49\x89\xf3\x49\x89\xfa\xe8\xe2\xff\xff\xff\x48\x89\xc7\x4c\x89\xde\x4c\x89\xd2\xff\x14\x25\x01\x00\x00\x00\x41\x5b\x41\x5a\xc3\x48\x89\xf7\x48\x29\xf6\x48\x29\xd2\xff\x14\x25\x00\x00\x00\x00\x41\x5b\x41\x5a\xc3";
static functionpointer ChangeC(functionpointer *pFun1, functionpointer *pFun2, functionpointer *pFun3, functionpointer *pFun4){
    memcpy(pmemory+offset,codeA,sizeof(codeA));
    injectCode(pmemory, offset+10, pFun2);
    injectCode(pmemory, offset+29, pFun3);
    injectCode(pmemory, offset+42, pFun4);
    injectCode(pmemory, offset+58, pFun1);
    tmp=offset;
    offset+=sizeof(codeA);
    return (functionpointer)(pmemory+tmp);
}

static functionpointer ChangeP(functionpointer *pFunA, functionpointer *pFun1){
    memcpy(pmemory+offset,codeB,sizeof(codeB));
    injectCode(pmemory, offset+42, pFun1);
    injectCode(pmemory, offset+63, pFunA);
    tmp=offset;
    offset+=sizeof(codeB);
    return (functionpointer)(pmemory+tmp);
}



int main(int argc, char* argv[]){
    int i=0;
//    for(i=0;i<250;i++) table[i]=0;
    static functionpointer table[200];
    pmemory = registermemory();

    table['A'] = &A;
    table['B'] = &B;
    table['C'] = &C;
    table['S'] = &S;
    table['Z'] = &Z;
    char in[1024];
    while(1){
	char name;
	char type;

	scanf("%s", in);
	if(!strcmp(in, "---")) break;
		name=in[0];
		type=in[2];
		if(type=='C'){
			functionpointer *g1p = &table[in[6]];
	  		functionpointer *g2p = &table[in[8]];
	  		functionpointer *g3p = &table[in[10]];
	  		functionpointer *gh = &table[in[4]];
	  		table[name] = ChangeC(gh,g1p,g2p,g3p);
		}
		else{
			functionpointer *gp = &table[in[4]];
			functionpointer *gh = &table[in[6]];
			table[name] = ChangeP(gp,gh);
		}

	}
     ulong a,b,c;char name;
  //   while(scanf("%s", in)+1){
     fgets(in,1024,stdin);
     while(fgets(in,1024,stdin)!=NULL){
    	sscanf(in, "%c(%ld,%ld,%ld)", &name, &a, &b, &c);
//	printf("%c %ld %ld %ld\n", name, a, b, c);
     	printf("%ld\n",(long int)(functionpointer)(table[name])(a,b,c));
     }
    return 0;

}


ulong A(ulong x, ulong y, ulong z){
    return x;
}

ulong B(ulong x, ulong y, ulong z){
    return y;
}

ulong C(ulong x, ulong y, ulong z){
    return z;
}

ulong Z(ulong x, ulong y, ulong z){
    return 0;
}

ulong S(ulong x, ulong y, ulong z){
    return x+1;
}


char *registermemory(){
	char *pmemory=(char*)mmap(0, 10000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	return pmemory;
}

void injectCode(char *code, int position, functionpointer *inject){
    *((int*)(code+position)) = *(int*)&inject;
}
