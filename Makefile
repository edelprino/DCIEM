.PHONY: compile run

compile:
	@gfortran -ffree-form -std=legacy src/main.f

test:
	@echo "Running tests..."
	@./run "Impulse Dive - 200ft 30m" | diff --color - "dives/Impulse Dive - 200ft 30m/NLDIV.LST" || (echo "Test failed!" && exit 1)
	@./run "USN Dive Table 150ft 30m" | head -n 11 | diff --color - "dives/USN Dive Table 150ft 30m/NLDIV.LST" || (echo "Test failed!" && exit 1)
	@echo "All tests passed!"

