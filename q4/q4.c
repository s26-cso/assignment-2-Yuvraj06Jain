#include <stdio.h>
#include <dlfcn.h>

typedef int (*fptr)(int,int);

int main()
{
    char op[100]; int a,b;
    while(scanf("%s %d %d",op,&a,&b)==3)
    {
        char libname[200];
        sprintf(libname,"./lib%s.so",op);

        void* handle = dlopen(libname, RTLD_LAZY);
        
        fptr func = dlsym(handle, op);
        
        int res = func(a, b);

        dlclose(handle);

        printf("%d\n",res);
    }

    return 0;
}