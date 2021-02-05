% OWLStar: Web Ontology Semantics for RDF* and Property Graphs
% Chris Mungall
% 2020-05-13
% https://github.com/cmungall/owlstar

# OWLStar

## What is it?

 - a standard for adding semantics to [Property Graphs](https://neo4j.com/developer/graph-database/)
    - e.g Neo4j
    - [RDF*](https://blog.liu.se/olafhartig/2019/01/10/position-statement-rdf-star-and-sparql-star/)

## Outline

- ...

# Flavors of graph

:::::::::::::: {.columns}
::: {.column width="50%"}

## RDF Graphs

- triples, e.g. `<s p o>`
- e.g `:bob foaf:friendOf :alice`
- has a defined (basic) semantics
- OWL semantics can be layered on or mapped

:::
::: {.column width="50%"}

## Property Graphs

- edges can have multiple properties
- e.g.

:::
::::::::::::::

## RDF* (RDFStar)

- edges properties in RDF

# Interpreting graphs

- Consider a sentence `:finger :part-of :hand`
- what does this mean, given that "finger" and "hand" are 'repeatable'
   - some fingers are parts of hands
   - every finger is part of some hand
   - the only thing fingers are part of is hands
   - all hands have fingers
   - all of the above

# OWL

- OWL-DL allows for precise statements, e.g. relating classes
- Examples:
   - `:finger SubClassOf (:part-of some :hand)`
      - every finger is part of some hand
   - `:finger SubClassOf (:part-of only :hand)`
      - everything a finger is part of must be a hand
   - `:hand SubClassOf ((inverseOf :part-of) some :finger)`
      - every hand has part some finger

# How can we represent OWL is a graphical form

 - default is via W3C OWL to RDF mapping
    - https://www.w3.org/TR/owl2-mapping-to-rdf/

# Challenges with OWL to RDF mapping


![](https://douroucouli.files.wordpress.com/2019/07/z.png)

# Quick introduction

the idea is to be able to use Property Graphs (PGs) to encode ontological knowledge in a more precise way.

We use RDF* (RDFStar) as the property graph syntax. The idea is to
write ontological assertions ([axioms](https://www.w3.org/TR/owl-primer/#Modeling_Knowledge:_Basic_Notions)) as single edges, such as:

```turtle
<<:finger :part-of :hand>> owlstar:interpretation owlstar:AllSomeInterpretation .
```

Where `finger` and `hand` are classes (e.g from an ontology such as [uberon](http://obofoundry.org/ontology/uberon)), and the edge is to be interpreted as "every finger is part of some hand".

This could be encoded and visualized in a standard PG database such as Neo4j as:

![](https://douroucouli.files.wordpress.com/2019/07/mungalls-ontology-design-guidelines-8.png)

# test

::: incremental

- foo
- bar 
