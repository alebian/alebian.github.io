# Hadoop - The definitive guide

Author: Tom White
ISBN: 978-1-4919-0168-7

## Part I - Hadoop Fundamentals

### Chapter 1 - Meet Hadoop

#### Data Storage and Analysis

Although the storage capacities of hard drives have increased massively over the years, access speeds have not kept up. The obvious way to reduce the time is to read from multiple disks at once.

The first problem to solve is hardware failure: as soon as you start using many pieces of hardware, the chance that one will fail is fairly high.

The second problem is that most analysis tasks need to be able to combine the data in some way, and data read from one disk may need to be combined with data from any of the other 99 disks.

In a nutshell, this is what Hadoop provides: a reliable, scalable platform for storage and analysis.

#### Comparison with other systems

An RDBMS is good for point queries or updates, where the dataset has been indexed to deliver low-latency retrieval and update times of a relatively small amount of data. MapReduce suits applications where the data is written once and read many times, whereas a relational database is good for datasets that are continually updated.

### Chapter 2 - MapReduce

MapReduce works by breaking the processing into two phases: the map phase and the reduce phase. Each phase has key-value pairs as input and output, the types of which may be chosen by the programmer. The programmer also specifies two functions: the map function and the reduce function.

In this case, the map function is just a data preparation phase, setting up the data in such a way that the reduce function can do its work on it. The map function is also a good place to drop bad records: here we filter out data that is missing, suspect, or erroneous.

The output from the map function is processed by the MapReduce framework before being sent to the reduce function. This processing sorts and groups the key-value pairs by key.

#### Scaling out

##### Data Flow

A MapReduce job is a unit of work that the client wants to be performed: it consists of the input data, the MapReduce program, and configuration information. Hadoop runs the job by dividing it into tasks, of which there are two types: map tasks and reduce tasks. The tasks are scheduled using YARN and run on nodes in the cluster. If a task fails, it will be automatically rescheduled to run on a different node.

Hadoop divides the input to a MapReduce job into fixed-size pieces called input splits, or just splits. Hadoop creates one map task for each split, which runs the user-defined map function for each record in the split.

Having many splits means the time taken to process each split is small compared to the time to process the whole input. So if we are processing the splits in parallel, the processing is better load balanced when the splits are small, since a faster machine will be able to process proportionally more splits over the course of the job than a slower machine. Even if the machines are identical, failed processes or other jobs running concurrently make load balancing desirable, and the quality of the load balancing increases as the splits become more fine grained.

On the other hand, if splits are too small, the overhead of managing the splits and map task creation begins to dominate the total job execution time. For most jobs, a good split size tends to be the size of an HDFS block, which is 128 MB by default, although this can be changed for the cluster (for all newly created files) or specified when each file is created.

Hadoop does its best to run the map task on a node where the input data resides in HDFS, because it doesn’t use valuable cluster bandwidth. This is called the data locality optimization. Sometimes, however, all the nodes hosting the HDFS block replicas for a map task’s input split are running other map tasks, so the job scheduler will look for a free map slot on a node in the same rack as one of the blocks. Very occasionally even this is not possible, so an off-rack node is used, which results in an inter-rack network transfer.

The optimal split size is the same as the block size because it is the largest size of input that can be guaranteed to be stored on a single node. If the split spanned two blocks, it would be unlikely that any HDFS node stored both blocks, so some of the split would have to be transferred across the network to the node running the map task, which is less efficient.

Map tasks write their output to the local disk, because since it's an intermediate result, storing it in HDFS with replication would be overkill. If the node running the map task fails before the map output has been consumed by the reduce task, then Hadoop will automatically rerun the map task on another node to re-create the map output.

The number of reduce tasks is specified independently. When there are multiple reducers, the map tasks partition their output, each creating one partition for each reduce task. There can be many keys in each partition, but the records for any given key are all in a single partition. The partitioning can be controlled by a user-defined partitioning function, but normally the default partitioner which buckets keys using a hash function works very well.

Finally, it’s also possible to have zero reduce tasks. This can be appropriate when you don’t need the shuffle because the processing can be carried out entirely in parallel.

##### Combiner Functions

Many MapReduce jobs are limited by the bandwidth available on the cluster, so it pays to minimize the data transferred between map and reduce tasks. Hadoop allows the user to specify a combiner function to be run on the map output, and the combiner function’s output forms the input to the reduce function. Because the combiner function is an optimization, Hadoop does not provide a guarantee of how many times it will call it for a particular map output record, if at all. In other words, calling the combiner function zero, one, or many times should produce the same output from the reducer.

#### Hadoop Streaming

