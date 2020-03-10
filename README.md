# OWLStar: Ontological Interpretations for Web Property Graphs

This repo holds the [owlstar.ttl](owlstar.ttl) vocabulary

See: https://douroucouli.wordpress.com/2019/07/11/proposed-strategy-for-semantics-in-rdf-and-property-graphs/

## TL;DR

the idea is to write RDF* statements such as:

```ttt
<<:finger :part-of :hand>> owlstar:interpretation owlstar:AllSomeInterpretation .
```

Which could be encoded and visualized in a standard PG database such as Neo4j as:

![img](https://douroucouli.files.wordpress.com/2019/07/mungalls-ontology-design-guidelines-8.png)

And to have this interpreted as:

```owl
:finger rdfs:subClassOf :part-of some :hand
```

(manchester syntax)

## Why?

The existing OWL layering on RDF is verbose and does not preserve
desirable graph characteristics such as the finger and hand being
connected by an edge

Standard layering:

![img](https://douroucouli.files.wordpress.com/2019/07/z.png)

## Advanced

### Temporal and Contextual Logic

See `owlstar:context`

See also: IKL

The basic idea is to encode contextual information about a statement's interpretation using `os:context`, for example:

```
<<:johnsHeart a :BeatingHeart>> os:context :t1 .
<<:johnsHeart :part-of :john>> os:context :t1 .
:t1 a bfo:TemporalRegion .
```

interpreted as:

```
type(johnsHeart, BeatingHeart, t1)
part_of(johnsHeart, john, t1)
type(t1, TemporalRegion)
```

We can also easily encode complex FOL axioms using simple graph edges; e.g.

```
"<<nucleus part-of cell>> os:interpretation os:AllSomeAllTimesInterpretation .
```

This is interpreted as: for every nucleus n, if n exists at t, then there exists some cell c, and n is part of c at t

See RO 2005 paper.

### Probabilistic

We can state:

```
<<:bob foaf:friendOf :alice>> os:probability 0.9 ^^ xsd:float .
```

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
(probability (that (friend-of bob alice)) 0.9)
```

### Other OWL axioms

TODO: compact encoding of restrictions. E.g. `has-diagnosis some Cold SubClassOf has-symptom some Coughing and infected-by some Rhinovirus`

## Semantics

We ignore RDF semantics and treat RDF* as a syntactic encoding of property graph structures.

Semantics are specified in the [owlstar.ttl](owlstar.ttl) vocabulary, via the `owlstar:owlMapping` and owlstar:folMapping` predicates.

The OWL mapping maps between RDF* structures and RDF triples that have a standard OWL interpretation

## TODO

 - FOL
 - register prefix
 - Derive docs from TTL
 - Provide more examples
 - Provide converters

## See Also

