# AdmbParallelSimEx
## Small example on using a makefile to setup parallel simulations based on an admb model

The idea is that the simulation can be run via the makefile, which keeps track of all the dependencies. Simply running all steps can be done by the command: 
```
make
```

If more cores are available on the system, then the estimations can be run in parallel by using the ` -j ` flag. Assuming 4 cores are available the command would be: 
```
make -j 4
```


 
