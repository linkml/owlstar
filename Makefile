all: test

test: owlstar.nt owlstar.ofn

%.nt: %.ttl
	riot $< > $@.tmp && mv $@.tmp $@

%.ofn: %.ttl
	robot convert -i $< -o $@
