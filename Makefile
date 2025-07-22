compile:
	gfortran -ffree-form src/main.f90

run:
	make compile 
	rm NLDIV.LST || true
	./a.out || true
	cat NLDIV.LST