# OWLStar: Ontological Interpretations for Web Property Graphs

This repo holds the [owlstar.ttl](owlstar.ttl) vocabulary. This
proposed vocabulary allows edges in [Property Graphs](https://neo4j.com/developer/graph-database/) (e.g Neo4j, [RDF*](https://blog.liu.se/olafhartig/2019/01/10/position-statement-rdf-star-and-sparql-star/)) to be
augmented with edge properties that specify ontological semantics,
including (but not limited) to [OWL-DL](https://www.w3.org/TR/owl-primer/) interpretations.

This can also be used as an alternative to the [current OWL layering on RDF](https://www.w3.org/TR/owl2-mapping-to-rdf/).

It is designed to easily slot in to how people are currently managing
relationships between concepts in both knowledge graphs and
triplestores such as Wikidata.

For general background see: [proposed strategy for semantics in rdf* and property graphs](https://douroucouli.wordpress.com/2019/07/11/proposed-strategy-for-semantics-in-rdf-and-property-graphs/)

## Browse Ontology Online

 * [owlstar.ttl](owlstar.ttl) - raw turtle files
 * https://cmungall.github.io/owlstar/ - owldoc rendition
 * TODO: online browser

(currently none of these are ideal, I'm looking for better solutions)

## Quick introduction

the idea is to be able to use Property Graphs (PGs) to encode ontological knowledge in a more precise way.

We use RDF* (RDFStar) as the property graph syntax. The idea is to
write ontological assertions ([axioms](https://www.w3.org/TR/owl-primer/#Modeling_Knowledge:_Basic_Notions)) as single edges, such as:

```turtle
<<:finger :part-of :hand>> owlstar:interpretation owlstar:AllSomeInterpretation .
```

Where `finger` and `hand` are classes (e.g from an ontology such as [uberon](http://obofoundry.org/ontology/uberon)), and the edge is to be interpreted as "every finger is part of some hand".

This could be encoded and visualized in a standard PG database such as Neo4j as:

![img](https://douroucouli.files.wordpress.com/2019/07/mungalls-ontology-design-guidelines-8.png)

It could also be rendered in plain RDF (RDF* is syntatic sugar for reification)

This would be interpreted as the following OWL axiom (written here in [Manchester syntax](https://www.w3.org/TR/owl2-manchester-syntax/)):

```owl
:finger rdfs:subClassOf :part-of some :hand
```

The more verbose representation in plain RDF:

```turtle
:finger rdfs:subClassOf [
  a owl:Restriction ;
  owl:onProperty :part-of ;
  owl:someValuesFrom :hand
]
```

## Why not use RDF OWL layering?

The existing [OWL layering on RDF](https://www.w3.org/TR/owl2-mapping-to-rdf/) is verbose and does not preserve
desirable graph characteristics such as the `finger` and `hand` being
connected by a single edge.

Consider the ontology in (A) below. Compare the very verbose standard layering (B) with a more intuitive and compact graph representation (C):

![img](https://douroucouli.files.wordpress.com/2019/07/z.png)

The RDF graph in B is obviously very verbose and unintuitive from a user
perspective. Also it makes certain kinds of logic such as graph
traversal over partonomies more difficult to implement.

Note that many resources therefore choose to encode ontologies using a
scheme like (C), but they typically do this in an unprincipled ad-hoc
way. owlstar is an attempt to provide a formal way to do C.

## OWLStar as a proposed standard

This repo contains the owlstar 'ontology' as a turtle file: [owlstar.ttl](owlstar.ttl)

This is best viewed in Protege, or as a text file.

The URIs are not yet resolvable

The ontology is intended to be self-documenting but the basic idea is
that OWL Axioms can be encoded as far as possible in the most compact
graph form, using edge properties to encode semantics.

For example, the ontology contains the class `AllSomeInterpetation`:

```
os:AllSomeInterpretation rdfs:subClassOf os:LogicalInterpretation ;
  rdfs:label "all-some interpretation modifier" ;
  dc:description "A modifier on a triple that causes the triple to be interpreted as an all-some statement" ;
  os:example "<<finger part-of hand>> os:interpretation os:AllSomeInterpretation -> finger rdfs:subClassOf [a owl:Restriction ; owl:onProperty part-of ; owl:someValuesFrom hand]" ;
  os:owlMapping "<<?s ?p ?o>> os:interpretation os:AllSomeInterpretation -> ?s rdfs:subClassOf [a owl:Restriction ; owl:onProperty ?p ; owl:someValuesFrom ?o]" .
```

The `owlMapping` triple specifies how an edge that has this as a property is to be interpreted (the target is an RDF graph that follows the usual OWL over RDF interpretation). E.g. the edge:

```turtle
<<:finger :part-of :hand>> owlstar:interpretation owlstar:AllSomeInterpretation .
```

Has bindings:

 * `?s` = :finger
 * `?p` = :part-of
 * `?o` = :object

So the RDF* edge would be translated to:

```turtle
?s rdfs:subClassOf [a owl:Restriction ; owl:onProperty ?p ; owl:someValuesFrom ?o]
```

For cases where the PG is encoded in RDFStar or RDF (the former being
syntactic sugar for the latter), it should be straightforward to
implement owlMapping using SPARQLStar or SPARQL constructs (the latter
using the reification vocabulary).

At this time a complete mapping for all of OWL is not complete. We have focused on common constructs.

## Advanced Use Cases

The main driving use case for owlstar is compact encoding of widely
used OWL constructs. The same principles could be used to compactly
encode formal interpretations that go outside OWL-DL, including
temporal, contextual logic, and probabilistic logic.

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

Although there are other ways: [IKL](http://www.ihmc.us/users/phayes/IKL/GUIDE/GUIDE.html) contexts, fluents, ...

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

Most likely approach is a mapping to CL/[IKL](http://www.ihmc.us/users/phayes/IKL/GUIDE/GUIDE.html) structures, e.g.

```
(probability (that (friend-of bob alice)) 0.)9
```

### Other OWL axioms

TODO: compact encoding of GCIs. E.g. `has-diagnosis some Cold SubClassOf has-symptom some Coughing and infected-by some Rhinovirus`

## Semantics

__IMPORTANT NOTE__:
We ignore RDF semantics and treat RDF* as a syntactic encoding of property graph structures.

Semantics are specified in the [owlstar.ttl](owlstar.ttl) vocabulary, via the `owlstar:owlMapping` and `owlstar:folMapping` predicates.

The OWL mapping maps between RDF* structures and RDF triples that have an OWL interpretation through the standard OWL2-RDF mapping

The FOL mapping maps between RDF* structures and Common Logic. TODO elucidate this more.

The decision to ignore RDF semantics in the target graph may be seen as drastic, but this is both justified and has limited consequences:

 - it is necessary for a compact graph representation, as RDF interpretation of the above RDF* examples will have inconsistent interpretations
 - For most practical purposes, RDF is used as a datamodel, not semantics. When semantics are required we transform to OWL

## Mapping OWL to Neo4J and other graph databases.

owlstar takes care of the mapping of OWL-DL to RDF*. As far as I am
aware there is no official mapping of RDF* to Neo4J, but this would
likely be straightforward, with a few caveats. Composing these two
mappings would give a mapping from OWL to Neo4J.

A mapping from RDF* to Neo4J may look like:

 * There would be a one-to-one mapping between RDF* nodes and Neo4J nodes
 * A variety of schemes could be used to map the URI
     * a `uri` node property
     * an `id` or `curie` node property with the CURIEfied URI (assuming global prefix map)
     * both of the above
 * There would be a one-to-one mapping between RDF* edges and Neo4J edges
 * Triples where the subject is a RDF* node and the object is a literal would map to node properties
 * Triples where the subject is a RDF* edge and the object is a literal would map to edge properties
 * Triples where the subject is a RDF* edge and the object is a node would also map to edge properties
      * note that Neo4J does not support true hypergraphs - there is no way to directly point to a node
      * instead the URI of the object would be the property value
 * Blank nodes could be treated as any other RDF* nodes (but these would be less common with owlstar)

A similar approach could be tried for other graph databases, but these
may differ in their data model. E.g. some may allow true hypergraphs.


## TODO

See [milestones](https://github.com/cmungall/owlstar/milestones)

## FAQ

TODO

## See Also

 - [RDF*](https://blog.liu.se/olafhartig/2019/01/10/position-statement-rdf-star-and-sparql-star/)
 - [proposed strategy for semantics in rdf* and property graphs](https://douroucouli.wordpress.com/2019/07/11/proposed-strategy-for-semantics-in-rdf-and-property-graphs/)
 - [obographs](https://douroucouli.wordpress.com/2016/10/04/a-developer-friendly-json-exchange-format-for-ontologies/)
