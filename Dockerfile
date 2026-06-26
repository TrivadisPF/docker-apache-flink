ARG FLINK_VERSION=1.20.5
ARG CONFLUENT_VERSION=8.3.0
FROM flink:${FLINK_VERSION}

ARG FLINK_VERSION
ARG CONFLUENT_VERSION

# Install necessary utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    jq \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Add Flink connector dependencies
RUN mkdir -p /opt/flink/lib

# Add necessary connectors for SQL Client
# Kafka connector
# flink-xxxx is for the DataStream API - flink-sql-xxxx is for the Table API & Flink SQL
#RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-kafka/3.4.0-1.20/flink-connector-kafka-3.4.0-1.20.jar
RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/3.4.0-1.20/flink-sql-connector-kafka-3.4.0-1.20.jar
RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/kafka/kafka-clients/3.8.0/kafka-clients-3.8.0.jar

# Avro and Schema Registry support
# flink-xxxx is for the DataStream API - flink-sql-xxxx is for the Table API & Flink SQL
#RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/flink/flink-avro-confluent-registry/${FLINK_VERSION}/flink-sql-avro-confluent-registry-${FLINK_VERSION}.jar
#RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/flink/flink-avro/${FLINK_VERSION}/flink-avro-${FLINK_VERSION}.jar
RUN wget -P /opt/flink/lib https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-avro-confluent-registry/${FLINK_VERSION}/flink-sql-avro-confluent-registry-${FLINK_VERSION}.jar
RUN wget -P /opt/flink/lib https://packages.confluent.io/maven/io/confluent/kafka-avro-serializer/${CONFLUENT_VERSION}/kafka-avro-serializer-${CONFLUENT_VERSION}.jar
RUN wget -P /opt/flink/lib https://packages.confluent.io/maven/io/confluent/kafka-schema-registry-client/${CONFLUENT_VERSION}/kafka-schema-registry-client-${CONFLUENT_VERSION}.jar
RUN wget -P /opt/flink/lib https://packages.confluent.io/maven/io/confluent/common-utils/${CONFLUENT_VERSION}/common-utils-${CONFLUENT_VERSION}.jar

# Hive connector
RUN mkdir -p /opt/flink/lib/hive && \
    wget -P /opt/flink/lib/hive https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hive-3.1.3_2.12/${FLINK_VERSION}/flink-sql-connector-hive-3.1.3_2.12-${FLINK_VERSION}.jar

# AWS connector dependencies
RUN mkdir -p /opt/flink/lib/aws && \
    wget -P /opt/flink/lib/aws https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar && \
    wget -P /opt/flink/lib/aws https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.648/aws-java-sdk-bundle-1.12.648.jar

# Hadoop dependencies
RUN mkdir -p /opt/flink/lib/hadoop && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/com/fasterxml/woodstox/woodstox-core/5.3.0/woodstox-core-5.3.0.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/apache/commons/commons-configuration2/2.1.1/commons-configuration2-2.1.1.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-auth/3.3.2/hadoop-auth-3.3.2.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.3.2/hadoop-common-3.3.2.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-hdfs-client/3.3.2/hadoop-hdfs-client-3.3.2.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-client-core/3.3.2/hadoop-mapreduce-client-core-3.3.2.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/apache/hadoop/thirdparty/hadoop-shaded-guava/1.1.1/hadoop-shaded-guava-1.1.1.jar && \
    wget -P /opt/flink/lib/hadoop https://repo1.maven.org/maven2/org/codehaus/woodstox/stax2-api/4.2.1/stax2-api-4.2.1.jar

RUN chown -R flink:flink /opt/flink/lib
