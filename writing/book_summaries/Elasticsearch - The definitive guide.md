# Elasticsearch - The definitive guide

Authors: Clinton Gormley, Zachary Tong.
ISBN: 978-1-449-35854-9

## Part 1 - Getting Started

Elasticsearch is a real-time distributed search and analytics engine. It allows you to explore your data at a speed and at a scale never before possible. It is used for full-text search, structured search, analytics, and all three in combination

### Chapter 1 - You Know, for Search...

Built on top of Apache Lucene™, a fulltext
search-engine library. But Lucene is just a library, to leverage its power, you need to work in Java and to integrate Lucene directly with your application and is very complex.

Elasticsearch is also written in Java and uses Lucene internally for all of its indexing and searching, but it aims to make full-text search easy by hiding the complexities of Lucene behind a simple, coherent, RESTful API. However, Elasticsearch is much more:

* A distributed real-time document store where every field is indexed and searchable
* A distributed search engine with real-time analytics
* Capable of scaling to hundreds of servers and petabytes of structured and unstructured data

#### Document Oriented

Elasticsearch is document oriented, meaning that it stores entire objects or documents. It not only stores them, but also indexes the contents of each document in order to make them searchable. In Elasticsearch, you index, search, sort, and filter documents —not rows of columnar data.

#### JSON

Elasticsearch uses JavaScript Object Notation, or JSON, as the serialization format for documents.

#### Indexing

The act of storing data in Elasticsearch is called indexing, but before we can index a document, we
need to decide where to store it. In Elasticsearch, a document belongs to a type, and those types live inside an index. You can draw some (rough) parallels to a traditional relational database:

`Relational DB ⇒ Databases ⇒ Tables ⇒ Rows ⇒ Columns
Elasticsearch ⇒ Indexes ⇒ Types ⇒ Documents ⇒ Fields`

An Elasticsearch cluster can contain multiple indexes (databases), which in turn contain multiple types (tables). These types hold multiple documents (rows), and each document has multiple fields (columns).

#### Distributed Nature

Elasticsearch tries hard to hide the complexity of distributed systems. Here are some of the operations happening automatically under the hood:

* Partitioning your documents into different containers or shards, which can be stored on a single node or on multiple nodes
* Balancing these shards across the nodes in your cluster to spread the indexing and search load
* Duplicating each shard to provide redundant copies of your data, to prevent data loss in case of hardware failure
* Routing requests from any node in the cluster to the nodes that hold the data you’re interested in
* Seamlessly integrating new nodes as your cluster grows or redistributing shards to recover from node loss

### Chapter 2 - Life Inside a Cluster