Hadoop provides an API to MapReduce that allows you to write your map and reduce functions in languages other than Java. Hadoop Streaming uses Unix standard streams as the interface between Hadoop and your program, so you can use any language that can read standard input and write to standard output to write your MapReduce program.

Map input data is passed over standard input to your map function, which processes it line by line and writes lines to standard output. A map output key-value pair is written as a single tab-delimited line. Input to the reduce function is in the same format passed over standard input. The reduce function reads lines from standard input, which the framework guarantees are sorted by key, and writes its results to standard output.

For example, in Ruby:

```ruby
STDIN.each_line do |line|
  result_key, result_value = some_calculation
  puts "#{result_key}\t#{result_value}"
end
```

In streaming, the MapReduce framework only ensures that the keys are ordered but, in contrast to the Java API where you are provided an iterator over each key group, you have to find key group boundaries in your program.

### Chapter 3 - The Hadoop Distributed Filesystem

HDFS is a filesystem designed for storing very large files with streaming data access patterns, running on clusters of commodity hardware.

Although this may change in the future, these are areas where HDFS is not a good fit today:
* Low-latency data access: Applications that require low-latency access to data, in the tens of milliseconds range, will not work well with HDFS.
* Lots of small files: Because the namenode holds filesystem metadata in memory, the limit to the number of files in a filesystem is governed by the amount of memory on the namenode. As a rule of thumb, each file, directory, and block takes about 150 bytes. So, for example, if you had one million files, each taking one block, you would need at least 300 MB of memory.
* Multiple writers, arbitrary file modifications Files in HDFS may be written to by a single writer. Writes are always made at the end of the file, in append-only fashion. There is no support for multiple writers or for modifications at arbitrary offsets in the file.

#### HDFS Concepts

##### Blocks

A disk has a block size, which is the minimum amount of data that it can read or write. Filesystems for a single disk build on this by dealing with data in blocks, which are an integral multiple of the disk block size.

HDFS, too, has the concept of a block, but it is a much larger unit — 128 MB by default. Like in a filesystem for a single disk, files in HDFS are broken into block-sized chunks, which are stored as independent units. Unlike a filesystem for a single disk, a file in HDFS that is smaller than a single block does not occupy a full block’s worth of underlying storage.

Having a block abstraction for a distributed filesystem brings several benefits. The first benefit is the most obvious: a file can be larger than any single disk in the network. There’s nothing that requires the blocks from a file to be stored on the same disk, so they can take advantage of any of the disks in the cluster.

Second, making the unit of abstraction a block rather than a file simplifies the storage subsystem. The storage subsystem deals with blocks, simplifying storage management and eliminating metadata concerns.

Furthermore, blocks fit well with replication for providing fault tolerance and availability. To insure against corrupted blocks and disk and machine failure, each block is replicated to a small number of physically separate machines (typically three). If a block becomes unavailable, a copy can be read from another location in a way that is transparent to the client. A block that is no longer available due to corruption or machine failure can be replicated from its alternative locations to other live machines to bring the replication factor back to the normal level.

##### Namenodes and Datanodes

An HDFS cluster has two types of nodes operating in a master−worker pattern: a namenode (the master) and a number of datanodes (workers). The namenode manages the filesystem namespace. It maintains the filesystem tree and the metadata for all the files and directories in the tree. This information is stored persistently on the local disk in the form of two files: the namespace image and the edit log. The namenode also knows the datanodes on which all the blocks for a given file are located; however, it does not store block locations persistently, because this information is reconstructed from datanodes when the system starts.

Without the namenode, the filesystem cannot be used. For this reason, it is important to make the namenode resilient to failure, and Hadoop provides two mechanisms for this. The first way is to back up the files that make up the persistent state of the filesystem metadata (NFS mount). It is also possible to run a secondary namenode, which despite its name does not act as a namenode. Its main role is to periodically merge the namespace image with the edit log to prevent the edit log from becoming too large. The secondary namenode usually runs on a separate physical machine because it requires plenty of CPU and as much memory as the namenode to perform the merge. It keeps a copy of the merged namespace image, which can be used in the event of the namenode failing. However, the state of the secondary namenode lags that of the primary, so in the event of total failure of the primary, data loss is almost certain. The usual is possible to run a hot standby namenode instead of a secondary.

##### Block Caching

Normally a datanode reads blocks from disk, but for frequently accessed files the blocks may be explicitly cached in the datanode’s memory, in an off-heap block cache.

##### HDFS Federation

