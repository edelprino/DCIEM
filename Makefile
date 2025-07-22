compile:
	gfortran -ffree-form src/main.f90

run:
	make compile 
	./a.out