
all:  obj/mozzonid

check: obj/mozzonid
	python -m unittest discover -s acceptance

clean:
	rm -rf obj && mkdir obj


obj/mozzonid:
	gprbuild


.PHONY: all build check clean