The namenode keeps a reference to every file and block in the filesystem in memory, which means that on very large clusters with many files, memory becomes the limiting factor for scaling. HDFS federation, allows a cluster to scale by adding namenodes, each of which manages a portion of the filesystem namespace. Under federation, each namenode manages a namespace volume, which is made up of the metadata for the namespace, and a block pool containing all the blocks for the files in the namespace. Namespace volumes are independent of each other, which means namenodes do not communicate with one another, and furthermore the failure of one namenode does not affect the availability of the namespaces managed by other namenodes.

##### HDFS High Availability

The combination of replicating namenode metadata on multiple filesystems and using the secondary namenode to create checkpoints protects against data loss, but it does not provide high availability of the filesystem. The namenode is still a single point of failure (SPOF). To recover from a failed namenode, an administrator starts a new primary namenode with one of the filesystem metadata replicas and configures datanodes and clients to use this new namenode. The new namenode is not able to serve requests until it has:

* Loaded its namespace image into memory.
* Replayed its edit log.
* Received enough block reports from the datanodes to leave safe mode.

Hadoop 2 remedied this situation by adding support for HDFS high availability (HA). In this implementation, there are a pair of namenodes in an active-standby configuration. In the event of the failure of the active namenode, the standby takes over its duties to continue servicing client requests without a significant interruption. A few architectural changes are needed to allow this to happen:

* The namenodes must use highly available shared storage to share the edit log.
* Datanodes must send block reports to both namenodes because the block mappings are stored in a namenode’s memory, and not on disk.
* Clients must be configured to handle namenode failover, using a mechanism that is transparent to users.
* The secondary namenode’s role is subsumed by the standby, which takes periodic checkpoints of the active namenode’s namespace.

There are two choices for the highly available shared storage: an NFS filer, or a quorum journal manager (QJM). The QJM is a dedicated HDFS implementation, designed for the sole purpose of providing a highly available edit log, and is the recommended choice for most HDFS installations. The QJM runs as a group of journal nodes, and each edit must be written to a majority of the journal nodes. Typically, there are three journal nodes, so the system can tolerate the loss of one of them.

###### Failover and fencing

The transition from the active namenode to the standby is managed by a new entity in the system called the failover controller. There are various failover controllers, but the default implementation uses ZooKeeper to ensure that only one namenode is active. Each namenode runs a lightweight failover controller process whose job it is to monitor its namenode for failures and trigger a failover should a namenode fail. Failover may also be initiated manually by an administrator.

Fencing is a method to avoid the previously active namenode (that may be active but looks still) from doing any damage and causing corruption. Examples of fencing methods are: setting up an SSH fencing command that will kill the namenode’s process, revoking the namenode’s access to the shared storage directory, disabling its network port via a remote management command or, as a last resort, the previously active namenode can be fenced with a technique rather graphically known as STONITH (shoot the other node in the head) which uses a specialized power distribution unit to forcibly power down the host machine.

#### Data Flow

> Network Topology and Hadoop: In the context of high-volume data processing, the limiting factor is the rate at which we can transfer data between nodes. The idea is to use the bandwidth between two nodes as a measure of distance.

##### Anatomy of a File Read

The HDFS client calls `open()` to the `FileSystem` object which calls the namenode, using remote procedure calls (RPCs), to determine the locations of the first few blocks in the file. For each block, the namenode returns the addresses of the datanodes that have a copy of that block. Furthermore, the datanodes are sorted according to their proximity to the client. That object returns an `InputStream` to the client for it to read data from.

The client then calls `read()` on the stream, which has stored the datanode addresses for the first few blocks in the file. Data is streamed from the datanodes back to the client in order. When the client has finished reading, it calls `close()` on the `InputStream`.

##### Anatomy of a File Write

Page 108

##### Coherency Model

Page 112

### Chapter 4 - YARN

Page 118

### Chapter 5 - Hadoop I/O

Page 141

### Chapter 6 - Developing a MapReduce Application

Page 190

### Chapter 7 - How MapReduce Works

Page 243

### Chapter 8 - MapReduce Types and Formats

Page 275

### Chapter 9 - MapReduce Features

Page 317

### Chapter 10 - Setting Up a Hadoop Cluster

Page 359

### Chapter 11 - Administering Hadoop

Page 404

### Chapter 12 - Avro

Page 437

### Chapter 13 - Parquet

Page 465

### Chapter 14 - Flume

Page 483

### Chapter 15 - Sqoop

Page 510

### Chapter 16 - Pig

Page 542

### Chapter 17 - Hive

Page 600

### Chapter 18 - Crunch

Page 656

### Chapter 19 - Spark

Page 694

### Chapter 20 - HBase

Page 728

### Chapter 21 - ZooKeeper

Page 767

### Chapter 22 - Composable Data at Cerner

Page 817

### Chapter 23 - Biological Data Science: Saving Lives with Software

Page 831

### Chapter 24 - Cascading

Page 855
