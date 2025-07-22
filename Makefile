compile:
	gfortran -ffree-form -std=legacy src/main.f90

run:
	rm -f a.out || true
	make compile 
	rm NLDIV.LST || true
	./a.out || true
	cat NLDIV.LST