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

examples/%.star.ttl: examples/%.std.owl
#	robot query --input $< --update sparql/fwd-add-some-some-values-from.ru query --update sparql/fwd-del-some-some-values-from.ru convert -o $@
	robot query --input $< --update sparql/fwd-add-some-some-values-from.ru -o $@

examples/%.nt: examples/%.ttl
	riot $< > $@.tmp && mv $@.tmp $@
