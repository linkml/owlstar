all: test

test: owlstar.nt owlstar.ofn

%.nt: %.ttl
	riot $< > $@.tmp && mv $@.tmp $@

%.ofn: %.ttl
	robot convert -i $< -o $@

docs/%-slides.pdf: docs/%-slides.md
	pandoc $< -t beamer -o $@
docs/%-slides.pptx: docs/%-slides.md
	pandoc $< -o $@
docs/%-slides.html: docs/%-slides.md
	pandoc $< -s -t slidy -o $@
