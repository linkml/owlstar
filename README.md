# OWLStar: Ontological Interpretations for Web Property Graphs

This repo holds the [owlstar.ttl](owlstar.ttl) vocabulary. This
vocabulary allows edges in Property Graphs (e.g Neo4j, RDF*) to be
annotated with properties that specify ontological semantics,
including but not limited to OWL-DL interpretations.

It is designed to easily slot in to how people are currently managing
relationships between concepts in both knowledge graphs and
triplestores such as Wikidata.

For general background see: https://douroucouli.wordpress.com/2019/07/11/proposed-strategy-for-semantics-in-rdf-and-property-graphs/

## Quick introduction

the idea is to be able to use Property Graphs (PGs) to encode ontological knowledge in a more precise way.

We use RDF* (RDFStar) as the property graph syntax. The idea is to
write ontological assertions as single edges, such as:

```ttt
<<:finger :part-of :hand>> owlstar:interpretation owlstar:AllSomeInterpretation .
```

Where `finger` and `hand` are classes, and the edge is to be interpreted as "every finger is part of some hand".

This could be encoded and visualized in a standard PG database such as Neo4j as:

![img](https://douroucouli.files.wordpress.com/2019/07/mungalls-ontology-design-guidelines-8.png)

This would be interpreted as the following OWL axiom (written here in Manchester syntax):

```owl
:finger rdfs:subClassOf :part-of some :hand
```

## Why not use RDF OWL layering?

The existing [OWL layering on RDF](https://www.w3.org/TR/owl2-mapping-to-rdf/) is verbose and does not preserve
desirable graph characteristics such as the `finger` and `hand` being
connected by a single edge.

Compare the very verbose standard layering (B) with a more intuitive and compact graph representation (C):

![img](https://douroucouli.files.wordpress.com/2019/07/z.png)

## Advanced

### Temporal and Contextual Logic

See `owlstar:context` in the vocabulary

See also: IKL

The basic idea is to encode contextual information about a statement's interpretation using `os:context`, for example:

```
<<:johnsHeart a :BeatingHeart>> os:context :t1 .
<<:johnsHeart :part-of :john>> os:context :t1 .
:t1 a bfo:TemporalRegion .
```

(here the intent is to represent a state of affairs at a particular
time, and that state of affairs may change - e.g. johns heart may
cease to beat, or it may be transplanted and part of a different
person).

There are different possibilities for interpreting this in First Order Logic, e.g.

```
type(johnsHeart, BeatingHeart, t1)
part_of(johnsHeart, john, t1)
type(t1, TemporalRegion)
```

Although there are other ways: IKL contexts, fluents, ...

There are also different schemes/aaptterns for representing these
using OWL binary predicates, but these tend to be more verbose than
the PG representation, and some suffer from complex problems (e.g. [temporalized relations](https://github.com/cmungall/trel-crit) ).

We can also easily encode complex FOL axioms using simple graph edges; e.g.

```
<<nucleus part-of cell>> os:interpretation os:AllSomeAllTimesInterpretation .
```

This is interpreted as: for every nucleus n, if n exists at t, then there exists some cell c, and n is part of c at t

See [RO 2005 paper](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2005-6-5-r46).

See also: [RO Wiki](https://github.com/oborel/obo-relations/wiki/ROAndTime)



### Probabilistic

In a PG it is natural to annotate edges with confidence or prabiilities, e.g:

```
<<:bob foaf:friendOf :alice>> os:probability 0.9 ^^ xsd:float .
```

(Note that although we use RDF* for syntax, this doesn't work with RDF semantics, see below for discussion)

visual depiction:

![img](https://douroucouli.files.wordpress.com/2019/07/mungalls-ontology-design-guidelines-7.png)

Interpretation:

```
Pr( :bob foaf:friendOf :alice ) = 0.9
```

Note this can be combined with OWL interpretations, e.g:

```
<<:CommonCold :has-symptom :RunnyNode>> 
   owlstar:interpretation owlstar:AllSomeInterpretation ;
   owlstar:probability 0.95 .
```

TODO: elucidate difference between probability of axiom being true via axiom holding for any instance of a cold with a probability of 0.95

Most likely approach is a mapping to CL/IKL structures, e.g.

```
(probability (that (friend-of bob alice)) 0.)9
```

### Other OWL axioms

TODO: compact encoding of restrictions. E.g. `has-diagnosis some Cold SubClassOf has-symptom some Coughing and infected-by some Rhinovirus`

## Semantics

We ignore RDF semantics and treat RDF* as a syntactic encoding of property graph structures.

Semantics are specified in the [owlstar.ttl](owlstar.ttl) vocabulary, via the `owlstar:owlMapping` and `owlstar:folMapping` predicates.

The OWL mapping maps between RDF* structures and RDF triples that have an OWL interpretation through the standard OWL2-RDF mapping

The FOL mapping maps between RDF* structures and Common Logic. TODO elucidate this more.

The decision to abandon RDF semantics may be seen as drastic, but this is both justified and has limited consequences:

 - it is necessary for a compact graph representation, as RDF interpretation of the above RDF* examples will have inconsistent interpretations
 - For most practical purposes, RDF is used as a datamodel, not semantics. When semantics are required we transform to OWL

## TODO

 - Tidy this document then garner more feedback
 - FOL
 - register prefix
 - Derive docs from TTL
 - Provide more examples
 - Provide converters

## FAQ



## See Also

